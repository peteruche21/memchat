import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:badges/badges.dart' as badges;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'chat_preview_model.dart';
export 'chat_preview_model.dart';

class ChatPreviewWidget extends StatefulWidget {
  const ChatPreviewWidget({super.key});

  @override
  _ChatPreviewWidgetState createState() => _ChatPreviewWidgetState();
}

class _ChatPreviewWidgetState extends State<ChatPreviewWidget> {
  late ChatPreviewModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatPreviewModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 1.0,
      height: 70.0,
      decoration: const BoxDecoration(),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
            child: Container(
              width: 50.0,
              height: 50.0,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image.network(
                'https://picsum.photos/seed/644/600',
                fit: BoxFit.cover,
              ),
            ),
          ),
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              context.pushNamed(
                'Chat',
                queryParameters: {
                  'isGroup': serializeParam(
                    true,
                    ParamType.bool,
                  ),
                }.withoutNulls,
              );
            },
            child: badges.Badge(
              badgeContent: Text(
                '1',
                style: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Manrope',
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
              ),
              showBadge: true,
              shape: badges.BadgeShape.circle,
              badgeColor: FlutterFlowTheme.of(context).primary,
              elevation: 4.0,
              padding: const EdgeInsetsDirectional.fromSTEB(6.0, 6.0, 6.0, 6.0),
              position: badges.BadgePosition.topEnd(),
              animationType: badges.BadgeAnimationType.scale,
              toAnimate: true,
              child: Container(
                width: MediaQuery.sizeOf(context).width * 0.75,
                decoration: const BoxDecoration(),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'N\'Golo Kante',
                          style:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Manrope',
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                        Container(
                          width: 230.0,
                          decoration: const BoxDecoration(),
                          child: AutoSizeText(
                            'I think we user cannot exclude themselves user cannot exclude themselves I think we user cannot exclude themselves user cannot exclude themselves',
                            maxLines: 2,
                            style: FlutterFlowTheme.of(context).labelMedium,
                            minFontSize: 10.0,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '6:59 am',
                          style: FlutterFlowTheme.of(context).labelLarge,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ].divide(const SizedBox(width: 8.0)).around(const SizedBox(width: 8.0)),
      ),
    );
  }
}
