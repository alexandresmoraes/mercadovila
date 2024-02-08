import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:vilasesmo/app/utils/dto/vendas/venda_dto.dart';
import 'package:vilasesmo/app/utils/repositories/interfaces/i_vendas_repository.dart';
import 'package:vilasesmo/app/utils/widgets/global_snackbar.dart';

part 'venda_detail_controller.g.dart';

class VendaDetailController = VendaDetailControllerBase with _$VendaDetailController;

abstract class VendaDetailControllerBase with Store {
  IVendasRepository vendasRepository = Modular.get<IVendasRepository>();

  int? vendaId;

  @observable
  VendaDetalheDto? vendaDetailDto;

  Future<VendaDetalheDto?> load() async {
    if (vendaDetailDto != null) return vendaDetailDto!;

    vendaDetailDto = await vendasRepository.getVenda(vendaId!);

    return vendaDetailDto!;
  }

  @observable
  bool isLoadingCancelar = false;

  Future cancelar() async {
    try {
      isLoadingCancelar = true;

      var result = await vendasRepository.cancelarVenda(vendaId!);

      result.fold((fail) {
        if (fail.statusCode == 400) {
          var message = fail.getErrorNotProperty();
          if (message.isNotEmpty) GlobalSnackbar.error(message);
        }
      }, (response) {
        GlobalSnackbar.success('Venda cancelada com sucesso!');
        Modular.to.pop(true);
      });
    } finally {
      isLoadingCancelar = false;
    }
  }
}
