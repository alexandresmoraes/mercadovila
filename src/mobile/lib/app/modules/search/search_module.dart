import 'package:flutter_modular/flutter_modular.dart';
import 'package:mercadovila/app/modules/search/search_filter_page.dart';
import 'package:mercadovila/app/modules/tab/search_page.dart';

class SearchModule extends Module {
  static const routeName = '/search/';

  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const SearchPage(), transition: TransitionType.rightToLeft, duration: const Duration(milliseconds: 500)),
    ChildRoute('/search-filter', child: (_, args) => const SearchFilterPage()),
  ];
}
