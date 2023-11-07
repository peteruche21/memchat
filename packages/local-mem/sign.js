const ethers = require("ethers");

async function signMessageWithPrivateKey() {
  const wallet = new ethers.Wallet(
    "0x9a91a1242f7026d6cc83599538ec04f82f7639218869c7abae1567a6cffe329a"
  );

  const data = "a simple data string that will be signed with the private key";
  const bytes = ethers.utils.toUtf8Bytes(data);
  const signature = await wallet.signMessage(bytes);

  return {
    caller: wallet.address,
    message: Buffer.from(data).toString("base64"),
    signature,
  };
}

function verifyMessageMock(caller, message, signature) {
  const data = Buffer.from(message, "base64").toString();
  const address = ethers.utils.verifyMessage(data, signature);
  return address;
}

signMessageWithPrivateKey().then((result) => {
  console.log(result);
});

module.exports = {
  signMessageWithPrivateKey,
  verifyMessageMock,
};

// import 'package:firebase_messaging/firebase_messaging.dart';

// Future<String> getFcmToken() async {
//   final FirebaseMessaging fcm = FirebaseMessaging.instance;
//   String token = await fcm.getToken() ?? '';

//   return token;
// }
