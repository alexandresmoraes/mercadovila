import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:vilasesmo/app/utils/models/paged_result.dart';
import 'package:vilasesmo/app/utils/widgets/circular_progress.dart';
import 'package:vilasesmo/app/utils/widgets/refresh_widget.dart';

class InfiniteList<T> extends StatefulWidget {
  final Future<PagedResult<T>> Function(int nextIndex) request;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget Function(BuildContext context) emptyBuilder;
  final Widget Function(BuildContext context)? errorBuilder;
  final T Function(Map<String, dynamic>) cast;
  final Widget? noMoreItemsBuilder;
  final Widget? firstPageProgressIndicatorWidget;
  final PagingController<int, T>? pagingController;
  final Axis? scrollDirection;

  const InfiniteList({
    Key? key,
    required this.request,
    required this.itemBuilder,
    required this.cast,
    required this.emptyBuilder,
    this.firstPageProgressIndicatorWidget,
    this.noMoreItemsBuilder,
    this.pagingController,
    this.scrollDirection,
    this.errorBuilder,
  }) : super(key: key);

  @override
  InfiniteListState<T> createState() => InfiniteListState<T>();
}

class InfiniteListState<T> extends State<InfiniteList<T>> {
  PagingController<int, T>? _pagingController;

  @override
  void initState() {
    _pagingController = widget.pagingController ?? PagingController(firstPageKey: 1);

    _pagingController!.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchPage(pageKey) async {
    try {
      final pagedResult = await widget.request(pageKey);

      var newItems = pagedResult.data.map((item) => widget.cast(item)).toList();

      final isLastPage = pagedResult.total == pagedResult.lastRowOnPage;
      if (isLastPage) {
        _pagingController!.appendLastPage(newItems);
      } else {
        _pagingController!.appendPage(newItems, pageKey + 1);
      }
    } catch (error) {
      if (!mounted) return;
      _pagingController!.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        () => _pagingController!.refresh(),
      ),
      child: PagedListView.separated(
        scrollDirection: widget.scrollDirection ?? Axis.vertical,
        builderDelegate: PagedChildBuilderDelegate<T>(
          firstPageProgressIndicatorBuilder: (context) =>
              widget.firstPageProgressIndicatorWidget ?? const CircularProgress(),
          newPageProgressIndicatorBuilder: (_) => const CircularProgress(),
          itemBuilder: (context, item, index) => widget.itemBuilder(context, item, index),
          newPageErrorIndicatorBuilder: (context) {
            if (widget.errorBuilder != null) {
              return widget.errorBuilder!(context);
            } else {
              return RefreshWidget(
                onTap: () => _pagingController!.refresh(),
              );
            }
          },
          firstPageErrorIndicatorBuilder: (context) {
            if (widget.errorBuilder != null) {
              return widget.errorBuilder!(context);
            } else {
              return RefreshWidget(
                onTap: () => _pagingController!.refresh(),
              );
            }
          },
          noItemsFoundIndicatorBuilder: (context) => widget.emptyBuilder(context),
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
        pagingController: _pagingController!,
        separatorBuilder: (context, index) => const SizedBox.shrink(),
      ),
    );
  }
}
