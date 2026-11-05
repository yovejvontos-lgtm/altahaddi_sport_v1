import 'package:flutter/material.dart';

import '../game/badges.dart';
import '../game/save.dart';
import '../theme.dart';
import '../widgets/app_card.dart';
import '../widgets/page_header.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  Widget _box(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF222222),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: kSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: kSub),
        ],
      ),
    );
  }

  Widget _badge(BadgeInfo b, bool unlocked) {
    final Color color = unlocked ? kPrimary : const Color(0xFF555555);
    return Opacity(
      opacity: unlocked ? 1 : 0.5,
      child: Container(
        width: 66,
        height: 66,
        decoration: BoxDecoration(
          color: const Color(0xFF222222),
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(b.icon, size: 22, color: color),
            Text(b.name, style: const TextStyle(fontSize: 9)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Save.instance,
      builder: (BuildContext context, Widget? child) {
        final Save s = Save.instance;
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          children: <Widget>[
            const PageHeader(title: 'إنجازاتي', trailing: LevelBadge()),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.6,
              children: <Widget>[
                _box('${s.stats.reps}', 'إجمالي التكرارات'),
                _box('${s.stats.days}', 'أيام التدريب'),
                _box('${s.stats.seconds ~/ 60}', 'الدقائق المنجزة'),
                _box('${s.streak} 🔥', 'سلسلة الأيام'),
              ],
            ),
            const SizedBox(height: 20),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('🏆 الشارات', style: kTitle),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      for (final BadgeInfo b in kBadges)
                        _badge(b, s.stats.reps >= b.req),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
