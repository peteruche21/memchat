import '/flutter_flow/flutter_flow_util.dart';
import '/pages/chat/chat_preview/chat_preview_widget.dart';
import 'groups_widget.dart' show GroupsWidget;
import 'package:flutter/material.dart';

class GroupsModel extends FlutterFlowModel<GroupsWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for ChatPreview component.
  late ChatPreviewModel chatPreviewModel;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {
    chatPreviewModel = createModel(context, () => ChatPreviewModel());
  }

  @override
  void dispose() {
    chatPreviewModel.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
