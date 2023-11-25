import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:vilasesmo/app/utils/dto/vendas/venda_dto.dart';
import 'package:vilasesmo/app/utils/repositories/interfaces/i_vendas_repository.dart';

part 'venda_detail_controller.g.dart';

class VendaDetailController = VendaDetailControllerBase with _$VendaDetailController;

abstract class VendaDetailControllerBase with Store {
  int? id;

  @observable
  bool isLoading = false;

  VendaDetalheDto? vendaDetailDto;

  Future<VendaDetalheDto?> load() async {
    if (vendaDetailDto != null) return vendaDetailDto!;
    isLoading = true;

    var vendasRepository = Modular.get<IVendasRepository>();
    vendaDetailDto = await vendasRepository.getVenda(id!);

    isLoading = false;
    return vendaDetailDto!;
  }
}
