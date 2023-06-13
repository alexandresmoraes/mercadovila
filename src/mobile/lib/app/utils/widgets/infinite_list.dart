import 'package:curved_progress_bar/curved_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:vilasesmo/app/utils/models/paged_result.dart';

class InfiniteList<T> extends StatefulWidget {
  final Future<PagedResult<T>> Function(int nextIndex) request;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget emptyBuilder;
  final T Function(Map<String, dynamic>) cast;
  final Widget? noMoreItemsBuilder;
  final Widget? firstPageProgressIndicatorWidget;

  const InfiniteList({
    Key? key,
    required this.request,
    required this.itemBuilder,
    required this.cast,
    required this.emptyBuilder,
    this.firstPageProgressIndicatorWidget,
    this.noMoreItemsBuilder,
  }) : super(key: key);

  @override
  InfiniteListState<T> createState() => InfiniteListState<T>();
}

class InfiniteListState<T> extends State<InfiniteList<T>> {
  final PagingController<int, T> _pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(pageKey) async {
    try {
      final pagedResult = await widget.request(pageKey);

      var newItems = pagedResult.data.map((item) => widget.cast(item)).toList();

      final isLastPage = pagedResult.total == pagedResult.lastRowOnPage;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        _pagingController.appendPage(newItems, pageKey + 1);
      }
    } catch (error) {
      if (!mounted) return;
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        () => _pagingController.refresh(),
      ),
      child: PagedListView.separated(
        builderDelegate: PagedChildBuilderDelegate<T>(
          firstPageProgressIndicatorBuilder: (context) =>
              widget.firstPageProgressIndicatorWidget ??
              Center(
                child: SizedBox(
                  height: 50,
                  child: Center(
                    child: CurvedCircularProgressIndicator(
                      color: Theme.of(context).primaryTextTheme.displaySmall!.color,
                    ),
                  ),
                ),
              ),
          newPageProgressIndicatorBuilder: (_) => Center(
            child: SizedBox(
              height: 80,
              child: Center(
                child: CurvedCircularProgressIndicator(
                  color: Theme.of(context).primaryTextTheme.displaySmall!.color,
                ),
              ),
            ),
          ),
          itemBuilder: (context, item, index) => widget.itemBuilder(context, item, index),
          newPageErrorIndicatorBuilder: (_) => Center(
            child: GestureDetector(
              onTap: () => _pagingController.refresh(),
              child: const Icon(Icons.refresh, size: 50),
            ),
          ),
          firstPageErrorIndicatorBuilder: (_) => Center(
            child: GestureDetector(
              onTap: () => _pagingController.refresh(),
              child: const Icon(Icons.refresh, size: 50),
            ),
          ),
          noItemsFoundIndicatorBuilder: (context) => widget.emptyBuilder,
          noMoreItemsIndicatorBuilder: (context) =>
              widget.noMoreItemsBuilder ??
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Center(
                  child: Text(
                    'Fim da lista.',
                    style: Theme.of(context).primaryTextTheme.displayMedium,
                  ),
                ),
              ),
        ),
        pagingController: _pagingController,
        separatorBuilder: (context, index) => const SizedBox.shrink(),
      ),
    );
  }
}
