// added on 8th Nov 2025
// lib/main.dart
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
  await Firebase.initializeApp();

  // Activate App Check. Use debug provider while developing.
  // For production use AndroidProvider.playIntegrity / IOSProvider.appAttest.
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );

  await di.init();

  // Run seed data only in debug and handle Firestore not-enabled errors gracefully
  if (kDebugMode) {
    try {
      // comment out or remove the call after first successful run
      // await InitialSetup.createAllSeedUsers();
      // 🔧 Uncomment this line to fix missing Firestore documents:
      await InitialSetup.fixMissingFirestoreUsers();
    } catch (e, st) {
      // don't crash app if Firestore isn't available or seed fails
      debugPrint('Initial seed skipped: $e\n$st');
    }
  }

  runApp(const MuwasiwakiApp());
}
