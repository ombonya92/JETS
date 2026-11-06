import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthUser {
  final String id;
  final String name;
  final String email;
  final String university;
  final String course;

  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.university,
    required this.course,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      university: json['university'] as String,
      course: json['course'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'university': university,
      'course': course,
    };
  }

  AuthUser copyWith({
    String? name,
    String? university,
    String? course,
  }) {
    return AuthUser(
      id: id,
      name: name ?? this.name,
      email: email,
      university: university ?? this.university,
      course: course ?? this.course,
    );
  }
}

enum AuthStatus { loading, authenticated, unauthenticated }

class AuthState extends ChangeNotifier {
  static const String _userKey = 'auth_user';
  static const String _credKey = 'auth_credentials';

  AuthStatus _status = AuthStatus.loading;
  AuthUser? _user;
  String? _error;

  AuthStatus get status => _status;
  AuthUser? get user => _user;
  String? get error => _error;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  Future<void> initialise() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_userKey);
    if (raw != null) {
      try {
        _user = AuthUser.fromJson(jsonDecode(raw) as Map<String, dynamic>);
        _status = AuthStatus.authenticated;
      } catch (_) {
        _status = AuthStatus.unauthenticated;
      }
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> register({
    required String name,
    required String email,
    required String university,
    required String course,
    required String password,
  }) async {
    _error = null;
    final prefs = await SharedPreferences.getInstance();

    final credsRaw = prefs.getString(_credKey);
    if (credsRaw != null) {
      final creds = jsonDecode(credsRaw) as Map<String, dynamic>;
      if (creds.containsKey(email.toLowerCase())) {
        _error = 'An account with this email already exists.';
        notifyListeners();
        return false;
      }
    }

    final id = _generateId();
    final user = AuthUser(
      id: id,
      name: name,
      email: email.toLowerCase(),
      university: university,
      course: course,
    );

    final creds = credsRaw != null
        ? jsonDecode(credsRaw) as Map<String, dynamic>
        : <String, dynamic>{};

    creds[email.toLowerCase()] = {
      'id': id,
      'password': _hashPassword(password),
    };

    await Future.wait([
      prefs.setString(_userKey, jsonEncode(user.toJson())),
      prefs.setString(_credKey, jsonEncode(creds)),
    ]);

    _user = user;
    _status = AuthStatus.authenticated;
    notifyListeners();
    return true;
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _error = null;
    final prefs = await SharedPreferences.getInstance();

    final credsRaw = prefs.getString(_credKey);
    if (credsRaw == null) {
      _error = 'No account found. Please register first.';
      notifyListeners();
      return false;
    }

    final creds = jsonDecode(credsRaw) as Map<String, dynamic>;
    final entry = creds[email.toLowerCase()] as Map<String, dynamic>?;

    if (entry == null || entry['password'] != _hashPassword(password)) {
      _error = 'Email or password is incorrect.';
      notifyListeners();
      return false;
    }

    final userId = entry['id'] as String;
    final allUsers = prefs.getString('all_users_$userId');

    if (allUsers != null) {
      _user = AuthUser.fromJson(
        jsonDecode(allUsers) as Map<String, dynamic>,
      );
    } else {
      _user = AuthUser(
        id: userId,
        name: email.split('@').first,
        email: email.toLowerCase(),
        university: '',
        course: '',
      );
    }

    await prefs.setString(_userKey, jsonEncode(_user!.toJson()));
    _status = AuthStatus.authenticated;
    notifyListeners();
    return true;
  }

  Future<bool> updateProfile({
    required String name,
    required String university,
    required String course,
  }) async {
    if (_user == null) return false;
    _error = null;

    final updated = _user!.copyWith(
      name: name,
      university: university,
      course: course,
    );

    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setString(_userKey, jsonEncode(updated.toJson())),
      prefs.setString(
        'all_users_${updated.id}',
        jsonEncode(updated.toJson()),
      ),
    ]);

    _user = updated;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> deleteAccount() async {
    if (_user == null) return;
    final prefs = await SharedPreferences.getInstance();
    final credsRaw = prefs.getString(_credKey);
    if (credsRaw != null) {
      final creds = jsonDecode(credsRaw) as Map<String, dynamic>;
      creds.remove(_user!.email);
      await prefs.setString(_credKey, jsonEncode(creds));
    }
    await prefs.remove(_userKey);
    await prefs.remove('all_users_${_user!.id}');
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  String _hashPassword(String password) {
    var hash = 0;
    for (final ch in password.codeUnits) {
      hash = ((hash << 5) - hash + ch) & 0xFFFFFFFF;
    }
    return hash.toRadixString(16);
  }

  String _generateId() {
    final rng = Random.secure();
    return List.generate(16, (_) => rng.nextInt(256))
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();
  }
}