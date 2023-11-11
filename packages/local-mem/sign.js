const ethers = require("ethers");

async function signMessageWithPrivateKey() {
  const wallet = new ethers.Wallet(
    "0x460da52673ddbe548c0d6f006034547171627b2d94a0342a5b6f18ea273030d0"
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


