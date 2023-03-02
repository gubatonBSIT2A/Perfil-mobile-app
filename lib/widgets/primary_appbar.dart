import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfil/services/bloc/auth_bloc.dart';
import 'package:perfil/services/bloc/auth_event.dart';
import 'package:perfil/utils/dialogs/logout_dialog.dart';
import '../theme/theme_constant.dart';

// enum MenuAction {logout}
class PrimaryAppBar extends StatelessWidget {
  const PrimaryAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      floating: true,
      elevation: 4,
      title: Text(
        'Perfil',
        style: TextStyle(
          color: newBlack,
          fontWeight: FontWeight.w900,
          fontSize: 30,
        ),
      ),
      // actions: [
      //   IconButton(
      //     onPressed: () async {
      //       final shouldLogout = await showLogOutDialog(context);
      //       if (shouldLogout) {
      //         context.read<AuthBloc>().add(
      //           const AuthEventLogOut(),
      //         );
      //       }
      //     },
      //     icon: const Icon(
      //       Icons.logout_rounded,
      //     ),
      //   ),
      // ],
    );
  }
}

