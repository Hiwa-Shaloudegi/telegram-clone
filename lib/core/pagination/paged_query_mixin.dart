
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telegram_clone/core/pagination/paged_query_state.dart';
import 'package:telegram_clone/core/pagination/paged_response.dart';

/// Mixin for implementing Page-Based pagination with selective navigation
///
/// Can be combined with [CachedQueryMixin]
///
/// **Usage:**
/// ```dart
/// @riverpod
/// class UserSearch extends _$UserSearch with PagedQueryMixin<UserModel> {
///   @override
///   Future<PagedResponse<UserModel>> fetchPage(int page) {
///     return api.searchUsers(page: page);
///   }
///
///   @override
///   Future<PagedQueryState<UserModel>> build() => fetchInitialPage();
/// }
/// ```
mixin PagedQueryMixin<T> on AsyncNotifier<PagedQueryState<T>> {
  /// Number of items per page
  int get pageSize => 20;

  /// Implement specific fetch logic for retrieving a page
  Future<PagedResponse<T>> fetchPage(int page);

  /// Load initial (first) page
  /// If using [CachedQueryMixin], call this inside `fetchFromNetwork()` instead
  Future<PagedQueryState<T>> fetchInitialPage() async {
    final response = await fetchPage(1);
    
    return PagedQueryState(
      items: response.items,
      currentPage: response.currentPage,
      totalPages: response.totalPages,
      totalItems: response.totalItems,
      pageStatus: null, // idle/success
    );
  }

  /// Navigate to specific page
  Future<void> goToPage(int page) async {
    if (page < 1) return;

    final current = state.asData?.value;
    if (current != null && current.totalPages > 0 && page > current.totalPages) {
      return;
    }

    // Set loading state while preserving current items
    // This allows UI to show "loading" overlay instead of clearing screen
    state = AsyncData((current ?? PagedQueryState<T>()).copyWith(
      pageStatus: const AsyncLoading(),
    ));

    try {
      final response = await fetchPage(page);
      
      state = AsyncData(PagedQueryState<T>(
        items: response.items,
        currentPage: response.currentPage,
        totalPages: response.totalPages,
        totalItems: response.totalItems,
        pageStatus: null, // success/idle
      ));
    } catch (e, st) {
      // Set error state
      state = AsyncData((current ?? PagedQueryState<T>()).copyWith(
        pageStatus: AsyncError(e, st),
      ));
    }
  }

  /// Go to next page if available
  Future<void> nextPage() {
    final current = state.asData?.value;
    if (current != null && current.hasNextPage) {
      return goToPage(current.currentPage + 1);
    }
    return Future.value();
  }

  /// Go to previous page if available
  Future<void> previousPage() {
    final current = state.asData?.value;
    if (current != null && current.hasPreviousPage) {
      return goToPage(current.currentPage - 1);
    }
    return Future.value();
  }

  /// Retry current page on error
  Future<void> retry() {
    final current = state.asData?.value;
    return goToPage(current?.currentPage ?? 1);
  }

  /// Refresh (go back to first page)
  Future<void> refresh() => goToPage(1);
}
