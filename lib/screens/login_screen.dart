import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:perfil/constants/routes.dart';
import 'package:perfil/services/auth/auth_exceptions.dart';
import 'package:perfil/services/bloc/auth_bloc.dart';
import 'package:perfil/services/bloc/auth_event.dart';
import 'package:perfil/services/bloc/auth_state.dart';
import 'package:perfil/utils/dialogs/loading_dialog.dart';
import 'package:perfil/widgets/custom_text.dart';
import 'package:perfil/widgets/custom_text_button.dart';
import 'package:perfil/widgets/fullwidth_elevated_button.dart';
import 'package:perfil/widgets/heading_text.dart';
import 'package:perfil/widgets/outlined_textfield.dart';

import '../utils/dialogs/error_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late bool _passwordVisible;
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _passwordVisible = false;
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthStateLoggedOut) {
            if (state.exception is UserNotFoundAuthException) {
              await showErrorDialog(
                context,
                'User not found',
              );
            } else if (state.exception is WrongPasswordAuthException) {
              await showErrorDialog(
                context,
                'Wrong credentials',
              );
            } else if (state.exception is InvalidEmailAuthException) {
              await showErrorDialog(
                context,
                'Please use a valid email',
              );
            } else if (state.exception is UserDisabledAuthException) {
              await showErrorDialog(
                context,
                'Account Disabled, please contact admin',
              );
            } else if (state.exception is GenericAuthException) {
              await showErrorDialog(
                context,
                'Authenticaiton error',
              );
            }
          }
        },
        child: SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1.8,
                      child: SvgPicture.asset('assets/images/logo.svg'),
                    ),
                    const HeadingText(text: 'Perfil')
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Form(
                  child: Column(
                    children: [
                      OutlinedTextField(
                        readOnly: false,
                        label: 'Email',
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        obscureText: false,
                      ),
                      OutlinedTextField(
                        maxLines: 1,
                        readOnly: false,
                        label: 'Password',
                        controller: _password,
                        textInputAction: TextInputAction.done,
                        obscureText: !_passwordVisible,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: CustomTextButton(
                          title: 'Forgot Password?',
                          onPressed: () {
                            context
                                .read<AuthBloc>()
                                .add(const AuthEventForgotPassword());
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FullWidthElevatedButton(
                        label: 'Login',
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;
                          context.read<AuthBloc>().add(
                                AuthEventLogIn(
                                  email,
                                  password,
                                ),
                              );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CustomText(text: 'New to Perfil?'),
                    CustomTextButton(
                      title: 'Sign Up',
                      onPressed: () {
                        context
                            .read<AuthBloc>()
                            .add(const AuthEventShouldRegister());
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
