// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:qr_flutter/qr_flutter.dart';

class QRCodeWidget extends StatefulWidget {
  const QRCodeWidget(
      {Key? key,
      this.width,
      this.height,
      required this.data,
      this.size,
      this.bgColor,
      required this.image})
      : super(key: key);

  final double? width;
  final double? height;
  final String data;

  final double? size;
  final Color? bgColor;
  final String image;

  @override
  _QRCodeWidgetState createState() => _QRCodeWidgetState();
}

class _QRCodeWidgetState extends State<QRCodeWidget> {
  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: widget.data,
      version: QrVersions.auto,
      size: widget.size ?? 320,
      gapless: false,
      backgroundColor: widget.bgColor ?? Colors.transparent,
      embeddedImage: AssetImage(widget.image),
      embeddedImageStyle: QrEmbeddedImageStyle(
        size: Size(35, 35),
      ),
    );
  }
}
