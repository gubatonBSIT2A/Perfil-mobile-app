import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:perfil/services/bloc/auth_bloc.dart';
import 'package:perfil/services/bloc/auth_event.dart';
import 'package:perfil/widgets/custom_text.dart';
import 'package:perfil/widgets/custom_text_button.dart';
import 'package:perfil/widgets/fullwidth_elevated_button.dart';
import 'package:perfil/widgets/heading_text.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: SvgPicture.asset('assets/images/mail.svg'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  HeadingText(text: 'Verify Email'),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                'We sent a verification link to your email ',
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 40,
              ),
              FullWidthElevatedButton(
                onPressed: () async {
                  await LaunchApp.openApp(
                    androidPackageName: 'com.google.android.gm',
                    openStore: true,
                  );
                },
                label: ('Open Email app'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomText(
                    text: 'Didn\'t receive the email?',
                  ),
                  CustomTextButton(
                    title: 'Resend',
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            const AuthEventSendEmailVerification(),
                          );
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                    const AuthEventLogOut(),
                  );
                },
                child: const Text('Exit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
