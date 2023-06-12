import 'package:curved_progress_bar/curved_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:vilasesmo/app/utils/models/paged_result.dart';

typedef RequestFn<T> = Future<T> Function(int nextIndex);
typedef ItemBuilder<T> = Widget Function(BuildContext context, T item, int index);
typedef EmptyBuilder<T> = Widget Function(BuildContext context);

class InfiniteList<T> extends StatefulWidget {
  final RequestFn<PagedResult<T>> onRequest;
  final ItemBuilder<T> itemBuilder;
  final EmptyBuilder emptyBuilder;
  final T Function(Map<String, dynamic>) onCast;
  final Widget Function(BuildContext)? noMoreItemsBuilder;
  final Widget Function(BuildContext)? firstPageProgressIndicatorBuilder;

  const InfiniteList({
    Key? key,
    required this.onRequest,
    required this.itemBuilder,
    required this.onCast,
    required this.emptyBuilder,
    this.firstPageProgressIndicatorBuilder,
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
      final pagedResult = await widget.onRequest(pageKey);

      var newItems = pagedResult.data.map((item) => widget.onCast(item)).toList();

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
          firstPageProgressIndicatorBuilder: (context) => widget.firstPageProgressIndicatorBuilder != null
              ? widget.firstPageProgressIndicatorBuilder!(context)
              : Center(
                  child: SizedBox(
                    height: 80,
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
          noItemsFoundIndicatorBuilder: (context) => widget.emptyBuilder(context),
          noMoreItemsIndicatorBuilder: (context) => widget.noMoreItemsBuilder != null
              ? widget.noMoreItemsBuilder!(context)
              : const Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: Center(
                    child: Text(
                      'Fim da lista.',
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
