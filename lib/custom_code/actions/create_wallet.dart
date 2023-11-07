// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:math';
import 'package:web3dart/web3dart.dart';

WalletStruct createWallet(String password) {
  // Add your function code here!
  final random = Random.secure();
  final privateKey = EthPrivateKey.createRandom(random);
  final credential = Wallet.createNew(privateKey, password, random);
  final address = privateKey.address.hex;
  final credentialJson = credential.toJson();
  return WalletStruct(credential: credentialJson, address: address);
}
