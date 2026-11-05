import 'package:flutter/material.dart';

class BadgeInfo {
  const BadgeInfo(this.req, this.icon, this.name);

  final int req;
  final IconData icon;
  final String name;
}

const List<BadgeInfo> kBadges = <BadgeInfo>[
  BadgeInfo(10, Icons.military_tech, 'البداية'),
  BadgeInfo(100, Icons.star, 'المثابر'),
  BadgeInfo(500, Icons.workspace_premium, 'النجم'),
  BadgeInfo(1000, Icons.diamond, 'الغني'),
];
