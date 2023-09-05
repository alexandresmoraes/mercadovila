import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
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
  late ProdutosEditController _controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Modular.get<ThemeStore>().isDarkModeEnable
            ? Theme.of(context).scaffoldBackgroundColor
            : Theme.of(context).inputDecorationTheme.fillColor,
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
                              title: const Icon(Icons.camera_alt_rounded),
                              actions: <Widget>[
                                Container(
                                  color: Colors.white,
                                  child: CupertinoActionSheetAction(
                                    isDefaultAction: true,
                                    onPressed: () {
                                      //_getImagePicker(ImageSource.camera);
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
                                    //_getImagePicker(ImageSource.gallery);
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
                              style: Theme.of(context).primaryTextTheme.bodyLarge,
                              initialValue: _controller.preco,
                              onChanged: _controller.setPreco,
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
                            return TextFormField(
                              style: Theme.of(context).primaryTextTheme.bodyLarge,
                              initialValue: _controller.codigoBarras,
                              onChanged: _controller.setCodigoBarras,
                              decoration: InputDecoration(
                                fillColor: Modular.get<ThemeStore>().isDarkModeEnable
                                    ? Theme.of(context).inputDecorationTheme.fillColor
                                    : Theme.of(context).scaffoldBackgroundColor,
                                hintText: '7898357417892',
                                contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                errorText: _controller.getCodigoBarrasError,
                                suffixIcon: IconButton(
                                  icon: const Icon(
                                    MdiIcons.barcode,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    //
                                  },
                                ),
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
                        Text(
                          "Estoque",
                          style: Theme.of(context).primaryTextTheme.displayMedium,
                        ),
                        Container(
                          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                          margin: const EdgeInsets.only(top: 5, bottom: 15),
                          padding: const EdgeInsets.only(),
                          child: Observer(builder: (_) {
                            return TextFormField(
                              style: Theme.of(context).primaryTextTheme.bodyLarge,
                              initialValue: _controller.estoque,
                              onChanged: _controller.setEstoque,
                              decoration: InputDecoration(
                                fillColor: Modular.get<ThemeStore>().isDarkModeEnable
                                    ? Theme.of(context).inputDecorationTheme.fillColor
                                    : Theme.of(context).scaffoldBackgroundColor,
                                hintText: '3',
                                contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                errorText: _controller.getEstoqueError,
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
          ),
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
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _controller = Modular.get<ProdutosEditController>();
    _controller.id = widget.id;

    super.initState();
  }
}
