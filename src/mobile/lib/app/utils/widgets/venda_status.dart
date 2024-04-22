import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mercadovila/app/utils/dto/vendas/venda_dto.dart';

class VendasStatus extends StatelessWidget {
  final int status;

  const VendasStatus({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          status == EnumVendaStatus.cancelada.index ? MdiIcons.closeOctagon : MdiIcons.checkDecagram,
          size: 20,
          color: status == EnumVendaStatus.cancelada.index
              ? Colors.red
              : status == EnumVendaStatus.pago.index
                  ? Colors.greenAccent
                  : status == EnumVendaStatus.pendentePagamento.index
                      ? Colors.blue
                      : Theme.of(context).primaryColorLight,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            status == EnumVendaStatus.cancelada.index
                ? "Cancelada"
                : status == EnumVendaStatus.pago.index
                    ? "Pago"
                    : status == EnumVendaStatus.pendentePagamento.index
                        ? "Pendente de pagamento"
                        : "",
            style: Theme.of(context).primaryTextTheme.displayMedium,
          ),
        )
      ],
    );
  }
}
