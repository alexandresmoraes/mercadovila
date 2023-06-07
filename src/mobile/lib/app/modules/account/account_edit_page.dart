import 'dart:io';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vilasesmo/app/app_widget.dart';
import 'package:vilasesmo/app/modules/account/account_edit_controller.dart';
import 'package:vilasesmo/app/stores/theme_store.dart';
import 'package:vilasesmo/app/utils/widgets/global_snackbar.dart';

class AccountEditPage extends StatefulWidget {
  final String title;
  const AccountEditPage({Key? key, this.title = 'AccountEditPage'}) : super(key: key);
  @override
  AccountEditPageState createState() => AccountEditPageState();
}

class AccountEditPageState extends State<AccountEditPage> {
  bool isAdmin = false;
  late AccountEditController _controller;

  AccountEditPageState() : super() {
    _controller = Modular.get<AccountEditController>();
  }

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
              toolbarColor: Theme.of(context).scaffoldBackgroundColor,
              toolbarWidgetColor: Theme.of(context).primaryIconTheme.color),
          IOSUiSettings(
            title: 'Recortar',
            minimumAspectRatio: 1.0,
            aspectRatioLockEnabled: true,
          ),
          WebUiSettings(context: context)
        ]);
    if (croppedImage != null) {
      _controller.setPhotoPath(croppedImage.path);
      Modular.to.pop();
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
        body: FutureBuilder(
          future: _controller.fetch('061c84c4-ddfb-4d10-ace3-123756fdb5dd'),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: SizedBox(
                  height: 21,
                  width: 21,
                  child: CircularProgressIndicator(
                    strokeCap: StrokeCap.round,
                    color: Theme.of(context).primaryTextTheme.displaySmall!.color,
                  ),
                ),
              );
            }

            return Column(
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
                          child: Center(
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white,
                              child: Observer(builder: (_) {
                                if (_controller.isFotoAlterada) {
                                  return CircleAvatar(
                                    radius: 100,
                                    backgroundImage: Image.file(File(_controller.photoPath!)).image,
                                  );
                                }
                                return const CircleAvatar(
                                  radius: 100,
                                  backgroundImage: AssetImage('assets/person.png'),
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 25,
                        child: TextButton(
                          onPressed: () {
                            showCupertinoModalPopup<void>(
                              context: context,
                              builder: (BuildContext context) => CupertinoActionSheet(
                                // title: const Text('Title'),
                                // message: const Text('Message'),
                                actions: <Widget>[
                                  Container(
                                    color: Colors.white,
                                    child: CupertinoActionSheetAction(
                                      isDefaultAction: true,
                                      onPressed: () {
                                        _getImagePicker(ImageSource.camera);
                                      },
                                      child: const Text(
                                        'Camera',
                                        style: TextStyle(
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                  CupertinoActionSheetAction(
                                    onPressed: () {
                                      _getImagePicker(ImageSource.gallery);
                                    },
                                    child: const Text(
                                      'Galeria',
                                      style: TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                  CupertinoActionSheetAction(
                                    /// This parameter indicates the action would perform
                                    /// a destructive action such as delete or exit and turns
                                    /// the action's text color to red.
                                    isDestructiveAction: true,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Cancelar',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                            // showModalBottomSheet(
                            //     context: context,
                            //     builder: (context) {
                            //       return Column(
                            //         mainAxisSize: MainAxisSize.min,
                            //         children: <Widget>[
                            //           ListTile(
                            //             leading: const Icon(Icons.photo),
                            //             title: const Text('Galeria'),
                            //             onTap: () {
                            //               _getImagePicker(ImageSource.gallery);
                            //             },
                            //           ),
                            //           ListTile(
                            //             leading: const Icon(Icons.photo_camera),
                            //             title: const Text('Camera'),
                            //             onTap: () {
                            //               _getImagePicker(ImageSource.camera);
                            //             },
                            //           ),
                            //         ],
                            //       );
                            //     });
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
                            child: Observer(builder: (_) {
                              return TextFormField(
                                style: Theme.of(context).primaryTextTheme.bodyLarge,
                                autocorrect: true,
                                initialValue: _controller.nome,
                                onChanged: _controller.setNome,
                                decoration: InputDecoration(
                                  fillColor: Modular.get<ThemeStore>().isDarkModeEnable
                                      ? Theme.of(context).inputDecorationTheme.fillColor
                                      : Theme.of(context).scaffoldBackgroundColor,
                                  hintText: 'João das Neves',
                                  errorText: _controller.getNomeError,
                                  contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                ),
                              );
                            }),
                          ),
                          Text(
                            "Nome de usuário",
                            style: Theme.of(context).primaryTextTheme.displayMedium,
                          ),
                          Container(
                            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                            margin: const EdgeInsets.only(top: 5, bottom: 15),
                            padding: const EdgeInsets.only(),
                            child: Observer(builder: (_) {
                              return TextFormField(
                                style: Theme.of(context).primaryTextTheme.bodyLarge,
                                initialValue: _controller.username,
                                onChanged: _controller.setUsername,
                                decoration: InputDecoration(
                                  fillColor: Modular.get<ThemeStore>().isDarkModeEnable
                                      ? Theme.of(context).inputDecorationTheme.fillColor
                                      : Theme.of(context).scaffoldBackgroundColor,
                                  hintText: 'jonsnow',
                                  contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                  errorText: _controller.getUsernameError,
                                ),
                              );
                            }),
                          ),
                          Text(
                            "Telefone",
                            style: Theme.of(context).primaryTextTheme.displayMedium,
                          ),
                          Container(
                            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                            margin: const EdgeInsets.only(top: 5, bottom: 15),
                            padding: const EdgeInsets.only(),
                            child: Observer(builder: (_) {
                              return TextFormField(
                                style: Theme.of(context).primaryTextTheme.bodyLarge,
                                initialValue: _controller.telefone,
                                onChanged: _controller.setTelefone,
                                decoration: InputDecoration(
                                  fillColor: Modular.get<ThemeStore>().isDarkModeEnable
                                      ? Theme.of(context).inputDecorationTheme.fillColor
                                      : Theme.of(context).scaffoldBackgroundColor,
                                  hintText: '+55 46999057070',
                                  contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                  errorText: _controller.getTelefoneError,
                                ),
                              );
                            }),
                          ),
                          Text(
                            "Email",
                            style: Theme.of(context).primaryTextTheme.displayMedium,
                          ),
                          Container(
                            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                            margin: const EdgeInsets.only(top: 5, bottom: 15),
                            padding: const EdgeInsets.only(),
                            child: Observer(builder: (_) {
                              return TextFormField(
                                style: Theme.of(context).primaryTextTheme.bodyLarge,
                                initialValue: _controller.email,
                                onChanged: _controller.setEmail,
                                decoration: InputDecoration(
                                  fillColor: Modular.get<ThemeStore>().isDarkModeEnable
                                      ? Theme.of(context).inputDecorationTheme.fillColor
                                      : Theme.of(context).scaffoldBackgroundColor,
                                  hintText: 'jonsnow@got.com',
                                  contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                  errorText: _controller.getEmailError,
                                ),
                              );
                            }),
                          ),
                          Text(
                            "Senha",
                            style: Theme.of(context).primaryTextTheme.displayMedium,
                          ),
                          Container(
                            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                            margin: const EdgeInsets.only(top: 5, bottom: 15),
                            padding: const EdgeInsets.only(),
                            child: Observer(builder: (_) {
                              return TextFormField(
                                style: Theme.of(context).primaryTextTheme.bodyLarge,
                                obscureText: !_controller.isPasswordVisible,
                                initialValue: _controller.password,
                                onChanged: _controller.setPassword,
                                decoration: InputDecoration(
                                  fillColor: Modular.get<ThemeStore>().isDarkModeEnable
                                      ? Theme.of(context).inputDecorationTheme.fillColor
                                      : Theme.of(context).scaffoldBackgroundColor,
                                  hintText: 'Digite a senha',
                                  contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                  errorText: _controller.getPasswordError,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _controller.isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      _controller.isPasswordVisible = !_controller.isPasswordVisible;
                                    },
                                  ),
                                ),
                              );
                            }),
                          ),
                          Text(
                            "Confirmação de senha",
                            style: Theme.of(context).primaryTextTheme.displayMedium,
                          ),
                          Container(
                            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                            margin: const EdgeInsets.only(top: 5, bottom: 15),
                            padding: const EdgeInsets.only(),
                            child: Observer(builder: (_) {
                              return TextFormField(
                                style: Theme.of(context).primaryTextTheme.bodyLarge,
                                obscureText: !_controller.isConfirmPasswordVisible,
                                initialValue: _controller.confirmPassword,
                                onChanged: _controller.setConfirmPassword,
                                decoration: InputDecoration(
                                  fillColor: Modular.get<ThemeStore>().isDarkModeEnable
                                      ? Theme.of(context).inputDecorationTheme.fillColor
                                      : Theme.of(context).scaffoldBackgroundColor,
                                  hintText: 'Confirme a senha',
                                  contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                  errorText: _controller.getConfirmPasswordError,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _controller.isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      _controller.isConfirmPasswordVisible = !_controller.isConfirmPasswordVisible;
                                    },
                                  ),
                                ),
                              );
                            }),
                          ),
                          Card(
                            child: Observer(
                              builder: (_) {
                                return SwitchListTile(
                                  value: _controller.isAtivo,
                                  onChanged: (v) {
                                    _controller.setIsAtivo(v);
                                  },
                                  title: Text(
                                    "Ativo",
                                    style: Theme.of(context).primaryTextTheme.bodyLarge,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Card(
                            child: Observer(builder: (_) {
                              return SwitchListTile(
                                value: _controller.isAdmin,
                                onChanged: (v) {
                                  _controller.setIsAdmin(v);
                                },
                                title: Text(
                                  "Admin",
                                  style: Theme.of(context).primaryTextTheme.bodyLarge,
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
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
                child: Observer(builder: (_) {
                  return TextButton(
                    onPressed: () {
                      if (_controller.isValid) {
                        _controller.save();
                      } else {
                        GlobalSnackbar.error('ERROU!');
                      }
                    },
                    child: _controller.isLoading
                        ? Center(
                            child: SizedBox(
                              height: 21,
                              width: 21,
                              child: CircularProgressIndicator(
                                strokeCap: StrokeCap.round,
                                color: Theme.of(context).primaryTextTheme.displaySmall!.color,
                              ),
                            ),
                          )
                        : const Text('Salvar'),
                  );
                }),
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
