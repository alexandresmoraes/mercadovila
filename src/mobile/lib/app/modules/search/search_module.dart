import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/modules/search/search_filter_page.dart';

class SearchModule extends Module {
  static const routeName = '/search/';

  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/search-filter', child: (_, args) => const SearchFilterPage()),
  ];
}
