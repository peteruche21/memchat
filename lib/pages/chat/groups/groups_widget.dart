import '/components/drawers/group_actions/group_actions_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/chat/chat_preview/chat_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'groups_model.dart';
export 'groups_model.dart';

class GroupsWidget extends StatefulWidget {
  const GroupsWidget({super.key});

  @override
  _GroupsWidgetState createState() => _GroupsWidgetState();
}

class _GroupsWidgetState extends State<GroupsWidget> {
  late GroupsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GroupsModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) {
              return Padding(
                padding: MediaQuery.viewInsetsOf(context),
                child: const GroupActionsWidget(
                  action: 'Join Goup',
                  withId: true,
                ),
              );
            },
          ).then((value) => safeSetState(() {}));
        },
        backgroundColor: FlutterFlowTheme.of(context).primary,
        elevation: 8.0,
        child: Icon(
          Icons.group_add_rounded,
          color: FlutterFlowTheme.of(context).tertiary,
          size: 30.0,
        ),
      ),
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        automaticallyImplyLeading: false,
        title: Text(
          'Group Chats',
          style: FlutterFlowTheme.of(context).displaySmall.override(
                fontFamily: 'Urbanist',
                color: FlutterFlowTheme.of(context).tertiary,
                fontSize: 28.0,
              ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 16.0, 12.0),
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                await showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: MediaQuery.viewInsetsOf(context),
                      child: const GroupActionsWidget(
                        action: 'Create Group',
                        withId: false,
                      ),
                    );
                  },
                ).then((value) => safeSetState(() {}));
              },
              child: Icon(
                Icons.add_rounded,
                color: FlutterFlowTheme.of(context).tertiary,
                size: 35.0,
              ),
            ),
          ),
        ],
        centerTitle: false,
        elevation: 4.0,
      ),
      body: SafeArea(
        top: true,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: [
                wrapWithModel(
                  model: _model.chatPreviewModel,
                  updateCallback: () => setState(() {}),
                  child: const ChatPreviewWidget(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
