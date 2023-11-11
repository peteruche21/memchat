"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const sdk_1 = __importDefault(require("@irys/sdk"));
const cors_1 = __importDefault(require("cors"));
const express_1 = __importDefault(require("express"));
const express_fileupload_1 = __importDefault(require("express-fileupload"));
const passport_1 = __importDefault(require("passport"));
const passport_http_header_strategy_1 = require("passport-http-header-strategy");
const secret_manager_1 = require("@google-cloud/secret-manager");
const dotenv_1 = __importDefault(require("dotenv"));
dotenv_1.default.config();
const client = new secret_manager_1.SecretManagerServiceClient();
const app = (0, express_1.default)();
const PORT = process.env.PORT || 3000;
const NODE_URL = process.env.NODE_URL || "https://node1.irys.xyz";
const TOKEN = process.env.TOKEN || "matic";
const RPC_PROVIDER = process.env.RPC_PROVIDER || "https://rpc.ankr.com/polygon";
let API_KEY;
let PRIVATE_KEY;
/**
 * Retrieves the API key from the secret manager.
 * @returns {Promise<string>} The API key.
 */
const getApiKey = async () => {
    var _a, _b;
    const secretName = "projects/mem-chat-permaweb/secrets/API_KEY/versions/latest";
    const [version] = await client.accessSecretVersion({ name: secretName });
    return ((_b = (_a = version.payload) === null || _a === void 0 ? void 0 : _a.data) === null || _b === void 0 ? void 0 : _b.toString()) || null;
};
/**
 * Retrieves the private key from the secret manager.
 *
 * @returns The private key as a string, or null if it is not found.
 */
const getPrivateKey = async () => {
    var _a, _b;
    const secretName = "projects/mem-chat-permaweb/secrets/PRIVATE_KEY/versions/latest";
    const [version] = await client.accessSecretVersion({ name: secretName });
    return ((_b = (_a = version.payload) === null || _a === void 0 ? void 0 : _a.data) === null || _b === void 0 ? void 0 : _b.toString()) || null;
};
const getIrys = () => {
    return new sdk_1.default({
        url: NODE_URL,
        token: TOKEN,
        key: PRIVATE_KEY,
        config: { providerUrl: RPC_PROVIDER },
    });
};
app.use((0, express_fileupload_1.default)({
    limits: { fileSize: 250 * 1024 * 1024 },
    abortOnLimit: true,
    responseOnLimit: "File size exceeds limit of 250MB",
}));
app.use((0, cors_1.default)({
    origin: "*",
    methods: ["GET", "POST"],
}));
app.use(passport_1.default.initialize());
passport_1.default.use(new passport_http_header_strategy_1.Strategy({
    header: "x-mem-token",
}, (token, done) => {
    if (token === API_KEY) {
        done(null, true, { scope: "all" });
    }
    else {
        done(null, false);
    }
}));
/**
 * Get the prices for a given number of bytes.
 *
 * @param numBytes - The number of bytes.
 * @returns An object containing the atomic price and converted price.
 */
const getPrices = async (numBytes) => {
    const irys = getIrys();
    const byteCount = parseInt(numBytes);
    const atomicPrice = await irys.getPrice(byteCount);
    const convertedPrice = irys.utils.fromAtomic(atomicPrice).toNumber();
    return { atomicPrice: atomicPrice.toNumber(), convertedPrice };
};
app.get("/cost", async (req, res) => {
    // Get the number of bytes from the query parameter
    const bytes = req.query.bytes;
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
app.post("/upload", passport_1.default.authenticate("header", {
    session: false,
    failWithError: true,
}), async (request, response) => {
    var _a, _b;
    // Check if the request contains a file
    if (!request.files || !request.files.memFile) {
        return response.status(400).json({
            ok: false,
            message: "No files were uploaded",
        });
    }
    // Parse the tags from the request body
    const tags = JSON.parse((_b = (_a = request.body) === null || _a === void 0 ? void 0 : _a.tags) !== null && _b !== void 0 ? _b : "[]");
    // Get the uploaded file and its size
    const file = request.files.memFile;
    const size = file.size;
    // Update the "Content-Type" tag with the file's mimetype, or add it if it doesn't exist
    const updateContentTypeTag = (tag) => {
        return tag.name.toLowerCase() === "content-type";
    };
    const contentTypeTag = tags.find(updateContentTypeTag);
    if (contentTypeTag) {
        contentTypeTag.value = file.mimetype;
    }
    else {
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
    }
    catch (error) {
        // Return an error response if the file upload fails
        return response.status(500).json({
            ok: false,
            message: "Unable to upload file to irys",
            error: error,
        });
    }
});
app.listen(PORT, async () => {
    API_KEY = await getApiKey();
    PRIVATE_KEY = await getPrivateKey();
    if (!PRIVATE_KEY || !API_KEY) {
        console.error("Please set the PRIVATE_KEY and API_KEY env variable");
        process.exit(1);
    }
    console.log(`Server is running on port ${PORT}`);
});
