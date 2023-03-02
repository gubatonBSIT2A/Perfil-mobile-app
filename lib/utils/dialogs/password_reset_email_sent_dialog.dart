import 'package:flutter/material.dart';
import 'package:perfil/utils/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Password Reset',
    content: 'we send a password reset link. Please check you email',
    optionBuilder: () => {
     'OK': null,
    },
  );
}