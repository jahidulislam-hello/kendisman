import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitzella/core/theme/theme_provider.dart';

/// Local cache of the signed-in user's profile setup (SharedPreferences).
/// Mirrors what we store in Supabase so every screen can read it offline.
class CachedProfile {
  final String? userId;
  final String? email;
  final String? username;
  final String? sex;
  final String? dateOfBirth;
  final double? heightCm;
  final double? weightKg;
  final bool useMetric;
  final String? goal;
  final String? equipment;
  final String? experience;
  final int? frequency;
  final bool onboarded;
  final String? photoUrl;

  const CachedProfile({
    this.userId,
    this.email,
    this.username,
    this.sex,
    this.dateOfBirth,
    this.heightCm,
    this.weightKg,
    this.useMetric = true,
    this.goal,
    this.equipment,
    this.experience,
    this.frequency,
    this.onboarded = false,
    this.photoUrl,
  });

  String get displayName {
    final name = username?.trim();
    if (name != null && name.isNotEmpty) return name;
    final mail = email?.trim();
    if (mail != null && mail.contains('@')) {
      return mail.split('@').first;
    }
    return 'Athlete';
  }

  String get initial {
    final n = displayName;
    return n.isEmpty ? 'A' : n[0].toUpperCase();
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'email': email,
        'username': username,
        'sex': sex,
        'dateOfBirth': dateOfBirth,
        'heightCm': heightCm,
        'weightKg': weightKg,
        'useMetric': useMetric,
        'goal': goal,
        'equipment': equipment,
        'experience': experience,
        'frequency': frequency,
        'onboarded': onboarded,
        'photoUrl': photoUrl,
      };

  factory CachedProfile.fromJson(Map<String, dynamic> json) => CachedProfile(
        userId: json['userId'] as String?,
        email: json['email'] as String?,
        username: json['username'] as String?,
        sex: json['sex'] as String?,
        dateOfBirth: json['dateOfBirth'] as String?,
        heightCm: (json['heightCm'] as num?)?.toDouble(),
        weightKg: (json['weightKg'] as num?)?.toDouble(),
        useMetric: json['useMetric'] as bool? ?? true,
        goal: json['goal'] as String?,
        equipment: json['equipment'] as String?,
        experience: json['experience'] as String?,
        frequency: json['frequency'] as int?,
        onboarded: json['onboarded'] as bool? ?? false,
        photoUrl: json['photoUrl'] as String?,
      );

  CachedProfile copyWith({
    String? userId,
    String? email,
    String? username,
    String? sex,
    String? dateOfBirth,
    double? heightCm,
    double? weightKg,
    bool? useMetric,
    String? goal,
    String? equipment,
    String? experience,
    int? frequency,
    bool? onboarded,
    String? photoUrl,
    bool clearPhotoUrl = false,
  }) {
    return CachedProfile(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      username: username ?? this.username,
      sex: sex ?? this.sex,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      useMetric: useMetric ?? this.useMetric,
      goal: goal ?? this.goal,
      equipment: equipment ?? this.equipment,
      experience: experience ?? this.experience,
      frequency: frequency ?? this.frequency,
      onboarded: onboarded ?? this.onboarded,
      photoUrl: clearPhotoUrl ? null : (photoUrl ?? this.photoUrl),
    );
  }
}

class ProfilePrefsService {
  static const _key = 'cached_user_profile_v1';

  final SharedPreferences _prefs;

  ProfilePrefsService(this._prefs);

  CachedProfile? load() {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return null;
    try {
      return CachedProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> save(CachedProfile profile) async {
    await _prefs.setString(_key, jsonEncode(profile.toJson()));
    // Keep units screen in sync
    await _prefs.setString('unit_weight', profile.useMetric ? 'kg' : 'lb');
    await _prefs.setString('unit_body', profile.useMetric ? 'cm' : 'in');
  }

  Future<void> clear() async {
    await _prefs.remove(_key);
  }
}

final profilePrefsServiceProvider = Provider<ProfilePrefsService>((ref) {
  return ProfilePrefsService(ref.watch(sharedPreferencesProvider));
});

final cachedProfileProvider = StateProvider<CachedProfile?>((ref) {
  return ref.watch(profilePrefsServiceProvider).load();
});
