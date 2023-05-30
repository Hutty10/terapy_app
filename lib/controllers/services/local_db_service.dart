import 'dart:developer' show log;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Create storage
class LocalDBService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final _prefStorage = SharedPreferences.getInstance();
  static const String emailKey = 'email';
  static const String passwordKey = 'password';
  static const String onboardingKey = 'onboarding';

  void saveEmailPassword(String email, password) {
    Future.wait([
      _storage.write(key: emailKey, value: email),
      _storage.write(key: passwordKey, value: passwordKey),
    ]);
    log('saved');
  }

  Future<Map<String, String?>> readEmailPassword() async {
    if (await _storage.containsKey(key: emailKey) &&
        await _storage.containsKey(key: passwordKey)) {
      return {
        'email': await _storage.read(key: emailKey),
        'password': await _storage.read(key: passwordKey),
      };
    }
    return {};
  }

  void deleteEmailPassword() async {
    if (await _storage.containsKey(key: emailKey)) {
      _storage.deleteAll();
    }
  }

  void setOnboarding() async {
    final SharedPreferences pref = await _prefStorage;
    await pref.setBool(onboardingKey, true);
  }

  Future<bool> readOnboarding() async {
    final SharedPreferences pref = await _prefStorage;
    return pref.getBool(onboardingKey) ?? false;
  }

  void uninitializeApp() async {
    final SharedPreferences pref = await _prefStorage;
    Future.wait([
      pref.clear(),
      _storage.deleteAll(),
    ]);
  }
}

final localDbProvider = Provider<LocalDBService>((ref) => LocalDBService());
