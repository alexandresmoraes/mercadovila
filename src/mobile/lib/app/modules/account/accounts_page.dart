import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/stores/theme_store.dart';
import 'package:vilasesmo/app/utils/dto/account/account_dto.dart';
import 'package:vilasesmo/app/utils/repositories/interfaces/i_account_repository.dart';
import 'package:vilasesmo/app/utils/utils.dart';
import 'package:vilasesmo/app/utils/widgets/circular_progress.dart';
import 'package:vilasesmo/app/utils/widgets/infinite_list.dart';

class AccountsPage extends StatefulWidget {
  final String title;
  const AccountsPage({Key? key, this.title = 'Contas de usuários'}) : super(key: key);
  @override
  AccountsPageState createState() => AccountsPageState();
}

class AccountsPageState extends State<AccountsPage> {
  String? usernameFilter;
  bool isSearchVisibled = false;
  final searchController = TextEditingController();
  final searchNode = FocusNode();
  Timer? _debounce;

  PagingController<int, AccountDto> pagingController = PagingController(firstPageKey: 1);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              "Contas de usuários",
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  setState(() {
                    isSearchVisibled = !isSearchVisibled;
                    if (!isSearchVisibled && !isNullorEmpty(usernameFilter)) {
                      usernameFilter = "";
                      searchController.clear();
                      pagingController.refresh();
                    }
                    if (isSearchVisibled) {
                      searchNode.requestFocus();
                    } else {
                      searchNode.unfocus();
                    }
                  });
                },
                icon: const Icon(MdiIcons.magnify),
              ),
              IconButton(
                onPressed: () async {
                  var refresh = await Modular.to.pushNamed<bool>('/account/new');
                  if (refresh ?? false) pagingController.refresh();
                },
                icon: const Icon(MdiIcons.plus),
              ),
            ],
          ),
          body: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: isSearchVisibled ? 70 : 0,
                child: Container(
                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.only(),
                  child: TextFormField(
                    focusNode: searchNode,
                    controller: searchController,
                    onChanged: ((value) {
                      if (_debounce?.isActive ?? false) _debounce!.cancel();
                      _debounce = Timer(const Duration(milliseconds: 500), () {
                        setState(() {
                          usernameFilter = value;
                          pagingController.refresh();
                        });
                      });
                    }),
                    style: Theme.of(context).primaryTextTheme.bodyLarge,
                    decoration: InputDecoration(
                      hintText: 'Buscar por nome de usuários ou email',
                      prefixIcon: Icon(
                        MdiIcons.magnify,
                        size: isSearchVisibled ? 20 : 0,
                      ),
                      contentPadding: const EdgeInsets.only(top: 10),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _allUsers(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _allUsers() {
    final ThemeStore themeStore = Modular.get<ThemeStore>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InfiniteList<AccountDto>(
        pagingController: pagingController,
        request: (page) async {
          return await Modular.get<IAccountRepository>().getAccounts(page, usernameFilter);
        },
        cast: AccountDto.fromJson,
        noMoreItemsBuilder: const SizedBox.shrink(),
        emptyBuilder: Center(
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
        ),
        itemBuilder: (context, item, index) {
          return InkWell(
            onTap: () async {
              var refresh = await Modular.to.pushNamed<bool>('/account/edit/${item.id}');
              if (refresh ?? false) pagingController.refresh();
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          color: themeStore.isDarkModeEnable ? const Color(0xFF373C58) : const Color(0xFFF2F5F8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: Text(
                          item.id,
                          style: Theme.of(context).primaryTextTheme.displayMedium,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      Icon(
                        !item.isAtivo ? MdiIcons.closeOctagon : MdiIcons.checkDecagram,
                        size: 20,
                        color: !item.isAtivo ? Colors.red : Colors.greenAccent,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          item.isAtivo ? "Ativo" : "Inativo",
                          style: Theme.of(context).primaryTextTheme.displayMedium,
                        ),
                      )
                    ],
                  ),
                ),
                ListTile(
                  visualDensity: const VisualDensity(vertical: -3, horizontal: -4),
                  contentPadding: const EdgeInsets.all(0),
                  minLeadingWidth: 0,
                  leading: isNullorEmpty(item.fotoUrl)
                      ? const CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 21,
                            backgroundImage: AssetImage('assets/person.png'),
                          ),
                        )
                      : CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.white,
                          child: CachedNetworkImage(
                            placeholder: (context, url) => CircularProgress(
                              color: Theme.of(context).primaryColorLight,
                            ),
                            errorWidget: (context, url, error) => const CircleAvatar(
                              radius: 21,
                              backgroundImage: AssetImage('assets/person.png'),
                            ),
                            imageUrl: '${Modular.get<BaseOptions>().baseUrl}/api/account/photo/${item.fotoUrl!}',
                            imageBuilder: (context, imageProvider) {
                              return CircleAvatar(
                                radius: 21,
                                backgroundImage: imageProvider,
                              );
                            },
                          ),
                        ),
                  title: Text(
                    item.username,
                    style: Theme.of(context).primaryTextTheme.bodyLarge,
                  ),
                  subtitle: Text(
                    item.email,
                    style: Theme.of(context).primaryTextTheme.displayMedium,
                  ),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "R\$ 15,98",
                        style: Theme.of(context).primaryTextTheme.bodyLarge!.copyWith(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: themeStore.isDarkModeEnable ? Theme.of(context).dividerTheme.color!.withOpacity(0.05) : Theme.of(context).dividerTheme.color,
                ),
              ],
            ),
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
    super.initState();
  }
}
