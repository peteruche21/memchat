import '/components/chat_drawer/chat_drawer_widget.dart';
import '/components/group_drawer/group_drawer_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'chat_widget.dart' show ChatWidget;
import 'package:flutter/material.dart';

class ChatModel extends FlutterFlowModel<ChatWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for ChatDrawer component.
  late ChatDrawerModel chatDrawerModel;
  // Model for GroupDrawer component.
  late GroupDrawerModel groupDrawerModel;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {
    chatDrawerModel = createModel(context, () => ChatDrawerModel());
    groupDrawerModel = createModel(context, () => GroupDrawerModel());
  }

  @override
  void dispose() {
    chatDrawerModel.dispose();
    groupDrawerModel.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
