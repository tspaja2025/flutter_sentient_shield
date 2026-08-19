enum CameraStatus { motion, person, clear, offline }

class Camera {
  final String id;
  final String name;
  final String image;
  final String location;
  CameraStatus status;
  String lastActivity;
  DateTime timestamp;
  bool isFavorite;

  Camera({
    required this.id,
    required this.name,
    required this.image,
    required this.location,
    required this.status,
    required this.lastActivity,
    required this.timestamp,
    this.isFavorite = false,
  });
}
