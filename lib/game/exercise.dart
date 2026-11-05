import 'package:flutter/material.dart';

enum ExerciseType { count, time }

/// تمرين ثابت (لا يُعدَّل أثناء التشغيل).
class Exercise {
  const Exercise({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.hint,
    required this.icon,
    required this.goal,
    required this.type,
  });

  final String id;
  final String title;
  final String subtitle;
  final String hint;
  final IconData icon;

  /// الهدف: عدد التكرارات، أو الثواني إذا كان النوع وقتاً.
  final int goal;
  final ExerciseType type;

  static const Exercise pushup = Exercise(
    id: 'pushup',
    title: 'تمارين الضغط (Push-ups)',
    subtitle: 'الصدر والذراعين',
    hint: 'انزل بصدرك ثم ادفع الجسم للأعلى',
    icon: Icons.fitness_center,
    goal: 20,
    type: ExerciseType.count,
  );

  static const Exercise plank = Exercise(
    id: 'plank',
    title: 'البلانك (Plank)',
    subtitle: 'العضلات العميقة',
    hint: 'ثبّت جسمك مستقيماً على الساعدين',
    icon: Icons.horizontal_rule,
    goal: 60,
    type: ExerciseType.time,
  );

  static const Exercise squats = Exercise(
    id: 'squats',
    title: 'القرفصاء (Squats)',
    subtitle: 'الأرجل والمؤخرة',
    hint: 'انزل كأنك تجلس ثم قف',
    icon: Icons.directions_run,
    goal: 30,
    type: ExerciseType.count,
  );

  static const Exercise abs = Exercise(
    id: 'abs',
    title: 'تمرين البطن (Abs)',
    subtitle: 'عضلات البطن المركزية',
    hint: 'ارفع كتفيك عن الأرض وشدّ بطنك',
    icon: Icons.self_improvement,
    goal: 50,
    type: ExerciseType.count,
  );

  static const List<Exercise> all = <Exercise>[pushup, plank, squats, abs];
}

/// تحدٍّ = تمرين + هدف + حدّ زمني اختياري.
/// يحمل هدفه الخاص فلا يغيّر هدف التمرين الأصلي.
class Challenge {
  const Challenge({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.exercise,
    required this.goal,
    this.timeLimit,
  });

  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final Exercise exercise;
  final int goal;

  /// بالثواني. null = بلا حدّ زمني.
  final int? timeLimit;

  static const Challenge daily = Challenge(
    id: 'daily',
    title: 'تحدي اليوم',
    subtitle: 'أكمل 50 تكراراً من الضغط خلال 5 دقائق.',
    emoji: '🔥',
    exercise: Exercise.pushup,
    goal: 50,
    timeLimit: 300,
  );

  static const Challenge push10 = Challenge(
    id: 'push10',
    title: 'تحدي الـ 10 ضغطات',
    subtitle: 'هدف سريع للمبتدئين',
    emoji: '🚀',
    exercise: Exercise.pushup,
    goal: 10,
  );

  static const Challenge push30 = Challenge(
    id: 'push30',
    title: 'تحدي الـ 30 ضغطة',
    subtitle: 'للذين يملكون أساساً جيداً',
    emoji: '⚡',
    exercise: Exercise.pushup,
    goal: 30,
  );

  static const Challenge abs50 = Challenge(
    id: 'abs50',
    title: 'تحدي البطن',
    subtitle: '50 تمرين بطن مركزي',
    emoji: '🧘',
    exercise: Exercise.abs,
    goal: 50,
  );

  static const List<Challenge> all = <Challenge>[
    daily,
    push10,
    push30,
    abs50,
  ];
}
