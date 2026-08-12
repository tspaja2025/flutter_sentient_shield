import 'package:flutter_sentient_shield/screens/activity.dart';
import 'package:flutter_sentient_shield/screens/cameras.dart';
import 'package:flutter_sentient_shield/screens/dashboard.dart';
import 'package:flutter_sentient_shield/screens/devices.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const Dashboard()),
    GoRoute(path: '/cameras', builder: (context, state) => const Cameras()),
    GoRoute(path: '/devices', builder: (context, state) => const Devices()),
    GoRoute(path: '/activity', builder: (context, state) => const Activity()),
  ],
);
