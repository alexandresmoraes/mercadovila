import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:vilasesmo/app/utils/models/notificacoes/notificacao_model.dart';
import 'package:vilasesmo/app/utils/models/result_fail_model.dart';
import 'package:vilasesmo/app/utils/repositories/interfaces/i_notificacoes_repository.dart';
import 'package:vilasesmo/app/utils/utils.dart';
import 'package:vilasesmo/app/utils/widgets/global_snackbar.dart';

part 'notificacoes_edit_controller.g.dart';

class NotificacoesEditController = NotificacoesEditControllerBase with _$NotificacoesEditController;

abstract class NotificacoesEditControllerBase with Store {
  String? id;

  @observable
  String? imagePath;
  @action
  void setImagePath(String v) {
    imagePath = v;
  }

  @observable
  String? imageUrl;

  @observable
  String? imageMimeType;

  @observable
  String? imageFilenameWeb;

  @observable
  String? titulo;
  @observable
  String? _tituloApiError;
  @computed
  String? get getTituloError => !isNullorEmpty(_tituloApiError)
      ? _tituloApiError
      : isNullorEmpty(titulo)
          ? 'Título da notificação não pode ser vazio.'
          : null;
  @action
  void setTitulo(String? v) {
    titulo = v;
    _tituloApiError = null;
  }

  @observable
  String? mensagem;
  @observable
  String? _mensagemApiError;
  @computed
  String? get getMensagemError => !isNullorEmpty(_mensagemApiError)
      ? _mensagemApiError
      : isNullorEmpty(mensagem)
          ? 'Mensagem da notificação não pode ser vazio.'
          : null;
  @action
  void setMensagem(String? v) {
    mensagem = v;
    _mensagemApiError = null;
  }

  @observable
  bool isSaving = false;
  @observable
  bool isDeleting = false;
  @observable
  bool isLoading = false;

  @computed
  bool get isValid {
    return isNullorEmpty(getTituloError) && isNullorEmpty(getMensagemError);
  }

  NotificacaoModel? notificacaoModel;

  Future<NotificacaoModel?> load() async {
    if (notificacaoModel != null) return notificacaoModel!;
    isLoading = true;

    if (!isNullorEmpty(id)) {
      var notificacoesRepository = Modular.get<INotificacoesRepository>();
      notificacaoModel = await notificacoesRepository.getNotificacao(id!);
    } else {
      notificacaoModel = NotificacaoModel(
        titulo: "",
        mensagem: "",
      );
    }

    titulo = notificacaoModel!.titulo;
    mensagem = notificacaoModel!.mensagem;
    imageUrl = notificacaoModel!.imageUrl;

    isLoading = false;
    return notificacaoModel!;
  }

  Future saveNotificacao() async {
    var notificacaoModel = NotificacaoModel(
      titulo: titulo!,
      mensagem: mensagem!,
      imageUrl: imageUrl,
    );

    var notificacoesRepository = Modular.get<INotificacoesRepository>();
    if (isNullorEmpty(id)) {
      var result = await notificacoesRepository.createNotificacao(notificacaoModel);

      await result.fold((fail) {
        apiErrors(fail);
      }, (response) async {
        GlobalSnackbar.success('Criado com sucesso');
        Modular.to.pop(true);
      });
    } else {
      var result = await notificacoesRepository.editNotificacao(id!, notificacaoModel);

      await result.fold((fail) {
        apiErrors(fail);
      }, (accountResponse) async {
        GlobalSnackbar.success('Editado com sucesso');
        Modular.to.pop(true);
      });
    }
  }

  Future save() async {
    try {
      isSaving = true;
      var notificacoesRepository = Modular.get<INotificacoesRepository>();

      if (!isNullorEmpty(imagePath)) {
        var result = await notificacoesRepository.uploadImageNotificacao(imagePath!, imageMimeType, imageFilenameWeb);
        await result.fold((fail) {
          if (fail.statusCode == 413) {
            GlobalSnackbar.error('Tamanho máximo da foto é 8MB');
            isSaving = false;
          }
        }, (response) async {
          imageUrl = response.filename;

          await saveNotificacao();
        });
      } else {
        await saveNotificacao();
      }
    } finally {
      isSaving = false;
    }
  }

  Future delete() async {
    try {
      isDeleting = true;

      var notificacoesRepository = Modular.get<INotificacoesRepository>();
      var result = await notificacoesRepository.deleteNotificacao(id!);

      await result.fold((fail) {
        apiErrors(fail);
      }, (accountResponse) async {
        GlobalSnackbar.success('Excluído com sucesso');
        Modular.to.pop(true);
      });
    } finally {
      isDeleting = false;
    }
  }

  void apiErrors(ResultFailModel resultFail) {
    isSaving = false;

    if (resultFail.statusCode == 400) {
      _tituloApiError = resultFail.getErrorByProperty('Titulo');
      _mensagemApiError = resultFail.getErrorByProperty('Mensagem');

      var message = resultFail.getErrorNotProperty();
      if (message.isNotEmpty) GlobalSnackbar.error(message);
    }
  }
}
