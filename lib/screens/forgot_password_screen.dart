import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:perfil/services/bloc/auth_bloc.dart';
import 'package:perfil/services/bloc/auth_event.dart';
import 'package:perfil/services/bloc/auth_state.dart';
import 'package:perfil/utils/dialogs/error_dialog.dart';
import 'package:perfil/utils/dialogs/password_reset_email_sent_dialog.dart';
import 'package:perfil/widgets/custom_text_button.dart';
import 'package:perfil/widgets/fullwidth_elevated_button.dart';
import 'package:perfil/widgets/heading_text.dart';
import 'package:perfil/widgets/outlined_textfield.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception != null) {
            await showErrorDialog(context,
                'We could not process your request. Please make sure that you\'re registered');
          }
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SizedBox(
              height: double.infinity,
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1.3,
                      child: SvgPicture.asset(
                        'assets/images/forgot-password.svg',
                      ),
                    ),
                    const HeadingText(
                      text: 'Forgot Password',
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    OutlinedTextField(
                      textInputAction: TextInputAction.done,
                      label: 'Email',
                      controller: _controller,
                      obscureText: false,
                      readOnly: false,
                    ),
                   const SizedBox(
                      height: 20,
                    ),
                    FullWidthElevatedButton(
                      label: 'Submit',
                      onPressed: () {
                        final email = _controller.text;
                        context.read<AuthBloc>().add(
                              AuthEventForgotPassword(email: email),
                            );
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    CustomTextButton(
                        title: 'Back',
                        onPressed: () {
                          context.read<AuthBloc>().add(
                                const AuthEventLogOut(),
                              );
                        })
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
