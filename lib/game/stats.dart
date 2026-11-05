import 'dart:convert';

/// إحصائيات اللاعب المحفوظة.
class Stats {
  int reps = 0;
  int days = 0;
  int seconds = 0;
  int streak = 0;

  /// آخر يوم تدريب بصيغة yyyy-MM-dd.
  String lastDate = '';

  /// يوم آخر إنجاز لتحدي اليوم.
  String dailyDone = '';

  String encode() => jsonEncode(<String, Object>{
        'reps': reps,
        'days': days,
        'seconds': seconds,
        'streak': streak,
        'lastDate': lastDate,
        'dailyDone': dailyDone,
      });

  static Stats decode(String s) {
    final Stats st = Stats();
    try {
      final Map<String, dynamic> m = jsonDecode(s) as Map<String, dynamic>;
      st.reps = (m['reps'] as num?)?.toInt() ?? 0;
      st.days = (m['days'] as num?)?.toInt() ?? 0;
      st.seconds = (m['seconds'] as num?)?.toInt() ?? 0;
      st.streak = (m['streak'] as num?)?.toInt() ?? 0;
      st.lastDate = (m['lastDate'] as String?) ?? '';
      st.dailyDone = (m['dailyDone'] as String?) ?? '';
    } catch (_) {}
    return st;
  }
}
