// lib/core/config/app_config.dart
import 'package:flutter/foundation.dart';

class AppConfig {
  static const String appName = 'MUWASIWAKI';
  static const String packageName = 'com.muwasiwaki.app';

  // Environment-specific configurations
  static bool get isDebug => kDebugMode;
  static bool get isProduction => kReleaseMode;

  // Firebase configuration
  static const String firebaseProjectId = 'muwasiwaki-app';

  // API configuration
  static const int apiTimeoutSeconds = 30;
  static const int maxRetryAttempts = 3;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // File upload limits
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png', 'gif'];
}
