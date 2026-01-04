/// Response model for page-based pagination
class PagedResponse<T> {
  final List<T> items;
  final int currentPage;
  final int totalPages;
  final int totalItems;

  const PagedResponse({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
  });

  factory PagedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PagedResponse(
      items: (json['items'] as List)
          .map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList(),
      currentPage: json['currentPage'] as int? ?? 1,
      totalPages: json['totalPages'] as int? ?? 1,
      totalItems: json['totalItems'] as int? ?? 0,
    );
  }
}
