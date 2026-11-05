import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'stats.dart';

/// الحفظ المحلي: الإحصائيات والمستوى وسلسلة الأيام.
class Save extends ChangeNotifier {
  Save._();

  static final Save instance = Save._();

  Stats stats = Stats();

  static String _key(DateTime d) {
    final String m = d.month.toString().padLeft(2, '0');
    final String day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$m-$day';
  }

  static DateTime? _parse(String s) {
    try {
      final List<String> p = s.split('-');
      return DateTime.utc(int.parse(p[0]), int.parse(p[1]), int.parse(p[2]));
    } catch (_) {
      return null;
    }
  }

  static int _daysSince(DateTime last) {
    final DateTime now = DateTime.now();
    return DateTime.utc(now.year, now.month, now.day).difference(last).inDays;
  }

  Future<void> load() async {
    try {
      final SharedPreferences p = await SharedPreferences.getInstance();
      final String? s = p.getString('stats_v1');
      if (s != null) {
        stats = Stats.decode(s);
      }
    } catch (_) {}
    notifyListeners();
  }

  /// سلسلة الأيام الفعلية: تُصفَّر إن مرّ أكثر من يوم راحة واحد.
  int get streak {
    final DateTime? last = _parse(stats.lastDate);
    if (last == null) {
      return 0;
    }
    return _daysSince(last) <= 2 ? stats.streak : 0;
  }

  bool get dailyDoneToday => stats.dailyDone == _key(DateTime.now());

  String get levelName {
    final int r = stats.reps;
    if (r > 1000) {
      return 'أسطورة 🐲';
    }
    if (r > 500) {
      return 'متقدم ⚡';
    }
    return 'مبتدئ 🌱';
  }

  Color get levelColor {
    final int r = stats.reps;
    if (r > 1000) {
      return const Color(0xFFE67E22);
    }
    if (r > 500) {
      return const Color(0xFF3498DB);
    }
    return const Color(0xFF2ECC71);
  }

  /// تسجيل جلسة تدريب (تُستدعى مرة واحدة لكل جلسة).
  Future<void> addSession({
    required int reps,
    required int seconds,
    String? challengeId,
    bool completed = false,
  }) async {
    if (reps <= 0 && seconds <= 0) {
      return;
    }
    final DateTime now = DateTime.now();
    final String today = _key(now);
    stats.reps += reps;
    stats.seconds += seconds;

    if (stats.lastDate != today) {
      final DateTime? last = _parse(stats.lastDate);
      stats.days++;
      if (last == null) {
        stats.streak = 1;
      } else {
        // يُسمح بيوم راحة واحد بين يومي التدريب.
        stats.streak = _daysSince(last) <= 2 ? stats.streak + 1 : 1;
      }
      stats.lastDate = today;
    }

    if (challengeId == 'daily' && completed) {
      stats.dailyDone = today;
    }

    notifyListeners();
    try {
      final SharedPreferences p = await SharedPreferences.getInstance();
      await p.setString('stats_v1', stats.encode());
    } catch (_) {}
  }
}
