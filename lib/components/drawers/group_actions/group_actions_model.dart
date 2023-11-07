import '/flutter_flow/flutter_flow_util.dart';
import 'group_actions_widget.dart' show GroupActionsWidget;
import 'package:flutter/material.dart';

class GroupActionsModel extends FlutterFlowModel<GroupActionsWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for shortBio widget.
  FocusNode? shortBioFocusNode;
  TextEditingController? shortBioController;
  String? Function(BuildContext, String?)? shortBioControllerValidator;

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
