class PagedResult<T> {
  PagedResult({
    required this.currentPage,
    required this.total,
    required this.start,
    required this.limit,
    required this.firstRowOnPage,
    required this.lastRowOnPage,
    required this.data,
  });
  late final int currentPage;
  late final int total;
  late final int start;
  late final int limit;
  late final int firstRowOnPage;
  late final int lastRowOnPage;
  late final List data;

  PagedResult.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    total = json['total'];
    start = json['start'];
    limit = json['limit'];
    firstRowOnPage = json['firstRowOnPage'];
    lastRowOnPage = json['lastRowOnPage'];
    data = List.from(json['data']);
  }
}
