import '/flutter_flow/flutter_flow_util.dart';
import 'new_status_widget.dart' show NewStatusWidget;
import 'package:flutter/material.dart';

class NewStatusModel extends FlutterFlowModel<NewStatusWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for shortBio widget.
  FocusNode? shortBioFocusNode;
  TextEditingController? shortBioController;
  String? Function(BuildContext, String?)? shortBioControllerValidator;
  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    shortBioFocusNode?.dispose();
    shortBioController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
