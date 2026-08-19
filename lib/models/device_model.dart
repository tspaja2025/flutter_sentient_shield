import 'package:material_ui/material_ui.dart';

enum DeviceType { lock, sensor, alarm }

enum DeviceStatus { secure, warning, alert, active }

class Device {
  final String id;
  final String name;
  final DeviceType type;
  final IconData icon;
  final String location;
  DeviceStatus status;
  String statusText;
  int batteryLevel;
  bool isOnline;
  DateTime lastActivity;

  Device({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
    required this.location,
    required this.status,
    required this.statusText,
    required this.batteryLevel,
    required this.isOnline,
    required this.lastActivity,
  });
}
