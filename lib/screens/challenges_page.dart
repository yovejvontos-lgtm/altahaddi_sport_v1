import 'package:flutter/material.dart';

import '../game/exercise.dart';
import '../theme.dart';
import '../widgets/app_card.dart';
import '../widgets/page_header.dart';
import 'workout_screen.dart';

class ChallengesPage extends StatelessWidget {
  const ChallengesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      children: <Widget>[
        const PageHeader(title: 'التحديات'),
        for (final Challenge c in Challenge.all)
          AppCard(
            onTap: () => openChallenge(context, c),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${c.emoji} ${c.title}', style: kTitle),
                const SizedBox(height: 4),
                Text(c.subtitle, style: kSub),
              ],
            ),
          ),
      ],
    );
  }
}
