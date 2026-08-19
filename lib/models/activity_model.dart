import 'package:material_ui/material_ui.dart';

enum ActivityType { access, alarm, system }

enum ActivityPriority { critical, high, medium, low }

class ActivityItem {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final DateTime timestamp;
  final ActivityType type;
  final IconData icon;
  final ActivityPriority priority;
  bool isRead;

  ActivityItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.timestamp,
    required this.type,
    required this.icon,
    required this.priority,
    this.isRead = false,
  });
}
