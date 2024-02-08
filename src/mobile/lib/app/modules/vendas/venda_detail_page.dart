import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/modules/vendas/venda_detail_controller.dart';
import 'package:vilasesmo/app/stores/account_store.dart';
import 'package:vilasesmo/app/utils/dto/vendas/venda_dto.dart';
import 'package:vilasesmo/app/utils/widgets/card_venda_item.dart';
import 'package:vilasesmo/app/utils/widgets/circular_progress.dart';
import 'package:vilasesmo/app/utils/widgets/future_triple.dart';
import 'package:vilasesmo/app/utils/widgets/refresh_widget.dart';
import 'package:vilasesmo/app/utils/widgets/venda_status.dart';

class VendaDetailPage extends StatefulWidget {
  final String title;
  final String id;
  const VendaDetailPage({Key? key, this.title = 'Venda', required this.id}) : super(key: key);
  @override
  VendaDetailPageState createState() => VendaDetailPageState();
}

class VendaDetailPageState extends State<VendaDetailPage> {
  VendaDetailPageState() : super();

  final VendaDetailController _controller = Modular.get<VendaDetailController>();
  final bool isAdmin = Modular.get<AccountStore>().account!.isAdmin;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            onTap: () {
              Modular.to.pop();
            },
            child: const Align(
              alignment: Alignment.center,
              child: Icon(MdiIcons.arrowLeft),
            ),
          ),
          title: isAdmin ? Text("#${widget.id} - Venda") : Text("#${widget.id} - Compra"),
        ),
        body: FutureTriple(
          future: _controller.load(),
          error: RefreshWidget(
            onTap: () => setState(() {}),
          ),
          loading: const CircularProgress(),
          data: (context, snapshot) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ..._controller.vendaDetailDto!.itens.map((item) => CardVendaItem(item: item)),
                    ListTile(
                      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                      contentPadding: const EdgeInsets.all(0),
                      title: Text(
                        "Preço",
                        style: Theme.of(context).primaryTextTheme.headlineSmall,
                      ),
                    ),
                    ListTile(
                      minVerticalPadding: 0,
                      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                      minLeadingWidth: 30,
                      contentPadding: const EdgeInsets.all(0),
                      leading: Text(
                        "Total",
                        style: Theme.of(context).primaryTextTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w700),
                      ),
                      trailing: Text(
                        "R\$ ${_controller.vendaDetailDto!.total}",
                        style: Theme.of(context).primaryTextTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Status",
                          style: Theme.of(context).primaryTextTheme.labelSmall,
                        ),
                        const Expanded(child: SizedBox()),
                        VendasStatus(
                          status: _controller.vendaDetailDto!.status,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: Observer(builder: (_) {
          return isAdmin && _controller.vendaDetailDto != null && _controller.vendaDetailDto!.status == EnumVendaStatus.pendentePagamento.index
              ? Row(
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
                            onPressed: () async {
                              await _controller.cancelar();
                            },
                            child: !_controller.isLoadingCancelar
                                ? const Text(
                                    'Cancelar',
                                  )
                                : const CircularProgress(
                                    width: 21,
                                    height: 21,
                                  ),
                          );
                        }),
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink();
        }),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _controller.vendaId = int.parse(widget.id);

    super.initState();
  }
}
