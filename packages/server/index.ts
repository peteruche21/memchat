import Irys from "@irys/sdk";
import cors from "cors";
import express, { Request, Response } from "express";
import fileUpload, { UploadedFile } from "express-fileupload";
import passport from "passport";
import { Strategy } from "passport-http-header-strategy";
import { SecretManagerServiceClient } from "@google-cloud/secret-manager";
import dotenv from "dotenv";

dotenv.config();

const client = new SecretManagerServiceClient();
const app = express();
const PORT = process.env.PORT || 3000;
const NODE_URL = process.env.NODE_URL || "https://node1.irys.xyz";
const TOKEN = process.env.TOKEN || "matic";
const RPC_PROVIDER = process.env.RPC_PROVIDER || "https://rpc.ankr.com/polygon";

let API_KEY: string | null;
let PRIVATE_KEY: string | null;

/**
 * Retrieves the API key from the secret manager.
 * @returns {Promise<string>} The API key.
 */
const getApiKey = async (): Promise<string | null> => {
  const secretName: string =
    "projects/mem-chat-permaweb/secrets/API_KEY/versions/latest";
  const [version] = await client.accessSecretVersion({ name: secretName });
  return version.payload?.data?.toString() || null;
};

/**
 * Retrieves the private key from the secret manager.
 *
 * @returns The private key as a string, or null if it is not found.
 */
const getPrivateKey = async (): Promise<string | null> => {
  const secretName: string =
    "projects/mem-chat-permaweb/secrets/PRIVATE_KEY/versions/latest";
  const [version] = await client.accessSecretVersion({ name: secretName });
  return version.payload?.data?.toString() || null;
};

const getIrys = () => {
  return new Irys({
    url: NODE_URL,
    token: TOKEN,
    key: PRIVATE_KEY,
    config: { providerUrl: RPC_PROVIDER },
  });
};

app.use(
  fileUpload({
    limits: { fileSize: 250 * 1024 * 1024 },
    abortOnLimit: true,
    responseOnLimit: "File size exceeds limit of 250MB",
  })
);
app.use(
  cors({
    origin: "*",
    methods: ["GET", "POST"],
  })
);

app.use(passport.initialize());

passport.use(
  new Strategy(
    {
      header: "x-mem-token",
    },
    (token: string, done: Function) => {
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

/**
 * Get the prices for a given number of bytes.
 *
 * @param numBytes - The number of bytes.
 * @returns An object containing the atomic price and converted price.
 */
const getPrices = async (
  numBytes: string
): Promise<{ atomicPrice: number; convertedPrice: number }> => {
  const irys = getIrys();
  const byteCount: number = parseInt(numBytes);
  const atomicPrice = await irys.getPrice(byteCount);
  const convertedPrice: number = irys.utils.fromAtomic(atomicPrice).toNumber();
  return { atomicPrice: atomicPrice.toNumber(), convertedPrice };
};

app.get("/cost", async (req: Request, res: Response) => {
  // Get the number of bytes from the query parameter
  const bytes = req.query.bytes as undefined | string;

  // Check if bytes is undefined or not a positive number
  if (bytes === undefined || Number(bytes) <= 0) {
    // Return a 400 Bad Request response with an error message
    res.status(400).json({
      ok: false,
      error: "numBytes must be greater than 0",
    });
    return;
  }

  // Call the getPrices function to calculate the cost
  const { atomicPrice, convertedPrice } = await getPrices(bytes);

  // Return a 200 OK response with the calculated price
  res.status(200).json({ price: convertedPrice, atomic: atomicPrice });
});

app.post(
  "/upload",
  passport.authenticate("header", {
    session: false,
    failWithError: true,
  }),
  async (request: Request, response: Response) => {
    // Check if the request contains a file
    if (!request.files || !request.files.memFile) {
      return response.status(400).json({
        ok: false,
        message: "No files were uploaded",
      });
    }

    // Parse the tags from the request body
    const tags: Tag[] = JSON.parse(request.body?.tags ?? "[]");

    // Get the uploaded file and its size
    const file = request.files.memFile as UploadedFile;
    const size = file.size;

    // Update the "Content-Type" tag with the file's mimetype, or add it if it doesn't exist
    const updateContentTypeTag = (tag: Tag) => {
      return tag.name.toLowerCase() === "content-type";
    };

    const contentTypeTag = tags.find(updateContentTypeTag);

    if (contentTypeTag) {
      contentTypeTag.value = file.mimetype;
    } else {
      tags.push({ name: "Content-Type", value: file.mimetype });
    }

    // Get the atomic price for the file size
    const { atomicPrice } = await getPrices(size.toString());

    try {
      const irys = getIrys();
      // Fund the required amount for the file upload
      await irys.fund(atomicPrice);

      // Initialize the uploader for chunked uploading
      const uploader = irys.uploader.chunkedUploader;

      // Upload the file data with the provided tags
      const txId = await uploader.uploadData(file.data, {
        tags,
      });

      // Return the successful response with the transaction ID and URL
      return response.status(200).json({
        ok: true,
        message: "File uploaded successfully",
        txId: txId.data.id,
        url: `https://gateway.irys.xyz/${txId.data.id}`,
      });
    } catch (error) {
      // Return an error response if the file upload fails
      return response.status(500).json({
        ok: false,
        message: "Unable to upload file to irys",
        error: error,
      });
    }
  }
);

app.listen(PORT, async () => {
  API_KEY = await getApiKey();
  PRIVATE_KEY = await getPrivateKey();

  if (!PRIVATE_KEY || !API_KEY) {
    console.error("Please set the PRIVATE_KEY and API_KEY env variable");
    process.exit(1);
  }

  console.log(`Server is running on port ${PORT}`);
});
