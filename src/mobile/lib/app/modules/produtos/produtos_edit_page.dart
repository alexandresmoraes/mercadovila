import 'dart:io';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/modules/produtos/produtos_edit_controller.dart';
import 'package:vilasesmo/app/stores/theme_store.dart';
import 'package:vilasesmo/app/utils/utils.dart';
import 'package:vilasesmo/app/utils/widgets/circular_progress.dart';
import 'package:vilasesmo/app/utils/widgets/future_triple.dart';
import 'package:vilasesmo/app/utils/widgets/refresh_widget.dart';

class ProdutosEditPage extends StatefulWidget {
  final String title;
  final String? id;
  const ProdutosEditPage({Key? key, this.title = 'Produto', this.id}) : super(key: key);
  @override
  ProdutosEditPageState createState() => ProdutosEditPageState();
}

class ProdutosEditPageState extends State<ProdutosEditPage> {
  bool isAdmin = false;
  final ProdutosEditController _controller = Modular.get<ProdutosEditController>();

  _getImagePicker(ImageSource source) async {
    var pickedFile = await ImagePicker().pickImage(
      source: source,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 100,
    );

    if (pickedFile != null) {
      if (kIsWeb) {
        _controller.imageMimeType = pickedFile.mimeType;
        _controller.imageFilenameWeb = pickedFile.name;
      }

      if (!kIsWeb && Platform.isWindows) {
        _controller.setImagePath(pickedFile.path);
        Modular.to.pop();
      } else {
        _cropImage(pickedFile.path);
      }
    }
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
          WebUiSettings(
            context: context,
            presentStyle: CropperPresentStyle.page,
            enableZoom: true,
            mouseWheelZoom: false,
          )
        ]);

    if (croppedImage != null) {
      _controller.setImagePath(croppedImage.path);
      Modular.to.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Modular.get<ThemeStore>().isDarkModeEnable ? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).inputDecorationTheme.fillColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(isNullorEmpty(widget.id) ? "Criando produto" : "Editando produto"),
      ),
      body: FutureTriple(
        future: _controller.load(),
        error: RefreshWidget(
          onTap: () => setState(() {}),
        ),
        loading: const CircularProgress(),
        data: (context, snapshot) {
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
                            backgroundColor: Colors.transparent,
                            child: Observer(builder: (_) {
                              if (!isNullorEmpty(_controller.imagePath)) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                    image: DecorationImage(
                                      image: kIsWeb ? Image.network(_controller.imagePath!).image : Image.file(File(_controller.imagePath!)).image,
                                    ),
                                  ),
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
                                    child: Icon(
                                      MdiIcons.cameraOff,
                                      size: 70,
                                      color: Colors.white,
                                    ),
                                  ),
                                  imageUrl: '${Modular.get<BaseOptions>().baseUrl}/api/produtos/image/${_controller.imageUrl!}',
                                  imageBuilder: (context, imageProvider) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                                        image: DecorationImage(
                                          image: imageProvider,
                                        ),
                                      ),
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
                                kIsWeb || Platform.isWindows
                                    ? const SizedBox.shrink()
                                    : CupertinoActionSheetAction(
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
                            isNullorEmpty(_controller.imageUrl) && isNullorEmpty(_controller.imagePath) ? 'Escolher imagem' : 'Trocar imagem',
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
                          "Nome",
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
                                hintText: 'Coca-cola',
                                errorText: _controller.getNomeError,
                                contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                              ),
                            );
                          }),
                        ),
                        Text(
                          "Descrição",
                          style: Theme.of(context).primaryTextTheme.displayMedium,
                        ),
                        Container(
                          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                          margin: const EdgeInsets.only(top: 5, bottom: 15),
                          padding: const EdgeInsets.only(),
                          child: Observer(builder: (_) {
                            return TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: 4,
                              style: Theme.of(context).primaryTextTheme.bodyLarge,
                              initialValue: _controller.descricao,
                              onChanged: _controller.setDescricao,
                              decoration: InputDecoration(
                                fillColor: Modular.get<ThemeStore>().isDarkModeEnable
                                    ? Theme.of(context).inputDecorationTheme.fillColor
                                    : Theme.of(context).scaffoldBackgroundColor,
                                hintText: 'Coca-cola lata 350ml',
                                contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                errorText: _controller.getDescricaoError,
                              ),
                            );
                          }),
                        ),
                        Text(
                          "Preço",
                          style: Theme.of(context).primaryTextTheme.displayMedium,
                        ),
                        Container(
                          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                          margin: const EdgeInsets.only(top: 5, bottom: 15),
                          padding: const EdgeInsets.only(),
                          child: Observer(builder: (_) {
                            return TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                CentavosInputFormatter(moeda: true),
                              ],
                              style: Theme.of(context).primaryTextTheme.bodyLarge,
                              initialValue: UtilBrasilFields.obterReal(_controller.preco ?? 0),
                              onChanged: (value) => _controller.setPreco(UtilBrasilFields.converterMoedaParaDouble(value)),
                              decoration: InputDecoration(
                                fillColor: Modular.get<ThemeStore>().isDarkModeEnable
                                    ? Theme.of(context).inputDecorationTheme.fillColor
                                    : Theme.of(context).scaffoldBackgroundColor,
                                hintText: 'R\$ 3,79',
                                contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                errorText: _controller.getPrecoError,
                              ),
                            );
                          }),
                        ),
                        Text(
                          "Unidade de medida",
                          style: Theme.of(context).primaryTextTheme.displayMedium,
                        ),
                        Container(
                          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                          margin: const EdgeInsets.only(top: 5, bottom: 15),
                          padding: const EdgeInsets.only(),
                          child: Observer(builder: (_) {
                            return TextFormField(
                              style: Theme.of(context).primaryTextTheme.bodyLarge,
                              initialValue: _controller.unidadeMedida,
                              onChanged: _controller.setUnidadeMedida,
                              decoration: InputDecoration(
                                fillColor: Modular.get<ThemeStore>().isDarkModeEnable
                                    ? Theme.of(context).inputDecorationTheme.fillColor
                                    : Theme.of(context).scaffoldBackgroundColor,
                                hintText: 'un | kg',
                                contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                errorText: _controller.getUnidadeMedidaError,
                              ),
                            );
                          }),
                        ),
                        Text(
                          "Código de barras",
                          style: Theme.of(context).primaryTextTheme.displayMedium,
                        ),
                        Container(
                          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                          margin: const EdgeInsets.only(top: 5, bottom: 15),
                          padding: const EdgeInsets.only(),
                          child: Observer(builder: (_) {
                            debugPrint(_controller.codigoBarras);
                            return TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(13),
                                LengthLimitingTextInputFormatter(8),
                              ],
                              controller: _controller.codigoBarrasController,
                              keyboardType: TextInputType.number,
                              // initialValue: _controller.codigoBarras,
                              style: Theme.of(context).primaryTextTheme.bodyLarge,
                              onChanged: _controller.setCodigoBarras,
                              decoration: InputDecoration(
                                fillColor: Modular.get<ThemeStore>().isDarkModeEnable
                                    ? Theme.of(context).inputDecorationTheme.fillColor
                                    : Theme.of(context).scaffoldBackgroundColor,
                                hintText: '7898357417892',
                                contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                errorText: _controller.getCodigoBarrasError,
                                suffixIcon: !kIsWeb && (Platform.isAndroid || Platform.isIOS)
                                    ? IconButton(
                                        icon: Icon(
                                          MdiIcons.barcode,
                                          color: Theme.of(context).inputDecorationTheme.hintStyle!.color,
                                        ),
                                        onPressed: () async {
                                          var barcode = await Modular.to.pushNamed<String?>('/produtos/scanner');
                                          if (!isNullorEmpty(barcode)) {
                                            _controller.setCodigoBarras(barcode!);
                                          }
                                        },
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            );
                          }),
                        ),
                        Text(
                          "Estoque alvo",
                          style: Theme.of(context).primaryTextTheme.displayMedium,
                        ),
                        Container(
                          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                          margin: const EdgeInsets.only(top: 5, bottom: 15),
                          padding: const EdgeInsets.only(),
                          child: Observer(builder: (_) {
                            return TextFormField(
                              style: Theme.of(context).primaryTextTheme.bodyLarge,
                              initialValue: _controller.estoqueAlvo,
                              onChanged: _controller.setEstoqueAlvo,
                              decoration: InputDecoration(
                                fillColor: Modular.get<ThemeStore>().isDarkModeEnable
                                    ? Theme.of(context).inputDecorationTheme.fillColor
                                    : Theme.of(context).scaffoldBackgroundColor,
                                hintText: '5',
                                contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                errorText: _controller.getEstoqueAlvoError,
                              ),
                            );
                          }),
                        ),
                        Card(
                          child: Observer(
                            builder: (_) {
                              return SwitchListTile(
                                value: _controller.isAtivo,
                                onChanged: _controller.setIsAtivo,
                                title: Text(
                                  "Ativo",
                                  style: Theme.of(context).primaryTextTheme.bodyLarge,
                                ),
                              );
                            },
                          ),
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
      bottomNavigationBar: Observer(
        builder: (_) {
          return Row(
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
                        margin: const EdgeInsets.all(8.0),
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: Observer(builder: (_) {
                          return TextButton(
                            onPressed: () async {
                              if (!_controller.isSaving && _controller.isValid) {
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
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _controller.id = widget.id;

    super.initState();
  }
}
