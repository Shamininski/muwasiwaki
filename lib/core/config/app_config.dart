// lib/core/config/app_config.dart
import 'package:flutter/foundation.dart';

class AppConfig {
  static const String appName = 'MUWASIWAKI';
  static const String packageName = 'com.muwasiwaki.app';
  static const String version = '1.0.0';

  // Environment-specific configurations
  static bool get isDebug => kDebugMode;
  static bool get isProduction => kReleaseMode;
  static bool get isProfile => kProfileMode;

  // Firebase configuration
  static const String firebaseProjectId = 'muwasiwaki-app';

  // API configuration
  static const int apiTimeoutSeconds = 30;
  static const int maxRetryAttempts = 3;
  static const Duration cacheTimeout = Duration(minutes: 5);

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  static const int loadMoreThreshold = 5;

  // File upload limits
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5MB
  static const int maxImageSizeMB = 5;
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png', 'gif'];
  static const int imageQuality = 85;

  // Cache settings
  static const Duration profileCacheDuration = Duration(hours: 1);
  static const Duration newsCacheDuration = Duration(minutes: 15);
  static const Duration applicationsCacheDuration = Duration(minutes: 30);

  // UI configuration
  static const double defaultBorderRadius = 12.0;
  static const double defaultElevation = 2.0;
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

  // Validation rules
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;
  static const int maxBioLength = 500;
  static const int maxReasonLength = 1000;

  // Feature flags
  static const bool enablePushNotifications = true;
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enableOfflineMode = true;

  // Database collection names
  static const String usersCollection = 'users';
  static const String userProfilesCollection = 'user_profiles';
  static const String newsCollection = 'news';
  static const String membershipApplicationsCollection =
      'membership_applications';
  static const String rolesCollection = 'roles';
  static const String permissionsCollection = 'permissions';
  static const String roleAssignmentsCollection = 'role_assignments';

  // Storage paths
  static const String profileImagesPath = 'profile_images';
  static const String newsImagesPath = 'news_images';
  static const String documentsPath = 'documents';

  // Preferences keys
  static const String userIdKey = 'user_id';
  static const String isLoggedInKey = 'is_logged_in';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  static const String notificationsEnabledKey = 'notifications_enabled';
  static const String firstLaunchKey = 'first_launch';
  static const String lastSyncKey = 'last_sync';

  // Error messages
  static const String networkErrorMessage =
      'Please check your internet connection and try again.';
  static const String serverErrorMessage =
      'Something went wrong. Please try again later.';
  static const String authErrorMessage =
      'Authentication failed. Please login again.';
  static const String permissionErrorMessage =
      'You don\'t have permission to perform this action.';

  // Success messages
  static const String loginSuccessMessage = 'Welcome back!';
  static const String registerSuccessMessage = 'Account created successfully!';
  static const String profileUpdateSuccessMessage =
      'Profile updated successfully!';
  static const String applicationSubmitSuccessMessage =
      'Application submitted successfully!';

  // Contact information
  static const String supportEmail = 'support@muwasiwaki.org';
  static const String organizationWebsite = 'https://muwasiwaki.org';
  static const String privacyPolicyUrl = 'https://muwasiwaki.org/privacy';
  static const String termsOfServiceUrl = 'https://muwasiwaki.org/terms';
}
