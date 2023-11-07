import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'q_r_code_viewer_model.dart';
export 'q_r_code_viewer_model.dart';

class QRCodeViewerWidget extends StatefulWidget {
  const QRCodeViewerWidget({super.key});

  @override
  _QRCodeViewerWidgetState createState() => _QRCodeViewerWidgetState();
}

class _QRCodeViewerWidgetState extends State<QRCodeViewerWidget> {
  late QRCodeViewerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => QRCodeViewerModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
      child: Container(
        width: 300.0,
        height: 400.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: const [
            BoxShadow(
              blurRadius: 50.0,
              color: Color(0x32000000),
              offset: Offset(2.0, 2.0),
              spreadRadius: 100.0,
            )
          ],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 200.0,
                height: 200.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primary,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
                  child: SizedBox(
                    width: 200.0,
                    height: 200.0,
                    child: custom_widgets.QRCodeWidget(
                      width: 200.0,
                      height: 200.0,
                      data: 'somebigdatabiggernow',
                      size: 300.0,
                      bgColor: FlutterFlowTheme.of(context).primary,
                      image: 'assets/images/Polygon.png',
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hello World',
                    style: FlutterFlowTheme.of(context).labelMedium,
                  ),
                  FFButtonWidget(
                    onPressed: () async {
                      await Clipboard.setData(
                          const ClipboardData(text: 'simple text'));
                    },
                    text: 'copy',
                    options: FFButtonOptions(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      iconPadding:
                          const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Manrope',
                                color: Colors.white,
                                fontSize: 12.0,
                              ),
                      elevation: 3.0,
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    showLoadingIndicator: false,
                  ),
                ].divide(const SizedBox(width: 24.0)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
