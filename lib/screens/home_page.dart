import 'package:flutter/material.dart';

import '../game/exercise.dart';
import '../game/save.dart';
import '../theme.dart';
import '../widgets/app_card.dart';
import '../widgets/page_header.dart';
import 'workout_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      children: <Widget>[
        const PageHeader(
          title: 'التحدي الرياضي',
          subtitle: 'أهلاً بك يا بطل! 💪',
          trailing: LevelBadge(),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/cover.png',
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        AnimatedBuilder(
          animation: Save.instance,
          builder: (BuildContext context, Widget? child) {
            final bool done = Save.instance.dailyDoneToday;
            return AppCard(
              accent: kSecondary,
              gradient: const LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: <Color>[Color(0xFF1A1A1A), Color(0xFF2A2A2A)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${Challenge.daily.emoji} ${Challenge.daily.title}${done ? '  ✅' : ''}',
                    style: kTitle,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    Challenge.daily.subtitle,
                    style: const TextStyle(color: Color(0xFFCCCCCC)),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => openChallenge(context, Challenge.daily),
                      child: Text(done ? 'أنجزته اليوم - أعد المحاولة' : 'ابدأ التحدي'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const Padding(
          padding: EdgeInsets.only(top: 6, bottom: 12),
          child: Text('القائمة السريعة', style: kTitle),
        ),
        for (final Exercise e in Exercise.all)
          AppCard(
            onTap: () => openExercise(context, e),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(e.title, style: kTitle),
                      const SizedBox(height: 2),
                      Text(e.subtitle, style: kSub),
                    ],
                  ),
                ),
                Icon(e.icon, size: 28, color: kPrimary),
              ],
            ),
          ),
      ],
    );
  }
}
