import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'recovery_model.dart';
export 'recovery_model.dart';

class RecoveryWidget extends StatefulWidget {
  const RecoveryWidget({super.key});

  @override
  _RecoveryWidgetState createState() => _RecoveryWidgetState();
}

class _RecoveryWidgetState extends State<RecoveryWidget> {
  late RecoveryModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RecoveryModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
            child: Text(
              'Already have a wallet?',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Manrope',
                    color: Colors.white,
                  ),
            ),
          ),
          FFButtonWidget(
            onPressed: () async {
              context.goNamed(
                'Recover',
                extra: <String, dynamic>{
                  kTransitionInfoKey: const TransitionInfo(
                    hasTransition: true,
                    transitionType: PageTransitionType.fade,
                    duration: Duration(milliseconds: 150),
                  ),
                },
              );
            },
            text: 'Recover',
            options: FFButtonOptions(
              width: 100.0,
              height: 40.0,
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              color: const Color(0x004B39EF),
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'Manrope',
                    color: Colors.white,
                  ),
              elevation: 0.0,
              borderSide: const BorderSide(
                color: Colors.transparent,
                width: 0.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ],
      ),
    );
  }
}
