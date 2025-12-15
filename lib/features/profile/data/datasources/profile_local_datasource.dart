// lib/features/profile/data/datasources/profile_local_datasource.dart (Fixed)
import 'dart:convert';
import '../../../../core/services/local_storage_service.dart';
import '../models/user_profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<UserProfileModel?> getCachedProfile(String userId);
  Future<void> cacheProfile(UserProfileModel profile);
  Future<void> clearProfileCache(String userId);
  Future<void> clearAllProfileCache();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final LocalStorageService localStorage;
  static const String _profilePrefix = 'profile_';

  ProfileLocalDataSourceImpl(this.localStorage);

  @override
  Future<UserProfileModel?> getCachedProfile(String userId) async {
    try {
      final profileData = localStorage.getObject('$_profilePrefix$userId');
      if (profileData != null) {
        return UserProfileModelLocalStorage.fromMap(profileData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheProfile(UserProfileModel profile) async {
    try {
      await localStorage.setObject(
          '$_profilePrefix${profile.id}', profile.toMap());
    } catch (e) {
      // Silently fail - caching is not critical
    }
  }

  @override
  Future<void> clearProfileCache(String userId) async {
    try {
      await localStorage.remove('$_profilePrefix$userId');
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Future<void> clearAllProfileCache() async {
    try {
      final keys = localStorage.getKeys();
      for (final key in keys) {
        if (key.startsWith(_profilePrefix)) {
          await localStorage.remove(key);
        }
      }
    } catch (e) {
      // Silently fail
    }
  }
}
