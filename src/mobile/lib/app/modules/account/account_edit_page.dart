import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vilasesmo/app/stores/theme_store.dart';

class AccountEditPage extends StatefulWidget {
  final String title;
  const AccountEditPage({Key? key, this.title = 'AccountEditPage'}) : super(key: key);
  @override
  AccountEditPageState createState() => AccountEditPageState();
}

class AccountEditPageState extends State<AccountEditPage> {
  bool isAdmin = false;
  AccountEditPageState() : super();

  _getImagePicker(ImageSource source) async {
    var pickedFile = await ImagePicker().pickImage(
      source: source,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 100,
    );
    if (pickedFile != null) _cropImage(pickedFile.path);
  }

  _cropImage(filePath) async {
    var croppedImage = await ImageCropper().cropImage(
        sourcePath: filePath,
        maxWidth: 1920,
        maxHeight: 1080,
        aspectRatioPresets: CropAspectRatioPreset.values,
        compressQuality: 100,
        aspectRatio: const CropAspectRatio(
          ratioX: 1,
          ratioY: 1,
        ),
        cropStyle: CropStyle.circle,
        compressFormat: ImageCompressFormat.png,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Recortar',
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Recortar',
            minimumAspectRatio: 1.0,
            aspectRatioLockEnabled: true,
          ),
          WebUiSettings(context: context)
        ]);
    if (croppedImage != null) {
      // List<int> imageBytes = croppedImage.readAsBytes();
      // String base64Image = base64Encode(imageBytes);
      // controller.setPhoto(base64Image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Modular.get<ThemeStore>().isDarkModeEnable
            ? Theme.of(context).scaffoldBackgroundColor
            : Theme.of(context).inputDecorationTheme.fillColor,
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Editando usuário"),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 240,
              color: Colors.transparent,
              alignment: Alignment.topCenter,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    height: 240,
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/profile_edit.png'),
                        ),
                      ),
                      alignment: Alignment.topCenter,
                      child: const Center(
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 53,
                            backgroundImage: AssetImage('assets/person.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 25,
                    child: TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    leading: const Icon(Icons.photo),
                                    title: const Text('Galeria'),
                                    onTap: () {
                                      _getImagePicker(ImageSource.gallery);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.photo_camera),
                                    title: const Text('Camera'),
                                    onTap: () {
                                      _getImagePicker(ImageSource.camera);
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                      child: Text(
                        'Trocar foto',
                        style: Theme.of(context).primaryTextTheme.displayLarge,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nome completo",
                        style: Theme.of(context).primaryTextTheme.displayMedium,
                      ),
                      Container(
                        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                        margin: const EdgeInsets.only(top: 5, bottom: 15),
                        padding: const EdgeInsets.only(),
                        child: TextFormField(
                          style: Theme.of(context).primaryTextTheme.bodyLarge,
                          decoration: InputDecoration(
                            fillColor: Modular.get<ThemeStore>().isDarkModeEnable
                                ? Theme.of(context).inputDecorationTheme.fillColor
                                : Theme.of(context).scaffoldBackgroundColor,
                            hintText: 'Alexandre Moraes',
                            contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                          ),
                        ),
                      ),
                      Text(
                        "Nome de usuário",
                        style: Theme.of(context).primaryTextTheme.displayMedium,
                      ),
                      Container(
                        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                        margin: const EdgeInsets.only(top: 5, bottom: 15),
                        padding: const EdgeInsets.only(),
                        child: TextFormField(
                          style: Theme.of(context).primaryTextTheme.bodyLarge,
                          decoration: InputDecoration(
                            fillColor: Modular.get<ThemeStore>().isDarkModeEnable
                                ? Theme.of(context).inputDecorationTheme.fillColor
                                : Theme.of(context).scaffoldBackgroundColor,
                            hintText: 'alexandre',
                            contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                          ),
                        ),
                      ),
                      Text(
                        "Telefone",
                        style: Theme.of(context).primaryTextTheme.displayMedium,
                      ),
                      Container(
                        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                        margin: const EdgeInsets.only(top: 5, bottom: 15),
                        padding: const EdgeInsets.only(),
                        child: TextFormField(
                          style: Theme.of(context).primaryTextTheme.bodyLarge,
                          decoration: InputDecoration(
                            fillColor: Modular.get<ThemeStore>().isDarkModeEnable
                                ? Theme.of(context).inputDecorationTheme.fillColor
                                : Theme.of(context).scaffoldBackgroundColor,
                            hintText: '+55 46999055421',
                            contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                          ),
                        ),
                      ),
                      Text(
                        "Email",
                        style: Theme.of(context).primaryTextTheme.displayMedium,
                      ),
                      Container(
                        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                        margin: const EdgeInsets.only(top: 5, bottom: 15),
                        padding: const EdgeInsets.only(),
                        child: TextFormField(
                          style: Theme.of(context).primaryTextTheme.bodyLarge,
                          decoration: InputDecoration(
                            fillColor: Modular.get<ThemeStore>().isDarkModeEnable
                                ? Theme.of(context).inputDecorationTheme.fillColor
                                : Theme.of(context).scaffoldBackgroundColor,
                            hintText: 'alexandresmoraes@me.com',
                            contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                          ),
                        ),
                      ),
                      Card(
                        child: SwitchListTile(
                          value: isAdmin,
                          onChanged: (val) {
                            setState(() {
                              isAdmin = !isAdmin;
                            });
                          },
                          title: Text(
                            isAdmin ? "Ativo" : "Inativo",
                            style: Theme.of(context).primaryTextTheme.bodyLarge,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Card(
                        child: SwitchListTile(
                          value: isAdmin,
                          onChanged: (val) {
                            setState(() {
                              isAdmin = !isAdmin;
                            });
                          },
                          title: Text(
                            "Admin",
                            style: Theme.of(context).primaryTextTheme.bodyLarge,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(
                    stops: const [0, .90],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Theme.of(context).primaryColorLight, Theme.of(context).primaryColor],
                  ),
                ),
                margin: const EdgeInsets.all(8.0),
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Salvar')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }
}
