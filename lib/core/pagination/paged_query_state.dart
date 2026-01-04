import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for Page-Based pagination
class PagedQueryState<T> {
  /// Items for current page
  final List<T> items;

  /// Current page number (1-indexed)
  final int currentPage;

  /// Total number of pages available
  final int totalPages;

  /// Total item count across all pages
  final int totalItems;

  /// Status of page navigation:
  /// - null: idle, page loaded successfully
  /// - AsyncLoading: loading a new page
  /// - AsyncError: failed to load page, can retry
  final AsyncValue<void>? pageStatus;

  const PagedQueryState({
    this.items = const [],
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.pageStatus,
  });

  /// Create state from JSON (for caching)
  factory PagedQueryState.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PagedQueryState(
      items: (json['items'] as List)
          .map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList(),
      currentPage: json['currentPage'] as int? ?? 1,
      totalPages: json['totalPages'] as int? ?? 1,
      totalItems: json['totalItems'] as int? ?? 0,
      pageStatus: null, // Reset status on restore
    );
  }

  /// Convert state to JSON (for caching)
  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'items': items.map(toJsonT).toList(),
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalItems': totalItems,
    };
  }

  PagedQueryState<T> copyWith({
    List<T>? items,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    AsyncValue<void>? pageStatus,
  }) {
    return PagedQueryState<T>(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      pageStatus: pageStatus ?? this.pageStatus,
    );
  }

  /// Convenience getters
  bool get isLoading => pageStatus is AsyncLoading;
  bool get hasError => pageStatus is AsyncError;
  Object? get error => (pageStatus as AsyncError?)?.error;
  bool get hasNextPage => currentPage < totalPages;
  bool get hasPreviousPage => currentPage > 1;
  bool get isEmpty => items.isEmpty && pageStatus == null;
  bool get isFirstPage => currentPage == 1;
  bool get isLastPage => currentPage == totalPages;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PagedQueryState<T> &&
          runtimeType == other.runtimeType &&
          listEquals(items, other.items) &&
          currentPage == other.currentPage &&
          totalPages == other.totalPages &&
          totalItems == other.totalItems &&
          pageStatus == other.pageStatus;

  @override
  int get hashCode =>
      Object.hashAll([items]) ^
      currentPage.hashCode ^
      totalPages.hashCode ^
      totalItems.hashCode ^
      pageStatus.hashCode;
}
