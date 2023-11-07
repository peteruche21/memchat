import '/flutter_flow/flutter_flow_util.dart';
import 'confirm_pin_widget.dart' show ConfirmPinWidget;
import 'package:flutter/material.dart';

class ConfirmPinModel extends FlutterFlowModel<ConfirmPinWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for PinCode widget.
  TextEditingController? pinCodeController;
  String? Function(BuildContext, String?)? pinCodeControllerValidator;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {
    pinCodeController = TextEditingController();
  }

  @override
  void dispose() {
    pinCodeController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
