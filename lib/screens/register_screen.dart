import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:perfil/screens/select_photo_options_screen.dart';
import 'package:perfil/services/auth/auth_exceptions.dart';
import 'package:perfil/services/bloc/auth_bloc.dart';
import 'package:perfil/services/bloc/auth_event.dart';
import 'package:perfil/services/bloc/auth_state.dart';
import 'package:perfil/theme/theme_constant.dart';
import 'package:perfil/widgets/custom_text_button.dart';
import 'package:perfil/widgets/fullwidth_elevated_button.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:perfil/widgets/outlined_textfield.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

import '../utils/dialogs/error_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String getCurrentYear() {
    DateTime now = DateTime.now();
    String year = DateFormat('yy').format(now);
    return year;
  }

  Future<int> getDocumentCount() async {
    int count;
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('patients').get();
    count = snapshot.docs.length;
    count++;
    return count;
  }

  Future<String> generateCustomID() async {
    String year = getCurrentYear();
    int count = await getDocumentCount();
    String customID = '$year' + '0000' + '$count';
    return customID;
  }

  otherFunction() async {
    final String customId = await generateCustomID();
    return customId;
  }

  List genders = ['Male', 'Female'];
  List civilStatusType = [
    'Single',
    'Married',
    'Widowed',
    'Separated',
    'Divorced',
  ];
  List highestEducationalAttainment = [
    'Elementary',
    'High School',
    'College',
    'Vocational'
  ];

  List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];
  int currentStep = 0;
  late bool _passwordVisible;
  late bool _confirmPasswordVisible;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;
  late final TextEditingController _firstName;
  late final TextEditingController _middleName;
  late final TextEditingController _lastName;
  late final TextEditingController _birthday;
  String? _gender;
  late final TextEditingController _mothersName;
  late final TextEditingController _fathersName;
  late final TextEditingController _religion;
  late final TextEditingController _ethnicity;
  late final TextEditingController _nationality;
  String? _city;
  String? _barangay;
  late final TextEditingController _resCertNo;
  String? _highestEducation;
  String? _civilStatus;
  late final TextEditingController _phoneNumber;
  List<dynamic> cities = [];
  List<dynamic> brgyOptions = [];
  List<dynamic> barangays = [];
  String? _patientId;
  String? _establishment;
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

  getEstablishment(_establishment) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('establishments')
        .where(_establishment, isEqualTo: "id")
        .get();

    final List<DocumentSnapshot> documents = snapshot.docs;
    for (var document in documents) {
      final name = document.data;
      print(name);
    }
  }

  @override
  void initState() {
    otherFunction().then((value) {
      _patientId = value;
    });
    _firstName = TextEditingController();
    _middleName = TextEditingController();
    _lastName = TextEditingController();
    _birthday = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
    _passwordVisible = false;
    _confirmPasswordVisible = false;
    _mothersName = TextEditingController();
    _fathersName = TextEditingController();
    _religion = TextEditingController();
    _ethnicity = TextEditingController();
    _nationality = TextEditingController();
    _resCertNo = TextEditingController();
    _phoneNumber = TextEditingController();
    this.cities.add({"id": "Davao City", "name": "Davao City"});
    this.cities.add({"id": "Digos City", "name": "Digos City"});
    this.brgyOptions = [
      {"ID": 1, 'Name': "ACACIA", "ParentId": "Davao City"},
      {"ID": 2, 'Name': "AGDAO", "ParentId": "Davao City"},
      {"ID": 3, 'Name': "ALAMBRE", "ParentId": "Davao City"},
      {"ID": 4, 'Name': "ALEJANDRA NAVARRO (LASANG)", "ParentId": "Davao City"},
      {"ID": 5, 'Name': "ALFONSO ANGLIONGTO SR.", "ParentId": "Davao City"},
      {"ID": 6, 'Name': "ANGALAN", "ParentId": "Davao City"},
      {"ID": 7, 'Name': "ATAN-AWE", "ParentId": "Davao City"},
      {"ID": 8, 'Name': "BAGANIHAN", "ParentId": "Davao City"},
      {"ID": 9, 'Name': "BAGO APLAYA", "ParentId": "Davao City"},
      {"ID": 10, 'Name': "BAGO GALLERA", "ParentId": "Davao City"},
      {"ID": 11, 'Name': "BAGO OSHIRO", "ParentId": "Davao City"},
      {"ID": 12, 'Name': "BAGUIO (POB.)", "ParentId": "Davao City"},
      {"ID": 13, 'Name': "BALENGAENG", "ParentId": "Davao City"},
      {"ID": 14, 'Name': "BALIOK", "ParentId": "Davao City"},
      {"ID": 15, 'Name': "BANGKAS HEIGHTS", "ParentId": "Davao City"},
      {"ID": 16, 'Name': "BANTOL", "ParentId": "Davao City"},
      {"ID": 17, 'Name': "BARACATAN", "ParentId": "Davao City"},
      {"ID": 18, 'Name': "BARANGAY 1-A (POB.)", "ParentId": "Davao City"},
      {"ID": 19, 'Name': "BARANGAY 2-A (POB.)", "ParentId": "Davao City"},
      {"ID": 20, 'Name': "BARANGAY 3-A (POB.)", "ParentId": "Davao City"},
      {"ID": 21, 'Name': "BARANGAY 4-A (POB.)", "ParentId": "Davao City"},
      {"ID": 22, 'Name': "BARANGAY 5-A (POB.)", "ParentId": "Davao City"},
      {"ID": 23, 'Name': "BARANGAY 6-A (POB.)", "ParentId": "Davao City"},
      {"ID": 24, 'Name': "BARANGAY 7-A (POB.)", "ParentId": "Davao City"},
      {"ID": 25, 'Name': "BARANGAY 8-A (POB.)", "ParentId": "Davao City"},
      {"ID": 26, 'Name': "BARANGAY 9-A (POB.)", "ParentId": "Davao City"},
      {"ID": 27, 'Name': "BARANGAY 10-A (POB.)", "ParentId": "Davao City"},
      {"ID": 28, 'Name': "BARANGAY 11-B (POB.)", "ParentId": "Davao City"},
      {"ID": 29, 'Name': "BARANGAY 12-B (POB.)", "ParentId": "Davao City"},
      {"ID": 30, 'Name': "BARANGAY 13-B (POB.)", "ParentId": "Davao City"},
      {"ID": 31, 'Name': "BARANGAY 14-B (POB.)", "ParentId": "Davao City"},
      {"ID": 32, 'Name': "BARANGAY 15-B (POB.)", "ParentId": "Davao City"},
      {"ID": 33, 'Name': "BARANGAY 16-B (POB.)", "ParentId": "Davao City"},
      {"ID": 34, 'Name': "BARANGAY 17-B (POB.)", "ParentId": "Davao City"},
      {"ID": 35, 'Name': "BARANGAY 18-B (POB.)", "ParentId": "Davao City"},
      {"ID": 36, 'Name': "BARANGAY 19-B (POB.)", "ParentId": "Davao City"},
      {"ID": 37, 'Name': "BARANGAY 20-B (POB.)", "ParentId": "Davao City"},
      {"ID": 38, 'Name': "BARANGAY 21-C (POB.)", "ParentId": "Davao City"},
      {"ID": 39, 'Name': "BARANGAY 22-C (POB.)", "ParentId": "Davao City"},
      {"ID": 40, 'Name': "BARANGAY 23-C (POB.)", "ParentId": "Davao City"},
      {"ID": 41, 'Name': "BARANGAY 24-C (POB.)", "ParentId": "Davao City"},
      {"ID": 42, 'Name': "BARANGAY 25-C (POB.)", "ParentId": "Davao City"},
      {"ID": 43, 'Name': "BARANGAY 26-C (POB.)", "ParentId": "Davao City"},
      {"ID": 44, 'Name': "BARANGAY 27-C (POB.)", "ParentId": "Davao City"},
      {"ID": 45, 'Name': "BARANGAY 28-C (POB.)", "ParentId": "Davao City"},
      {"ID": 46, 'Name': "BARANGAY 29-C (POB.)", "ParentId": "Davao City"},
      {"ID": 47, 'Name': "BARANGAY 30-C (POB.)", "ParentId": "Davao City"},
      {"ID": 48, 'Name': "BARANGAY 31-D (POB.)", "ParentId": "Davao City"},
      {"ID": 49, 'Name': "BARANGAY 32-D (POB.)", "ParentId": "Davao City"},
      {"ID": 50, 'Name': "BARANGAY 33-D (POB.)", "ParentId": "Davao City"},
      {"ID": 51, 'Name': "BARANGAY 34-D (POB.)", "ParentId": "Davao City"},
      {"ID": 52, 'Name': "BARANGAY 35-D (POB.)", "ParentId": "Davao City"},
      {"ID": 53, 'Name': "BARANGAY 36-D (POB.)", "ParentId": "Davao City"},
      {"ID": 54, 'Name': "BARANGAY 37-D (POB.)", "ParentId": "Davao City"},
      {"ID": 55, 'Name': "BARANGAY 38-D (POB.)", "ParentId": "Davao City"},
      {"ID": 56, 'Name': "BARANGAY 39-D (POB.)", "ParentId": "Davao City"},
      {"ID": 57, 'Name': "BARANGAY 40-D (POB.)", "ParentId": "Davao City"},
      {"ID": 58, 'Name': "BATO", "ParentId": "Davao City"},
      {"ID": 59, 'Name': "BAYABAS", "ParentId": "Davao City"},
      {"ID": 60, 'Name': "BIAO ESCUELA", "ParentId": "Davao City"},
      {"ID": 61, 'Name': "BIAO GUIANGA", "ParentId": "Davao City"},
      {"ID": 62, 'Name': "BIAO JOAQUIN", "ParentId": "Davao City"},
      {"ID": 63, 'Name': "BINUGAO", "ParentId": "Davao City"},
      {"ID": 64, 'Name': "BUCANA", "ParentId": "Davao City"},
      {"ID": 65, 'Name': "BUDA", "ParentId": "Davao City"},
      {"ID": 66, 'Name': "BUHANGIN (POB.)", "ParentId": "Davao City"},
      {"ID": 67, 'Name': "BUNAWAN (POB.)", "ParentId": "Davao City"},
      {"ID": 68, 'Name': "CABANTIAN", "ParentId": "Davao City"},
      {"ID": 69, 'Name': "CADALIAN", "ParentId": "Davao City"},
      {"ID": 70, 'Name': "CALINAN (POB.)", "ParentId": "Davao City"},
      {"ID": 71, 'Name': "CALLAWA", "ParentId": "Davao City"},
      {"ID": 72, 'Name': "CAMANSI", "ParentId": "Davao City"},
      {"ID": 73, 'Name': "CARMEN", "ParentId": "Davao City"},
      {"ID": 74, 'Name': "CATALUNAN GRANDE", "ParentId": "Davao City"},
      {"ID": 75, 'Name': "CATALUNAN PEQUEÑO", "ParentId": "Davao City"},
      {"ID": 76, 'Name': "CATIGAN", "ParentId": "Davao City"},
      {"ID": 77, 'Name': "CAWAYAN", "ParentId": "Davao City"},
      {"ID": 78, 'Name': "CENTRO (SAN JUAN)", "ParentId": "Davao City"},
      {"ID": 79, 'Name': "COLOSAS", "ParentId": "Davao City"},
      {"ID": 80, 'Name': "COMMUNAL", "ParentId": "Davao City"},
      {"ID": 81, 'Name': "CROSSING BAYABAS", "ParentId": "Davao City"},
      {"ID": 82, 'Name': "DACUDAO", "ParentId": "Davao City"},
      {"ID": 83, 'Name': "DALAG", "ParentId": "Davao City"},
      {"ID": 84, 'Name': "DALAGDAG", "ParentId": "Davao City"},
      {"ID": 85, 'Name': "DALIAO", "ParentId": "Davao City"},
      {"ID": 86, 'Name': "DALIAON PLANTATION", "ParentId": "Davao City"},
      {"ID": 87, 'Name': "DATU SALUMAY", "ParentId": "Davao City"},
      {"ID": 88, 'Name': "DOMINGA", "ParentId": "Davao City"},
      {"ID": 89, 'Name': "DUMOY", "ParentId": "Davao City"},
      {"ID": 90, 'Name': "EDEN", "ParentId": "Davao City"},
      {"ID": 91, 'Name': "FATIMA (BENOWANG)", "ParentId": "Davao City"},
      {"ID": 92, 'Name': "GATUNGAN", "ParentId": "Davao City"},
      {"ID": 93, 'Name': "GOV. PACIANO BANGOY", "ParentId": "Davao City"},
      {"ID": 94, 'Name': "GOV. VICENTE DUTERTE", "ParentId": "Davao City"},
      {"ID": 95, 'Name': "GUMALANG", "ParentId": "Davao City"},
      {"ID": 96, 'Name': "GUMITAN", "ParentId": "Davao City"},
      {"ID": 97, 'Name': "ILANG", "ParentId": "Davao City"},
      {"ID": 98, 'Name': "INAYANGAN", "ParentId": "Davao City"},
      {"ID": 99, 'Name': "INDANGAN", "ParentId": "Davao City"},
      {
        "ID": 100,
        'Name': "KAP. TOMAS MONTEVERDE, SR.",
        "ParentId": "Davao City"
      },
      {"ID": 101, 'Name': "KILATE", "ParentId": "Davao City"},
      {"ID": 102, 'Name': "LACSON", "ParentId": "Davao City"},
      {"ID": 103, 'Name': "LAMANAN", "ParentId": "Davao City"},
      {"ID": 104, 'Name': "LAMPIANAO", "ParentId": "Davao City"},
      {"ID": 105, 'Name': "LANGUB", "ParentId": "Davao City"},
      {"ID": 106, 'Name': "LAPU-LAPU", "ParentId": "Davao City"},
      {"ID": 107, 'Name': "LEON GARCIA, SR.", "ParentId": "Davao City"},
      {"ID": 108, 'Name': "LIZADA", "ParentId": "Davao City"},
      {"ID": 109, 'Name': "LOS AMIGOS", "ParentId": "Davao City"},
      {"ID": 110, 'Name': "LUBOGAN", "ParentId": "Davao City"},
      {"ID": 111, 'Name': "LUMIAD", "ParentId": "Davao City"},
      {"ID": 112, 'Name': "MA-A", "ParentId": "Davao City"},
      {"ID": 113, 'Name': "MABUHAY", "ParentId": "Davao City"},
      {"ID": 114, 'Name': "MAGSAYSAY", "ParentId": "Davao City"},
      {"ID": 115, 'Name': "MAGTUOD", "ParentId": "Davao City"},
      {"ID": 116, 'Name': "MAHAYAG", "ParentId": "Davao City"},
      {"ID": 117, 'Name': "MALABOG", "ParentId": "Davao City"},
      {"ID": 118, 'Name': "MALAGOS", "ParentId": "Davao City"},
      {"ID": 119, 'Name': "MALAMBA", "ParentId": "Davao City"},
      {"ID": 120, 'Name': "MANAMBULAN", "ParentId": "Davao City"},
      {"ID": 121, 'Name': "MANDUG", "ParentId": "Davao City"},
      {"ID": 122, 'Name': "MANUEL GUIANGA", "ParentId": "Davao City"},
      {"ID": 123, 'Name': "MAPULA", "ParentId": "Davao City"},
      {"ID": 124, 'Name': "MARAPANGI", "ParentId": "Davao City"},
      {"ID": 125, 'Name': "MARILOG", "ParentId": "Davao City"},
      {"ID": 126, 'Name': "MATINA APLAYA", "ParentId": "Davao City"},
      {"ID": 127, 'Name': "MATINA BIAO", "ParentId": "Davao City"},
      {"ID": 128, 'Name': "MATINA CROSSING", "ParentId": "Davao City"},
      {"ID": 129, 'Name': "MATINA PANGI", "ParentId": "Davao City"},
      {"ID": 130, 'Name': "MEGKAWAYAN", "ParentId": "Davao City"},
      {"ID": 131, 'Name': "MINTAL", "ParentId": "Davao City"},
      {"ID": 132, 'Name': "MUDIANG", "ParentId": "Davao City"},
      {"ID": 133, 'Name': "MULIG", "ParentId": "Davao City"},
      {"ID": 134, 'Name': "NEW CARMEN", "ParentId": "Davao City"},
      {"ID": 135, 'Name': "NEW VALENCIA", "ParentId": "Davao City"},
      {"ID": 136, 'Name': "PAMPANGA", "ParentId": "Davao City"},
      {"ID": 137, 'Name': "PANACAN", "ParentId": "Davao City"},
      {"ID": 138, 'Name': "PANALUM", "ParentId": "Davao City"},
      {"ID": 139, 'Name': "PANDAITAN", "ParentId": "Davao City"},
      {"ID": 140, 'Name': "PANGYAN", "ParentId": "Davao City"},
      {"ID": 141, 'Name': "PAQUIBATO (POB.)", "ParentId": "Davao City"},
      {"ID": 142, 'Name': "PARADISE EMBAK", "ParentId": "Davao City"},
      {"ID": 143, 'Name': "RAFAEL CASTILLO", "ParentId": "Davao City"},
      {"ID": 144, 'Name': "RIVERSIDE", "ParentId": "Davao City"},
      {"ID": 145, 'Name': "SALAPAWAN", "ParentId": "Davao City"},
      {"ID": 146, 'Name': "SALAYSAY", "ParentId": "Davao City"},
      {"ID": 147, 'Name': "SALOY", "ParentId": "Davao City"},
      {"ID": 148, 'Name': "SAN ANTONIO", "ParentId": "Davao City"},
      {"ID": 149, 'Name': "SAN ISIDRO (LICANAN)", "ParentId": "Davao City"},
      {"ID": 150, 'Name': "SANTO NIÑO", "ParentId": "Davao City"},
      {"ID": 151, 'Name': "SASA", "ParentId": "Davao City"},
      {"ID": 152, 'Name': "SIBULAN", "ParentId": "Davao City"},
      {"ID": 153, 'Name': "SIRAWAN", "ParentId": "Davao City"},
      {"ID": 154, 'Name': "SIRIB", "ParentId": "Davao City"},
      {"ID": 155, 'Name': "SUAWAN (TULI)", "ParentId": "Davao City"},
      {"ID": 156, 'Name': "SUBASTA", "ParentId": "Davao City"},
      {"ID": 157, 'Name': "SUMIMAO", "ParentId": "Davao City"},
      {"ID": 158, 'Name': "TACUNAN", "ParentId": "Davao City"},
      {"ID": 159, 'Name': "TAGAKPAN", "ParentId": "Davao City"},
      {"ID": 160, 'Name': "TAGLUNO", "ParentId": "Davao City"},
      {"ID": 161, 'Name': "TAGURANO", "ParentId": "Davao City"},
      {"ID": 162, 'Name': "TALANDANG", "ParentId": "Davao City"},
      {"ID": 163, 'Name': "TALOMO (POB.)", "ParentId": "Davao City"},
      {"ID": 164, 'Name': "TALOMO RIVER", "ParentId": "Davao City"},
      {"ID": 165, 'Name': "TAMAYONG", "ParentId": "Davao City"},
      {"ID": 166, 'Name': "TAMBOBONG", "ParentId": "Davao City"},
      {"ID": 167, 'Name': "TAMUGAN", "ParentId": "Davao City"},
      {"ID": 168, 'Name': "TAPAK", "ParentId": "Davao City"},
      {"ID": 169, 'Name': "TAWAN-TAWAN", "ParentId": "Davao City"},
      {"ID": 170, 'Name': "TIBULOY", "ParentId": "Davao City"},
      {"ID": 171, 'Name': "TIBUNGCO", "ParentId": "Davao City"},
      {"ID": 172, 'Name': "TIGATTO", "ParentId": "Davao City"},
      {"ID": 173, 'Name': "TORIL (POB.)", "ParentId": "Davao City"},
      {"ID": 174, 'Name': "TUGBOK (POB.)", "ParentId": "Davao City"},
      {"ID": 175, 'Name': "TUNGAKALAN", "ParentId": "Davao City"},
      {"ID": 176, 'Name': "UBALDE", "ParentId": "Davao City"},
      {"ID": 177, 'Name': "ULA", "ParentId": "Davao City"},
      {"ID": 178, 'Name': "VICENTE HIZON SR.", "ParentId": "Davao City"},
      {"ID": 179, 'Name': "WAAN", "ParentId": "Davao City"},
      {"ID": 180, 'Name': "WANGAN", "ParentId": "Davao City"},
      {"ID": 181, 'Name': "WILFREDO AQUINO", "ParentId": "Davao City"},
      {"ID": 182, 'Name': "WINES", "ParentId": "Davao City"},
      {"ID": 1, 'Name': "APLAYA", "ParentId": "Digos City"},
      {"ID": 2, 'Name': "BALABAG", "ParentId": "Digos City"},
      {"ID": 3, 'Name': "BINATON", "ParentId": "Digos City"},
      {"ID": 4, 'Name': "COGON", "ParentId": "Digos City"},
      {"ID": 5, 'Name': "COLORADO", "ParentId": "Digos City"},
      {"ID": 6, 'Name': "DAWIS", "ParentId": "Digos City"},
      {"ID": 7, 'Name': "DULANGAN", "ParentId": "Digos City"},
      {"ID": 8, 'Name': "GOMA", "ParentId": "Digos City"},
      {"ID": 9, 'Name': "IGPIT", "ParentId": "Digos City"},
      {"ID": 10, 'Name': "KAPATAGAN (RIZAL)", "ParentId": "Digos City"},
      {"ID": 11, 'Name': "KIAGOT", "ParentId": "Digos City"},
      {"ID": 12, 'Name': "LUNGAG", "ParentId": "Digos City"},
      {"ID": 13, 'Name': "MAHAYAHAY", "ParentId": "Digos City"},
      {"ID": 14, 'Name': "MATTI", "ParentId": "Digos City"},
      {"ID": 15, 'Name': "RUPARAN", "ParentId": "Digos City"},
      {"ID": 16, 'Name': "SAN AGUSTIN", "ParentId": "Digos City"},
      {"ID": 17, 'Name': "SAN JOSE (BALUTAKAY)", "ParentId": "Digos City"},
      {"ID": 18, 'Name': "SAN MIGUEL (ODACA)", "ParentId": "Digos City"},
      {"ID": 19, 'Name': "SAN ROQUE", "ParentId": "Digos City"},
      {"ID": 20, 'Name': "SINAWILAN", "ParentId": "Digos City"},
      {"ID": 21, 'Name': "SOONG", "ParentId": "Digos City"},
      {"ID": 22, 'Name': "TIGUMAN", "ParentId": "Digos City"},
      {"ID": 23, 'Name': "TRES DE MAYO", "ParentId": "Digos City"},
      {"ID": 24, 'Name': "ZONE 1 (POB.)", "ParentId": "Digos City"},
      {"ID": 25, 'Name': "ZONE 2 (POB.)", "ParentId": "Digos City"},
      {"ID": 26, 'Name': "ZONE 3 (POB.)", "ParentId": "Digos City"},
    ];

    super.initState();
  }

  @override
  void dispose() {
    _firstName.dispose();
    _middleName.dispose();
    _lastName.dispose();
    _birthday.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _mothersName.dispose();
    _fathersName.dispose();
    _religion.dispose();
    _ethnicity.dispose();
    _nationality.dispose();
    _resCertNo.dispose();
    _phoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: newBlack,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        leading: BackButton(
          onPressed: () {
            context.read<AuthBloc>().add(
                  const AuthEventLogOut(),
                );
          },
        ),
        centerTitle: true,
        title: const Text('Register'),
      ),
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthStateRegistering) {
            if (state.exception is WeakPasswordAuthException) {
              await showErrorDialog(context, 'Weak password');
            } else if (state.exception is EmailAlreadyInUseAuthException) {
              await showErrorDialog(context, 'Email already in use');
            } else if (state.exception is InvalidEmailAuthException) {
              await showErrorDialog(context, 'Invalid email');
            } else if (state.exception is GenericAuthException) {
              await showErrorDialog(context, 'Failed to register');
            }
          }
        },
        child: Stepper(
          onStepTapped: (step) => setState(() => currentStep = step),
          type: StepperType.horizontal,
          steps: getSteps(),
          currentStep: currentStep,
          onStepContinue: () {
            if (formKeys[currentStep].currentState!.validate()) {
              final isLastStep = currentStep == getSteps().length - 1;
              if (isLastStep) {
                print('completed');
                //send data to server
              } else {
                setState(() => currentStep += 1);
              }
            }
          },
          onStepCancel: () {
            currentStep == 0 ? null : setState(() => currentStep -= 1);
          },
          controlsBuilder: (BuildContext context, ControlsDetails controls) {
            final isLastStep = currentStep == getSteps().length - 1;
            return Container(
              margin: const EdgeInsets.only(top: 30),
              child: Row(
                children: [
                  Expanded(
                      child: currentStep != 0
                          ? CustomTextButton(
                              onPressed: controls.onStepCancel,
                              title: 'Previous',
                            )
                          : Container()),
                  Expanded(
                    child: FullWidthElevatedButton(
                      onPressed: isLastStep
                          ? () async {
                              final patientId = _patientId;
                              final email = _email.text;
                              final password = _password.text;
                              final firstName = _firstName.text;
                              final middleName = _middleName.text;
                              final lastName = _lastName.text;
                              final birthday = _birthday.text;
                              final gender = _gender;
                              final mothersName = _mothersName.text;
                              final fathersName = _fathersName.text;
                              final religion = _religion.text;
                              final ethnicity = _ethnicity.text;
                              final nationality = _nationality.text;
                              final city = _city;
                              final barangay = _barangay;
                              final resCertNo = _resCertNo.text;
                              final highestEducation = _highestEducation;
                              final civilStatus = _civilStatus;
                              final phoneNumber = _phoneNumber.text;
                              final establishment = _establishment;
                              context.read<AuthBloc>().add(
                                    AuthEventRegister(
                                      patientId!,
                                      email,
                                      password,
                                      firstName,
                                      middleName,
                                      lastName,
                                      birthday,
                                      gender!,
                                      mothersName,
                                      fathersName,
                                      religion,
                                      ethnicity,
                                      nationality,
                                      city!,
                                      barangay!,
                                      resCertNo,
                                      highestEducation!,
                                      civilStatus!,
                                      phoneNumber,
                                      establishment!,
                                    ),
                                  );
                            }
                          : controls.onStepContinue,
                      label: isLastStep ? 'Submit' : 'Next',
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Step> getSteps() => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: const Text(''),
          // title: const Text('Basic Info'),
          content: Form(
            key: formKeys[0],
            child: Column(
              children: [
                TextFormField(
                  controller: _firstName,
                  decoration: const InputDecoration(
                    label: Text('First Name'),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter first name';
                    }
                    return null;
                  },
                ),
                buildSpacer(),
                TextFormField(
                  controller: _middleName,
                  decoration: const InputDecoration(
                    label: Text('Middle Name'),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter middle name';
                    }
                    return null;
                  },
                ),
                buildSpacer(),
                TextFormField(
                  controller: _lastName,
                  decoration: const InputDecoration(
                    label: Text('Last Name'),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter last name';
                    }
                    return null;
                  },
                ),
                buildSpacer(),
                TextFormField(
                  readOnly: true,
                  controller: _birthday,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.calendar_month_rounded),
                    label: Text('Birthday'),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter birthday';
                    }
                    return null;
                  },
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      helpText: 'SELECT BIRTHDAY',
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime(2101),
                      builder: (context, child) => Theme(
                        data: ThemeData().copyWith(
                            colorScheme: const ColorScheme.light(
                          primary: primaryColor,
                          surface: primaryColor,
                        )),
                        child: child!,
                      ),
                    );

                    if (pickedDate != null) {
                      // print(pickedDate);
                      String formattedDate =
                          DateFormat('MM-dd-yyyy').format(pickedDate);
                      // print(formattedDate);

                      setState(() {
                        _birthday.text = formattedDate;
                      });
                    } else {
                      // print("Date is not selected");
                    }
                  },
                ),
                buildSpacer(),
                DropdownButtonFormField(
                  isDense: true,
                  isExpanded: true,
                  value: _gender,
                  decoration: const InputDecoration(labelText: 'Gender'),
                  validator: (value) =>
                      value == null ? 'Please select gender' : null,
                  items: genders
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        ),
                      )
                      .toList(),
                  onChanged: (item) => setState(
                    () => _gender = item as String,
                  ),
                )
              ],
            ),
          ),
        ),
        Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: const Text(''),
          // title: const Text('Other Info'),
          content: Form(
            key: formKeys[1],
            child: Column(
              children: [
                TextFormField(
                  controller: _mothersName,
                  decoration: const InputDecoration(
                    label: Text('Mother\'s Name'),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter mother\'s name';
                    }
                    return null;
                  },
                ),
                buildSpacer(),
                TextFormField(
                  controller: _fathersName,
                  decoration: const InputDecoration(
                    label: Text('Father\'s Name'),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter father\'s name';
                    }
                    return null;
                  },
                ),
                buildSpacer(),
                TextFormField(
                  controller: _religion,
                  decoration: const InputDecoration(
                    label: Text('Religion'),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter religion';
                    }
                    return null;
                  },
                ),
                buildSpacer(),
                TextFormField(
                  controller: _ethnicity,
                  decoration: const InputDecoration(
                    label: Text('Ethnicity'),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter ethnicity';
                    }
                    return null;
                  },
                ),
                buildSpacer(),
                TextFormField(
                  controller: _nationality,
                  decoration: const InputDecoration(
                    label: Text('Nationality'),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter nationality';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: const Text(''),
          // title: const Text('Profile'),
          content: Form(
            key: formKeys[2],
            child: Column(
              children: [
                FormHelper.dropDownWidget(
                  context,
                  'Select City',
                  this._city,
                  this.cities,
                  (onChangedVal) {
                    this._city = onChangedVal;
                    print('Selected City $onChangedVal');
                    this.barangays = this
                        .brgyOptions
                        .where((stateItem) =>
                            stateItem["ParentId"].toString() ==
                            onChangedVal.toString())
                        .toList();
                    this._barangay = null;
                    setState(() {});
                  },
                  (onValidateVal) {
                    if (onValidateVal == null) {
                      return 'Please select a city';
                    }
                    return null;
                  },
                  paddingLeft: 0,
                  paddingRight: 0,
                  contentPadding: 10,
                  borderRadius: 5,
                  borderColor: Colors.grey,
                ),
                buildSpacer(),
                FormHelper.dropDownWidget(
                  context,
                  'Select Barangay',
                  this._barangay,
                  this.barangays,
                  (onChangedVal) {
                    this._barangay = onChangedVal;
                    setState(() {});
                    print('Selected barangay: $onChangedVal');
                  },
                  (onValidate) {
                    if (onValidate == null) {
                      return 'Please select a barangay';
                    }
                  },
                  paddingLeft: 0,
                  paddingRight: 0,
                  contentPadding: 10,
                  optionLabel: "Name",
                  optionValue: "Name",
                  borderRadius: 5,
                  borderColor: Colors.grey,
                ),
                buildSpacer(),
                TextFormField(
                  controller: _resCertNo,
                  decoration: const InputDecoration(
                    label: Text('Residential Certificate No.'),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter RCN';
                    }
                    return null;
                  },
                ),
                buildSpacer(),
              ],
            ),
          ),
        ),
        Step(
          state: currentStep > 3 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 3,
          title: const Text(''),
          // title: const Text('Profile'),
          content: Form(
            key: formKeys[3],
            child: Column(
              children: [
                TextFormField(
                  controller: _phoneNumber,
                  decoration: const InputDecoration(
                    label: Text('Phone Number'),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter phone number';
                    }
                    return null;
                  },
                ),
                buildSpacer(),
                DropdownButtonFormField(
                  isDense: true,
                  isExpanded: true,
                  value: _highestEducation,
                  decoration: const InputDecoration(
                      labelText: 'Highest Educational Attainment'),
                  validator: (value) =>
                      value == null ? 'Please select HEA' : null,
                  items: highestEducationalAttainment
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        ),
                      )
                      .toList(),
                  onChanged: (item) => setState(
                    () => _highestEducation = item as String,
                  ),
                ),
                buildSpacer(),
                DropdownButtonFormField(
                  isDense: true,
                  isExpanded: true,
                  value: _civilStatus,
                  decoration: const InputDecoration(labelText: 'Civil Status'),
                  validator: (value) =>
                      value == null ? 'Please select Civil Status' : null,
                  items: civilStatusType
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        ),
                      )
                      .toList(),
                  onChanged: (item) => setState(
                    () => _civilStatus = item as String,
                  ),
                ),
                buildSpacer(),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('establishments')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Text('Loading...');
                    } else {
                      List<DropdownMenuItem> establishmentItems = [];
                      for (int i = 0; i < snapshot.data!.docs.length; i++) {
                        DocumentSnapshot snap = snapshot.data!.docs[i];
                        establishmentItems.add(
                          DropdownMenuItem(
                            //value must be id and name of the establishment in array
                            value: snap.id,
                            child: Text(
                              snap['name'],
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        );
                      }
                      return DropdownButtonFormField(
                        isDense: true,
                        isExpanded: true,
                        value: _establishment,
                        decoration:
                            const InputDecoration(labelText: 'Establishment'),
                        items: establishmentItems,
                        validator: (value) => value == null
                            ? 'Please select establishment'
                            : null,
                        onChanged: (establishmentValue) {
                          setState(() {
                            _establishment = establishmentValue.toString();
                          });
                        },
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
        Step(
          state: currentStep > 4 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 4,
          title: const Text(''),
          // title: const Text('Account'),
          content: Form(
            key: formKeys[4],
            child: Column(
              children: [
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(
                    label: Text('Email'),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter email';
                    } else if (!value.contains('@')) {
                      return 'Please enter valid email';
                    }
                    return null;
                  },
                ),
                buildSpacer(),
                OutlinedTextField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter password';
                    } else if (value.length < 8) {
                      return 'at least 8 characters required';
                    }
                    return null;
                  },
                  maxLines: 1,
                  readOnly: false,
                  label: 'Password',
                  controller: _password,
                  textInputAction: TextInputAction.next,
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
                buildSpacer(),
                OutlinedTextField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please re-enter password';
                    }
                    // print(password.text);
                    // print(confirmPassword.text);
                    if (_password.text != _confirmPassword.text) {
                      return "Password does not match";
                    }
                    return null;
                  },
                  maxLines: 1,
                  readOnly: false,
                  label: 'Confirm Password',
                  controller: _confirmPassword,
                  textInputAction: TextInputAction.done,
                  obscureText: !_confirmPasswordVisible,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _confirmPasswordVisible = !_confirmPasswordVisible;
                      });
                    },
                    icon: Icon(
                      _confirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Step(
          isActive: currentStep >= 5,
          // title: const Text('Confirm'),
          title: const Text(''),
          content: Column(
            children: [
              buildConfirmField('First Name', _firstName),
              buildSpacer(),
              buildConfirmField('Middle Name', _middleName),
              buildSpacer(),
              buildConfirmField('Last Name', _lastName),
              buildSpacer(),
              buildConfirmField('Birthday', _birthday),
              buildSpacer(),
              Row(
                children: [
                  const Text(
                    'Gender',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(child: Text(_gender.toString()))
                ],
              ),
              buildSpacer(),
              buildConfirmField('Mother\'s Name', _mothersName),
              buildSpacer(),
              buildConfirmField('Father\'s Name', _fathersName),
              buildSpacer(),
              buildConfirmField('Religion', _religion),
              buildSpacer(),
              buildConfirmField('Ethnicity', _ethnicity),
              buildSpacer(),
              buildConfirmField('Nationality', _nationality),
              buildSpacer(),
              Row(
                children: [
                  const Text(
                    'City',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(child: Text(_city.toString()))
                ],
              ),
              buildSpacer(),
              Row(
                children: [
                  const Text(
                    'Barangay',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(child: Text(_barangay.toString()))
                ],
              ),
              buildSpacer(),
              buildConfirmField('Res. Cert. No. ', _resCertNo),
              buildSpacer(),
              Row(
                children: [
                  const Text(
                    'High. Educ. Attain.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(child: Text(_highestEducation.toString()))
                ],
              ),
              buildSpacer(),
              Row(
                children: [
                  const Text(
                    'Civil Status',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(child: Text(_civilStatus.toString()))
                ],
              ),
              buildSpacer(),
              buildConfirmField('Phone Number ', _phoneNumber),
              buildSpacer(),
              buildConfirmField('Email', _email),
            ],
          ),
        ),
      ];
  buildConfirmField(String label, value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(child: Text(value.text))
      ],
    );
  }

  buildSpacer() {
    return const SizedBox(
      height: 10,
    );
  }
}
