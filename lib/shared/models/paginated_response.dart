// lib/shared/models/paginated_response.dart
import 'package:equatable/equatable.dart';

class PaginatedResponse<T> extends Equatable {
  final List<T> items;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final String? nextPageToken;
  final String? previousPageToken;

  const PaginatedResponse({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
    this.nextPageToken,
    this.previousPageToken,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) itemFromJson,
  ) {
    final itemsList = (json['items'] as List? ?? [])
        .map((item) => itemFromJson(item as Map<String, dynamic>))
        .toList();

    final currentPage = json['currentPage'] ?? 1;
    final totalPages = json['totalPages'] ?? 1;
    final totalItems = json['totalItems'] ?? itemsList.length;
    final itemsPerPage = json['itemsPerPage'] ?? itemsList.length;

    return PaginatedResponse<T>(
      items: itemsList,
      currentPage: currentPage,
      totalPages: totalPages,
      totalItems: totalItems,
      itemsPerPage: itemsPerPage,
      hasNextPage: currentPage < totalPages,
      hasPreviousPage: currentPage > 1,
      nextPageToken: json['nextPageToken'],
      previousPageToken: json['previousPageToken'],
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) itemToJson) {
    return {
      'items': items.map(itemToJson).toList(),
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalItems': totalItems,
      'itemsPerPage': itemsPerPage,
      'hasNextPage': hasNextPage,
      'hasPreviousPage': hasPreviousPage,
      'nextPageToken': nextPageToken,
      'previousPageToken': previousPageToken,
    };
  }

  // Helper methods
  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
  bool get isFirstPage => currentPage == 1;
  bool get isLastPage => currentPage == totalPages;

  int get startIndex => (currentPage - 1) * itemsPerPage;
  int get endIndex => startIndex + items.length;

  String get pageInfo => '$startIndex-$endIndex of $totalItems';

  double get progress => totalPages > 0 ? currentPage / totalPages : 0.0;

  PaginatedResponse<T> copyWith({
    List<T>? items,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    int? itemsPerPage,
    bool? hasNextPage,
    bool? hasPreviousPage,
    String? nextPageToken,
    String? previousPageToken,
  }) {
    return PaginatedResponse<T>(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      nextPageToken: nextPageToken ?? this.nextPageToken,
      previousPageToken: previousPageToken ?? this.previousPageToken,
    );
  }

  @override
  List<Object?> get props => [
        items,
        currentPage,
        totalPages,
        totalItems,
        itemsPerPage,
        hasNextPage,
        hasPreviousPage,
        nextPageToken,
        previousPageToken,
      ];

  @override
  String toString() {
    return 'PaginatedResponse{currentPage: $currentPage, totalPages: $totalPages, totalItems: $totalItems, itemsCount: ${items.length}}';
  }
}
