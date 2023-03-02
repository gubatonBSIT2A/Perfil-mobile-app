import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfil/constants/routes.dart';
import 'package:perfil/helpers/loading/loading_screen.dart';
import 'package:perfil/screens/account_screen.dart';
import 'package:perfil/screens/forgot_password_screen.dart';
import 'package:perfil/screens/login_screen.dart';
import 'package:perfil/screens/create_update_note_screen.dart';
import 'package:perfil/screens/register_screen.dart';
import 'package:perfil/screens/tab_screen.dart';
import 'package:perfil/screens/verify_email_screen.dart';
import 'package:perfil/services/auth/firebase_auth_provider.dart';
import 'package:perfil/services/bloc/auth_bloc.dart';
import 'package:perfil/services/bloc/auth_event.dart';
import 'package:perfil/services/bloc/auth_state.dart';
import 'package:perfil/theme/theme_constant.dart';

import 'firebase_options.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Handling a background message: ${message.messageId}");
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   name: 'Perfil',
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   print('Got a message whilst in the foreground!');
  //   print('Message data: ${message.data}');
  //
  //   if (message.notification != null) {
  //     print('Message also contained a notification: ${message.notification}');
  //   }
  // });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: lightTheme,
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const MainScreen(),
      ),
      routes: {
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteScreen(),
        accountRoute: (context) => const AccountScreen(),
        // addEvent: (context) => const AddEventScreen(),
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
              context: context,
              text: state.loadingText ?? 'Please wait a moment');
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const TabScreen();
        } else if (state is AuthStateLoggedOut) {
          return const LoginScreen();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailScreen();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordScreen();
        } else if (state is AuthStateRegistering) {
          return const RegisterScreen();
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
