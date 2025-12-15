// lib/features/membership/data/datasources/membership_local_datasource.dart
import '../../../../core/services/local_storage_service.dart';
import '../../domain/entities/membership_application.dart';
import '../models/membership_application_model.dart';

abstract class MembershipLocalDataSource {
  Future<List<MembershipApplicationModel>> getCachedApplications();
  Future<void> cacheApplications(List<MembershipApplicationModel> applications);
  Future<void> clearApplicationsCache();
  Future<void> cacheApplication(MembershipApplicationModel application);
  Future<MembershipApplicationModel?> getCachedApplication(String id);
}

class MembershipLocalDataSourceImpl implements MembershipLocalDataSource {
  final LocalStorageService localStorage;
  static const String _applicationsCacheKey = 'cached_applications';
  static const String _applicationPrefix = 'application_';

  MembershipLocalDataSourceImpl(this.localStorage);

  @override
  Future<List<MembershipApplicationModel>> getCachedApplications() async {
    try {
      final applicationsData = localStorage.getObject(_applicationsCacheKey);
      if (applicationsData != null &&
          applicationsData['applications'] is List) {
        final applicationsList = applicationsData['applications'] as List;
        return applicationsList
            .map((app) => MembershipApplicationModelLocalStorage.fromMap(
                app as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> cacheApplications(
      List<MembershipApplicationModel> applications) async {
    try {
      final applicationsData = {
        'applications': applications.map((app) => app.toMap()).toList(),
        'cachedAt': DateTime.now().toIso8601String(),
      };
      await localStorage.setObject(_applicationsCacheKey, applicationsData);
    } catch (e) {
      // Silently fail - caching is not critical
    }
  }

  @override
  Future<void> clearApplicationsCache() async {
    try {
      await localStorage.remove(_applicationsCacheKey);

      // Also clear individual application cache
      final keys = localStorage.getKeys();
      for (final key in keys) {
        if (key.startsWith(_applicationPrefix)) {
          await localStorage.remove(key);
        }
      }
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Future<void> cacheApplication(MembershipApplicationModel application) async {
    try {
      await localStorage.setObject(
          '$_applicationPrefix${application.id}', application.toMap());
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Future<MembershipApplicationModel?> getCachedApplication(String id) async {
    try {
      final applicationData = localStorage.getObject('$_applicationPrefix$id');
      if (applicationData != null) {
        return MembershipApplicationModelLocalStorage.fromMap(applicationData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
