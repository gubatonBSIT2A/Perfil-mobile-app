
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:perfil/screens/select_photo_options_screen.dart';
import 'package:perfil/theme/theme_constant.dart';

import '../services/auth/auth_service.dart';
import '../services/bloc/auth_bloc.dart';
import '../services/bloc/auth_event.dart';
import '../services/cloud/profile/cloud_profile.dart';
import '../services/cloud/profile/cloud_storage.dart';
import '../utils/dialogs/logout_dialog.dart';
import '../widgets/normal_appbar.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String get userId => AuthService.firebase().currentUser!.id;
  late final CloudStorage _profileService;
  File? _image;
  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      img = await _cropImage(imageFile: img);
      setState(() {
        _image = img;
        Navigator.of(context).pop();
      });
    } on PlatformException catch (e) {
      print(e);
      Navigator.of(context).pop();
    }
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [CropAspectRatioPreset.square]);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  void _showSelectPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.28,
          maxChildSize: 0.4,
          minChildSize: 0.28,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: SelectPhotoOptionsScreen(
                onTap: _pickImage,
              ),
            );
          }),
    );
  }


  @override
  void initState() {
    _profileService = CloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: NormalAppBar(
          title: 'Account',
          actions: [
            IconButton(
              onPressed: () async {
                final shouldLogout = await showLogOutDialog(context);
                if (shouldLogout) {
                  context.read<AuthBloc>().add(
                    const AuthEventLogOut(),
                  );
                }
              },
              icon: const Icon(
                Icons.logout_rounded,
              ),
            )
          ],
        ),
      ),
      body: StreamBuilder(
        stream: _profileService.allProfiles(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allProfiles = snapshot.data as Iterable<CloudProfile>;

                return ListView.builder(
                  itemCount: allProfiles.length,
                  itemBuilder: (context, index) {
                    final profile = allProfiles.elementAt(index);
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 190,
                          width: 190,
                          child: Stack(
                            clipBehavior: Clip.none,
                            fit: StackFit.expand,
                            children: [
                              Center(
                                child: _image == null
                                    ? const CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 200.0,
                                )
                                    : CircleAvatar(
                                  backgroundImage: FileImage(_image!),
                                  radius: 200.0,
                                ),
                              ),
                              Positioned(
                                  bottom: 0,
                                  right: -25,
                                  child: RawMaterialButton(
                                    onPressed: () => _showSelectPhotoOptions(context),
                                    elevation: 1,
                                    fillColor: const Color(0xFFF5F6F9),
                                    padding: const EdgeInsets.all(10),
                                    shape: const CircleBorder(),
                                    child: const Icon(
                                      Icons.add_a_photo_outlined,
                                      color: primaryColor,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${profile.firstName} ${profile.middleName} ${profile.lastName}',
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          width: double.infinity,
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [

                                buildTile(
                                  fieldValue: profile.birthday,
                                  fieldName: 'Birthday',
                                ),
                                buildTile(
                                  fieldValue: profile.civilStatus,
                                  fieldName: 'Civil Status',
                                ),
                                buildTile(
                                  fieldValue:profile.gender,
                                  fieldName: 'Gender',
                                ),
                                buildTile(
                                  fieldValue: profile.fathersName,
                                  fieldName: 'Father\'s Name',
                                ),
                                buildTile(
                                  fieldValue: profile.mothersName,
                                  fieldName: 'Mother\'s Name',
                                ),
                                buildTile(
                                  fieldValue:profile.ethnicity,
                                  fieldName: 'Ethnicity',
                                ),
                                buildTile(
                                  fieldValue: profile.religion,
                                  fieldName: 'Religion',
                                ),
                                buildTile(
                                  fieldValue: profile.dateIssued,
                                  fieldName: 'Date Created',
                                ),
                                buildTile(
                                  fieldValue: profile.email,
                                  fieldName: 'Email',
                                ),
                                buildTile(
                                  fieldValue: profile.phoneNumber,
                                  fieldName: 'Phone Number',
                                ),
                                buildTile(
                                  fieldValue: 
                                      ' ${profile.barangay}, ${profile.city}',
                                  fieldName: 'Address',
                                ),
                              ],
                            ))
                      ],
                    );
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.none:
            case ConnectionState.done:
              return const Center(child: Text('No data'));
          }
        },
      ),
    );
  }
  buildTile({fieldName, fieldValue}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text( fieldName, style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),),
        Text( fieldValue, style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          // fontWeight: FontWeight.bold,
        ),),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
