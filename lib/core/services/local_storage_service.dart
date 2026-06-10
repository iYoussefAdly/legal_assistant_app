import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  LocalStorageService(this._prefs);

  final SharedPreferences _prefs;

  // ── Keys ──────────────────────────────────────────────────────────────────
  static const _kIsLoggedIn = 'isLoggedIn';
  static const _kNationalId = 'nationalId';
  static const _kFullName = 'fullName';
  static const _kEmail = 'email';
  static const _kGender = 'gender';

  // ── Reads ─────────────────────────────────────────────────────────────────
  bool get isLoggedIn => _prefs.getBool(_kIsLoggedIn) ?? false;
  String? get nationalId => _prefs.getString(_kNationalId);
  String? get fullName => _prefs.getString(_kFullName);
  String? get email => _prefs.getString(_kEmail);
  String? get gender => _prefs.getString(_kGender);

  // ── Writes ────────────────────────────────────────────────────────────────
  Future<void> saveSession({
    required String nationalId,
    String? fullName,
    String? email,
    String? gender,
  }) async {
    await Future.wait([
      _prefs.setBool(_kIsLoggedIn, true),
      _prefs.setString(_kNationalId, nationalId),
      if (fullName != null) _prefs.setString(_kFullName, fullName),
      if (email != null) _prefs.setString(_kEmail, email),
      if (gender != null) _prefs.setString(_kGender, gender),
    ]);
  }

  Future<void> clearSession() async {
    await Future.wait([
      _prefs.remove(_kIsLoggedIn),
      _prefs.remove(_kNationalId),
      _prefs.remove(_kFullName),
      _prefs.remove(_kEmail),
      _prefs.remove(_kGender),
    ]);
  }
}
