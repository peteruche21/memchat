// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:web3dart/web3dart.dart';
import 'dart:typed_data';
import 'dart:convert';

String signMessage(
  WalletStruct wallet,
  String password,
  String hash,
) {
  // Add your function code here!
  final credential = Wallet.fromJson(wallet.credential, password);
  final signature = credential.privateKey
      .signPersonalMessageToUint8List(Uint8List.fromList(utf8.encode(hash)));
  return hexlify(signature);
}
