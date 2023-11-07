import '/flutter_flow/flutter_flow_util.dart';
import 'send_message_widget.dart' show SendMessageWidget;
import 'package:flutter/material.dart';

class SendMessageModel extends FlutterFlowModel<SendMessageWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for shortBio widget.
  FocusNode? shortBioFocusNode1;
  TextEditingController? shortBioController1;
  String? Function(BuildContext, String?)? shortBioController1Validator;
  // State field(s) for shortBio widget.
  FocusNode? shortBioFocusNode2;
  TextEditingController? shortBioController2;
  String? Function(BuildContext, String?)? shortBioController2Validator;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    shortBioFocusNode1?.dispose();
    shortBioController1?.dispose();

    shortBioFocusNode2?.dispose();
    shortBioController2?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
