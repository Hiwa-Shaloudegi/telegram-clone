import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for Infinite Scroll pagination
class InfiniteQueryState<T> {
  /// All loaded items
  final List<T> items;

  /// Status of loadMore operation:
  /// - null: idle, ready to load more
  /// - AsyncLoading: currently loading next page
  /// - AsyncError: failed to load next page, can retry
  final AsyncValue<void>? loadMoreStatus;

  /// True when no more items are available to load (show end indicator)
  final bool hasReachedEnd;

  /// Current offset for fetching the next page
  final int nextOffset;

  const InfiniteQueryState({
    this.items = const [],
    this.loadMoreStatus,
    this.hasReachedEnd = false,
    this.nextOffset = 0,
  });

  /// Create state from JSON (for caching)
  factory InfiniteQueryState.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return InfiniteQueryState(
      items: (json['items'] as List)
          .map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList(),
      nextOffset: json['nextOffset'] as int? ?? 0,
      hasReachedEnd: json['hasReachedEnd'] as bool? ?? false,
      loadMoreStatus: null, // Always reset load status on restore
    );
  }

  /// Convert state to JSON (for caching)
  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'items': items.map(toJsonT).toList(),
      'nextOffset': nextOffset,
      'hasReachedEnd': hasReachedEnd,
    };
  }

  InfiniteQueryState<T> copyWith({
    List<T>? items,
    AsyncValue<void>? loadMoreStatus,
    bool? hasReachedEnd,
    int? nextOffset,
  }) {
    return InfiniteQueryState<T>(
      items: items ?? this.items,
      loadMoreStatus: loadMoreStatus ?? this.loadMoreStatus,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      nextOffset: nextOffset ?? this.nextOffset,
    );
  }

  /// Convenience getters for UI
  bool get isLoadingMore => loadMoreStatus is AsyncLoading;
  bool get hasLoadMoreError => loadMoreStatus is AsyncError;
  Object? get loadMoreError => (loadMoreStatus as AsyncError?)?.error;
  bool get canLoadMore => loadMoreStatus == null && !hasReachedEnd;
  bool get isEmpty => items.isEmpty;
  int get itemCount => items.length;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InfiniteQueryState<T> &&
          runtimeType == other.runtimeType &&
          listEquals(items, other.items) &&
          loadMoreStatus == other.loadMoreStatus &&
          hasReachedEnd == other.hasReachedEnd &&
          nextOffset == other.nextOffset;

  @override
  int get hashCode =>
      Object.hashAll([items]) ^
      loadMoreStatus.hashCode ^
      hasReachedEnd.hashCode ^
      nextOffset.hashCode;
}
