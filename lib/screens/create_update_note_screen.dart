import 'package:flutter/material.dart';
import 'package:perfil/services/auth/auth_service.dart';
import 'package:perfil/services/cloud/cloud_note.dart';
import 'package:perfil/services/cloud/firebase_cloud_storage.dart';
import 'package:perfil/utils/dialogs/cannot_share_empty_note_dialog.dart';
import 'package:perfil/utils/generics/get_arguments.dart';
import 'package:perfil/widgets/outlined_textfield.dart';
import 'package:perfil/widgets/secondary_appbar.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNoteScreen extends StatefulWidget {
  const CreateUpdateNoteScreen({Key? key}) : super(key: key);

  @override
  State<CreateUpdateNoteScreen> createState() => _CreateUpdateNoteScreenState();
}

class _CreateUpdateNoteScreenState extends State<CreateUpdateNoteScreen> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _textController = TextEditingController();
    super.initState();
  }

  // void _textControllerListener() async {
  //   final note = _note;
  //   if (note == null) {
  //     return;
  //   }
  //   final text = _textController.text;
  //   await _notesService.updateNote(
  //     documentId: note.documentId,
  //     text: text,
  //   );
  // }

  void _setupTextControllerListener() {
    // _textController.removeListener(_textControllerListener);
    // _textController.addListener(_textControllerListener);
  }

  // Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
  //   final widgetNote = context.getArgument<CloudNote>();
  //   if (widgetNote != null) {
  //     _note = widgetNote;
  //     _textController.text = widgetNote.text;
  //     return widgetNote;
  //   }
  //   final existingNote = _note;
  //   if (existingNote != null) {
  //     return existingNote;
  //   }
  //   final currentUser = AuthService.firebase().currentUser!;
  //   final userId = currentUser.id;
  //   // final newNote = await _notesService.createNewNote(ownerUserId: userId);
  //   // _note = newNote;
  //   // return newNote;
  // }

  // void _deleteNoteIfTextIsEmpty() {
  //   final note = _note;
  //   if (_textController.text.isEmpty && note != null) {
  //     _notesService.deleteNote(documentId: note.documentId);
  //   }
  // }

  // void _saveNoteIfTextNotEmpty() async {
  //   final note = _note;
  //   final text = _textController.text;
  //   if (note != null && text.isNotEmpty) {
  //     await _notesService.updateNote(
  //       documentId: note.documentId,
  //       text: text,
  //     );
  //   }
  // }

  @override
  void dispose() {
    // _deleteNoteIfTextIsEmpty();
    // _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SecondaryAppBar(
          title: 'Create New Note',
          actions: [
            IconButton(
                onPressed: () async {
                  final text = _textController.text;
                  if (_note == null || text.isEmpty) {
                    await showCannotShareEmptyNoteDialog(context);
                  } else {
                    Share.share(text);
                  }
                },
                icon: const Icon(Icons.share_rounded)),
          ],
        ),
        SliverToBoxAdapter(
          child: FutureBuilder(
            // future: createOrGetExistingNote(context),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  _setupTextControllerListener();
                  return OutlinedTextField(
                    label: 'Input your notes here...',
                    maxLines: null,
                    controller: _textController,
                    obscureText: false,
                    readOnly: false,
                    keyboardType: TextInputType.multiline,
                  );

                default:
                  return const CircularProgressIndicator();
              }
            },
          ),
        )
      ],
    ));
  }
}
