// lib/shared/models/api_response.dart
import 'package:equatable/equatable.dart';

class ApiResponse<T> extends Equatable {
  final bool success;
  final T? data;
  final String? message;
  final String? error;
  final int? statusCode;
  final Map<String, dynamic>? metadata;

  const ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
    this.statusCode,
    this.metadata,
  });

  factory ApiResponse.success({
    required T data,
    String? message,
    int? statusCode = 200,
    Map<String, dynamic>? metadata,
  }) {
    return ApiResponse<T>(
      success: true,
      data: data,
      message: message ?? 'Success',
      statusCode: statusCode,
      metadata: metadata,
    );
  }

  factory ApiResponse.error({
    required String error,
    String? message,
    int? statusCode = 500,
    Map<String, dynamic>? metadata,
  }) {
    return ApiResponse<T>(
      success: false,
      error: error,
      message: message,
      statusCode: statusCode,
      metadata: metadata,
    );
  }

  factory ApiResponse.loading({
    String? message = 'Loading...',
    Map<String, dynamic>? metadata,
  }) {
    return ApiResponse<T>(
      success: false,
      message: message,
      statusCode: 102, // Processing
      metadata: metadata,
    );
  }

  bool get isSuccess => success && error == null;
  bool get isError => !success || error != null;
  bool get isLoading => statusCode == 102;

  bool get hasData => data != null;
  bool get hasError => error != null;
  bool get hasMessage => message != null && message!.isNotEmpty;

  @override
  List<Object?> get props =>
      [success, data, message, error, statusCode, metadata];

  @override
  String toString() {
    return 'ApiResponse{success: $success, data: $data, message: $message, error: $error, statusCode: $statusCode}';
  }
}
