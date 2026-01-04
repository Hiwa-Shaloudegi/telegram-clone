
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telegram_clone/core/pagination/infinite_query_state.dart';

/// Mixin for implementing Infinite Scroll pagination
///
/// Can be combined with [CachedQueryMixin]
///
/// **Usage:**
/// ```dart
/// @riverpod
/// class ChatMessages extends _$ChatMessages with InfiniteQueryMixin<MessageModel> {
///   @override
///   Future<List<MessageModel>> fetchPage({required int offset, required int limit}) {
///      return api.getMessages(offset: offset, limit: limit);
///   }
///
///   @override
///   Future<InfiniteQueryState<MessageModel>> build() => fetchInitialPage();
/// }
/// ```
mixin InfiniteQueryMixin<T> on AsyncNotifier<InfiniteQueryState<T>> {
  /// Number of items to fetch per page
  int get pageSize => 20;

  /// Implement specific fetch logic for retrieving items
  Future<List<T>> fetchPage({required int offset, required int limit});

  /// Call this in [build()] to load the first page
  /// If using [CachedQueryMixin], call this inside `fetchFromNetwork()` instead
  Future<InfiniteQueryState<T>> fetchInitialPage() async {
    final items = await fetchPage(offset: 0, limit: pageSize);
    
    return InfiniteQueryState<T>(
      items: items,
      nextOffset: items.length,
      hasReachedEnd: items.length < pageSize,
      loadMoreStatus: null, // idle
    );
  }

  /// Load next page
  /// Call this from UI when user scrolls near bottom
  Future<void> loadMore() async {
    final current = state.asData?.value;
    if (current == null || !current.canLoadMore) return;

    // Set loading state (while keeping existing items visible)
    state = AsyncData(current.copyWith(
      loadMoreStatus: const AsyncLoading(),
    ));

    try {
      final newItems = await fetchPage(
        offset: current.nextOffset,
        limit: pageSize,
      );

      // Append new items
      state = AsyncData(current.copyWith(
        items: [...current.items, ...newItems],
        nextOffset: current.nextOffset + newItems.length,
        hasReachedEnd: newItems.length < pageSize,
        loadMoreStatus: null, // back to idle/success
      ));
    } catch (e, st) {
      // Set error state
      state = AsyncData(current.copyWith(
        loadMoreStatus: AsyncError(e, st),
      ));
    }
  }

  /// Retry the last failed [loadMore] attempt
  Future<void> retryLoadMore() => loadMore();

  /// Refresh list from beginning (pull-to-refresh)
  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      state = AsyncData(await fetchInitialPage());
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
