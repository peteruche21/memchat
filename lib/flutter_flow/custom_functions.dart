import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/schema/structs/index.dart';
import '/auth/custom_auth/auth_util.dart';

List<int> arrayify(String hexString) {
  hexString = hexString.replaceAll(RegExp(r'\s+'), '');
  List<int> bytes = [];
  for (int i = 0; i < hexString.length; i += 2) {
    String byteHex = hexString.substring(i, i + 2);
    int byteValue = int.parse(byteHex, radix: 16);
    bytes.add(byteValue);
  }
  return bytes;
}

String getMemAuthMessage(String message) {
  final authData = utf8.encode(message);
  final finalData = base64UrlEncode(authData);
  return finalData;
}

String hexlify(List<int> bts) {
  var ss = <String>[];
  for (int value in bts) {
    ss.add(value.toRadixString(16).padLeft(2, '0'));
  }
  return "0x${ss.join('')}";
}
