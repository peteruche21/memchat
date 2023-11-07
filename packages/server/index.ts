import Irys from "@irys/sdk";
import cors from "cors";
import express, { Request, Response } from "express";
import fileUpload, { UploadedFile } from "express-fileupload";
import passport from "passport";
import { Strategy } from "passport-http-header-strategy";

import dotenv from "dotenv";

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;
const NODE_URL = process.env.NODE_URL || "https://devnet.irys.xyz";
const TOKEN = process.env.TOKEN || "matic";
const RPC_PROVIDER = process.env.RPC_PROVIDER || "https://rpc.ankr.com/polygon";
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const API_KEY = process.env.API_KEY;

if (!PRIVATE_KEY || !API_KEY) {
  console.error("Please set the PRIVATE_KEY and API_KEY env variable");
  process.exit(1);
}

app.use(
  fileUpload({
    limits: { fileSize: 250 * 1024 * 1024 },
    abortOnLimit: true,
    responseOnLimit: "File size exceeds limit of 250MB",
    useTempFiles: true,
  })
);
app.use(cors());
app.use(passport.initialize());

passport.use(
  new Strategy(
    {
      header: "x-mem-token",
    },
    (token, done) => {
      if (token === API_KEY) {
        done(null, true, { scope: "all" });
      } else {
        done(null, false);
      }
    }
  )
);

type Tag = {
  name: string;
  value: string;
};

const getPrices = async (numBytes: string) => {
  const numBytesInt = parseInt(numBytes);
  const priceAtomic = await irys.getPrice(numBytesInt);
  const priceConverted = irys.utils.fromAtomic(priceAtomic);
  return { priceAtomic, priceConverted };
};

const irys = new Irys({
  url: NODE_URL,
  token: TOKEN,
  key: PRIVATE_KEY,
  config: { providerUrl: RPC_PROVIDER },
});

app.get("/cost", async (req: Request, res: Response) => {
  const numBytes = req.query.bytes as undefined | string;

  if (numBytes === undefined) {
    res.status(400).json({
      ok: false,
      error: "numBytes must be greater than 0",
    });
    return;
  }

  const { priceAtomic, priceConverted } = await getPrices(numBytes);

  res.status(200).json({ price: priceConverted, atomic: priceAtomic });
});

app.post(
  "/upload",
  passport.authenticate("header", {
    session: false,
    failWithError: true,
  }),
  async (req: Request, res: Response) => {
    if (!req.files || Object.keys(req.files).length === 0) {
      return res.status(400).json({
        ok: false,
        message: "No files were uploaded",
      });
    }

    const tags: Tag[] = req.body?.tags ? JSON.parse(req.body.tags) : [];
    const file = req.files.memFile as UploadedFile;
    const size = file.size;

    const contentTypeTag = tags.find(
      (tag) => tag.name.toLowerCase() === "Content-Type".toLowerCase()
    );
    if (contentTypeTag) {
      contentTypeTag.value = file.mimetype;
    } else {
      tags.push({ name: "Content-Type", value: file.mimetype });
    }

    const { priceAtomic } = await getPrices(size.toString());

    try {
      await irys.fund(priceAtomic);

      const uploader = irys.uploader.chunkedUploader;

      const response = await uploader.uploadData(file.data, {
        tags,
      });

      return res.status(200).json({
        ok: true,
        message: "File uploaded successfully",
        url: `https://gateway.irys.xyz/${response.data.id}`,
      });
    } catch (error) {
      return res.status(500).json({
        ok: false,
        message: "Unable to upload file to irys",
        error: error,
      });
    }
  }
);

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
