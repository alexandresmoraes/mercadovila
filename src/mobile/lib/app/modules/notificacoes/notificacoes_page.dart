import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/stores/theme_store.dart';
import 'package:vilasesmo/app/utils/dto/notificacoes/notificacao_dto.dart';
import 'package:vilasesmo/app/utils/repositories/interfaces/i_notificacoes_repository.dart';
import 'package:vilasesmo/app/utils/utils.dart';
import 'package:vilasesmo/app/utils/widgets/circular_progress.dart';
import 'package:vilasesmo/app/utils/widgets/infinite_list.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificacoesPage extends StatefulWidget {
  final String title;
  const NotificacoesPage({Key? key, this.title = 'Notificações'}) : super(key: key);
  @override
  NotificacoesPageState createState() => NotificacoesPageState();
}

class NotificacoesPageState extends State<NotificacoesPage> {
  NotificacoesPageState() : super();

  PagingController<int, NotificacaoDto> pagingController = PagingController(firstPageKey: 1);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Notificações"),
          actions: [
            IconButton(
              onPressed: () async {
                var refresh = await Modular.to.pushNamed<bool>('/notificacoes/new');
                if (refresh ?? false) pagingController.refresh();
              },
              icon: const Icon(MdiIcons.plus),
            ),
          ],
        ),
        body: _allNotificacoes(),
      ),
    );
  }

  Widget _allNotificacoes() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InfiniteList<NotificacaoDto>(
        pagingController: pagingController,
        request: (page) async {
          return await Modular.get<INotificacoesRepository>().getNotificacoes(page);
        },
        cast: NotificacaoDto.fromJson,
        noMoreItemsBuilder: const SizedBox.shrink(),
        emptyBuilder: (_) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/empty_list.png',
                  width: 300,
                  height: 300,
                ),
              ],
            ),
          );
        },
        itemBuilder: (context, item, index) {
          return InkWell(
            onTap: () async {
              var refresh = await Modular.to.pushNamed<bool>('/notificacoes/edit/${item.id}');
              if (refresh ?? false) pagingController.refresh();
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  leading: isNullorEmpty(item.imageUrl)
                      ? Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            image: DecorationImage(
                              image: AssetImage("assets/g_logo.png"),
                            ),
                          ),
                        )
                      : CachedNetworkImage(
                          placeholder: (context, url) => SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgress(
                              color: Theme.of(context).primaryColorLight,
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 50,
                            width: 50,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                image: AssetImage("assets/g_logo.png"),
                              ),
                            ),
                          ),
                          imageUrl: '${Modular.get<BaseOptions>().baseUrl}/api/notificacoes/image/${item.imageUrl!}',
                          imageBuilder: (context, imageProvider) {
                            return Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                image: DecorationImage(
                                  image: imageProvider,
                                ),
                              ),
                            );
                          },
                        ),
                  title: Text(
                    item.titulo,
                    style: Theme.of(context).primaryTextTheme.bodyLarge,
                  ),
                  subtitle: RichText(
                    text: TextSpan(
                      text: item.mensagem,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .labelSmall!
                          .copyWith(color: Theme.of(context).primaryTextTheme.labelSmall!.color!.withOpacity(0.6), letterSpacing: 0.1),
                      children: [
                        TextSpan(
                          text: '\n${timeago.format(locale: 'pt_BR', item.dataCriacao.toLocal())}',
                          style: Theme.of(context)
                              .primaryTextTheme
                              .labelLarge!
                              .copyWith(color: Theme.of(context).primaryTextTheme.labelLarge!.color!.withOpacity(0.4)),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Modular.get<ThemeStore>().isDarkModeEnable ? Theme.of(context).dividerTheme.color : const Color(0xFFDFE8EF),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}