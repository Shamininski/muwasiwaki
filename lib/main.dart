// added on 8th Nov 2025
// lib/main.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app.dart';
import 'core/injection/injection_container.dart' as di;
import 'core/setup/initial_setup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp().timeout(const Duration(seconds: 5));
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }
  // ============== Commented out on 30 Dec 2025 ==========================
  // ============== Slow Loading & Internet Dependency =======================
  // await Firebase.initializeApp();

  // // Activate App Check. Use debug provider while developing.
  // // For production use AndroidProvider.playIntegrity / IOSProvider.appAttest.
  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.debug,
  //   appleProvider: AppleProvider.debug,
  // );
  // ============== Commented out on 30 Dec 2025 ==========================

  await di.init();

  // Run seed data only in debug and handle Firestore not-enabled errors gracefully
  // if (kDebugMode) {
  // try {
  // 1. FIRST: Clean all existing data
  // await InitialSetup.resetAllData();
  // await InitialSetup.createAllSeedUsers();
  // comment out or remove the call after first successful run
  // await InitialSetup.createAllSeedUsers();
  // 🔧 Uncomment this line to fix missing Firestore documents:
  // await InitialSetup.fixMissingFirestoreUsers();
  // } catch (e, st) {
  // don't crash app if Firestore isn't available or seed fails
  // debugPrint('Initial seed skipped: $e\n$st');
  // }
  // }

  runApp(const MuwasiwakiApp());
}

Future<void> _checkDatabase() async {
  final apps = await FirebaseFirestore.instance
      .collection('membership_applications')
      .get();
  debugPrint('📊 Total applications: ${apps.docs.length}');
  for (var doc in apps.docs) {
    debugPrint('  - ${doc.data()['applicantName']}');
  }
}
