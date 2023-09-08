import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/modules/notificacoes/notificacoes_edit_controller.dart';
import 'package:vilasesmo/app/stores/theme_store.dart';
import 'package:vilasesmo/app/utils/utils.dart';
import 'package:vilasesmo/app/utils/widgets/circular_progress.dart';
import 'package:vilasesmo/app/utils/widgets/future_triple.dart';
import 'package:vilasesmo/app/utils/widgets/refresh_widget.dart';

class NotificacoesEditPage extends StatefulWidget {
  final String title;
  final String? id;
  const NotificacoesEditPage({Key? key, this.title = 'NotificacoesEditPage', this.id}) : super(key: key);
  @override
  NotificacoesEditPageState createState() => NotificacoesEditPageState();
}

class NotificacoesEditPageState extends State<NotificacoesEditPage> {
  late NotificacoesEditController _controller;

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
      _controller.setImagePath(croppedImage.path);
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
          title: Text(isNullorEmpty(widget.id) ? "Criando notificação" : "Editando notificação"),
        ),
        body: FutureTriple(
          future: _controller.load(),
          error: RefreshWidget(
            onTap: () => setState(() {}),
          ),
          loading: const CircularProgress(),
          data: Column(
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
                              if (!isNullorEmpty(_controller.imagePath)) {
                                return CircleAvatar(
                                  radius: 100,
                                  backgroundImage: Image.file(
                                    File(
                                      _controller.imagePath!,
                                    ),
                                  ).image,
                                );
                              } else if (!isNullorEmpty(_controller.imageUrl)) {
                                return CachedNetworkImage(
                                  placeholder: (context, url) => CircularProgress(
                                    color: Theme.of(context).primaryColorLight,
                                    width: 100,
                                    height: 100,
                                  ),
                                  errorWidget: (context, url, error) => const CircleAvatar(
                                    radius: 100,
                                    backgroundImage: AssetImage('assets/person.png'),
                                  ),
                                  imageUrl:
                                      '${Modular.get<BaseOptions>().baseUrl}/api/notificacoes/image/${_controller.imageUrl!}',
                                  imageBuilder: (context, imageProvider) {
                                    return CircleAvatar(
                                      radius: 100,
                                      backgroundImage: imageProvider,
                                    );
                                  },
                                );
                              }

                              return const CircleAvatar(
                                radius: 100,
                                child: Icon(
                                  MdiIcons.cameraPlus,
                                  size: 70,
                                  color: Colors.white,
                                ),
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
                              title: const Icon(Icons.camera_alt_rounded),
                              actions: <Widget>[
                                CupertinoActionSheetAction(
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
                                  isDestructiveAction: true,
                                  onPressed: () {
                                    Modular.to.pop();
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
                        },
                        child: Observer(builder: (_) {
                          return Text(
                            isNullorEmpty(_controller.imageUrl) && isNullorEmpty(_controller.imagePath)
                                ? 'Escolher imagem'
                                : 'Trocar imagem',
                            style: Theme.of(context).primaryTextTheme.displayLarge,
                          );
                        }),
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
                          "Título",
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
                              initialValue: _controller.titulo,
                              onChanged: _controller.setTitulo,
                              decoration: InputDecoration(
                                fillColor: Modular.get<ThemeStore>().isDarkModeEnable
                                    ? Theme.of(context).inputDecorationTheme.fillColor
                                    : Theme.of(context).scaffoldBackgroundColor,
                                hintText: 'Atenção!',
                                errorText: _controller.getTituloError,
                                contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                              ),
                            );
                          }),
                        ),
                        Text(
                          "Mensagem",
                          style: Theme.of(context).primaryTextTheme.displayMedium,
                        ),
                        Container(
                          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                          margin: const EdgeInsets.only(top: 5, bottom: 15),
                          padding: const EdgeInsets.only(),
                          child: Observer(builder: (_) {
                            return TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: 8,
                              style: Theme.of(context).primaryTextTheme.bodyLarge,
                              initialValue: _controller.mensagem,
                              onChanged: _controller.setMensagem,
                              decoration: InputDecoration(
                                fillColor: Modular.get<ThemeStore>().isDarkModeEnable
                                    ? Theme.of(context).inputDecorationTheme.fillColor
                                    : Theme.of(context).scaffoldBackgroundColor,
                                hintText: 'Nossos estoques foram renovados, confira!',
                                contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                errorText: _controller.getMensagemError,
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
          ),
        ),
        bottomNavigationBar: Observer(
          builder: (_) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    !_controller.isLoading
                        ? Expanded(
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
                              margin: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                                bottom: 8,
                              ),
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              child: Observer(builder: (_) {
                                return TextButton(
                                  onPressed: () async {
                                    if (!_controller.isDeleting && !_controller.isDeleting && _controller.isValid) {
                                      await _controller.save();
                                    }
                                  },
                                  child: _controller.isSaving
                                      ? const CircularProgress(
                                          width: 21,
                                          height: 21,
                                        )
                                      : Text(isNullorEmpty(widget.id) ? 'Criar' : 'Editar'),
                                );
                              }),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
                !isNullorEmpty(widget.id)
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          !_controller.isLoading
                              ? Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                      gradient: LinearGradient(
                                        stops: const [0, .90],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [Theme.of(context).primaryColor, Colors.red],
                                      ),
                                    ),
                                    margin: const EdgeInsets.only(
                                      left: 8,
                                      right: 8,
                                      bottom: 8,
                                    ),
                                    height: 50,
                                    width: MediaQuery.of(context).size.width,
                                    child: Observer(builder: (_) {
                                      return TextButton(
                                        onPressed: () async {
                                          if (!_controller.isDeleting && !_controller.isSaving && _controller.isValid) {
                                            await _controller.delete();
                                          }
                                        },
                                        child: _controller.isDeleting
                                            ? const CircularProgress(
                                                width: 21,
                                                height: 21,
                                              )
                                            : const Text('Excluir'),
                                      );
                                    }),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      )
                    : const SizedBox.shrink(),
              ],
            );
          },
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
    _controller = Modular.get<NotificacoesEditController>();
    _controller.id = widget.id;

    super.initState();
  }
}
