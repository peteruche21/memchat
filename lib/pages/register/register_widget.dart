import '/auth/custom_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'register_model.dart';
export 'register_model.dart';

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({super.key});

  @override
  _RegisterWidgetState createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget>
    with TickerProviderStateMixin {
  late RegisterModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = {
    'containerOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        VisibilityEffect(duration: 300.ms),
        MoveEffect(
          curve: Curves.bounceOut,
          delay: 300.ms,
          duration: 400.ms,
          begin: const Offset(0.0, 100.0),
          end: const Offset(0.0, 0.0),
        ),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 300.ms,
          duration: 400.ms,
          begin: 0.0,
          end: 1.0,
        ),
      ],
    ),
  };

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RegisterModel());

    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
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
      backgroundColor: FlutterFlowTheme.of(context).dark900,
      body: Align(
        alignment: const AlignmentDirectional(-0.14, -0.08),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0x19444D59),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset(
                'assets/images/launchScreen@3x.png',
              ).image,
            ),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 70.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 24.0),
                  child: Image.asset(
                    'assets/images/mem-1.png',
                    width: 150.0,
                    height: 150.0,
                    fit: BoxFit.cover,
                  ),
                ),
                Form(
                  key: _model.formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            16.0, 2.0, 16.0, 16.0),
                        child: Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(
                            maxWidth: 570.0,
                          ),
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 12.0,
                                color: Color(0x1E000000),
                                offset: Offset(0.0, 5.0),
                              )
                            ],
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                2.0, 2.0, 2.0, 2.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      24.0, 16.0, 0.0, 0.0),
                                  child: Text(
                                    'Enter a new pin',
                                    style:
                                        FlutterFlowTheme.of(context).labelLarge,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 32.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            16.0, 24.0, 16.0, 0.0),
                                        child: PinCodeTextField(
                                          autoDisposeControllers: false,
                                          appContext: context,
                                          length: 6,
                                          textStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyLarge,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          enableActiveFill: false,
                                          autoFocus: true,
                                          enablePinAutofill: true,
                                          errorTextSpace: 16.0,
                                          showCursor: true,
                                          cursorColor:
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                          obscureText: false,
                                          hintCharacter: '-',
                                          keyboardType: TextInputType.number,
                                          pinTheme: PinTheme(
                                            fieldHeight: 50.0,
                                            fieldWidth: 44.0,
                                            borderWidth: 2.0,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            shape: PinCodeFieldShape.box,
                                            activeColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            inactiveColor:
                                                FlutterFlowTheme.of(context)
                                                    .alternate,
                                            selectedColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            activeFillColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            inactiveFillColor:
                                                FlutterFlowTheme.of(context)
                                                    .alternate,
                                            selectedFillColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                          ),
                                          controller: _model.pinCodeController,
                                          onChanged: (_) {},
                                          autovalidateMode:
                                              AutovalidateMode.disabled,
                                          validator: _model
                                              .pinCodeControllerValidator
                                              .asValidator(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ).animateOnPageLoad(
                            animationsMap['containerOnPageLoadAnimation']!),
                      ),
                      FFButtonWidget(
                        onPressed: () async {
                          _model.user = actions.createWallet(
                            _model.pinCodeController!.text,
                          );
                          _model.rngUid = actions.randomUuid();
                          _model.signature = actions.signMessage(
                            _model.user!,
                            _model.pinCodeController!.text,
                            _model.rngUid!,
                          );
                          _model.response =
                              await MemGroup.registerANewUserCall.call(
                            caller: _model.user?.address,
                            message:
                                functions.getMemAuthMessage(_model.rngUid!),
                            signature: _model.signature,
                          );
                          GoRouter.of(context).prepareAuthEvent();
                          await authManager.signIn(
                            authenticationToken: _model.user?.credential,
                            authUid: _model.user?.address,
                          );

                          context.goNamedAuth(
                            'CompleteProfile',
                            context.mounted,
                            queryParameters: {
                              'tempPin': serializeParam(
                                _model.pinCodeController!.text,
                                ParamType.String,
                              ),
                            }.withoutNulls,
                            extra: <String, dynamic>{
                              kTransitionInfoKey: const TransitionInfo(
                                hasTransition: true,
                                transitionType: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 200),
                              ),
                            },
                          );

                          setState(() {});
                        },
                        text: 'Create Wallet',
                        options: FFButtonOptions(
                          width: 300.0,
                          height: 55.0,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          iconPadding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Manrope',
                                    color: Colors.white,
                                  ),
                          elevation: 4.0,
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
