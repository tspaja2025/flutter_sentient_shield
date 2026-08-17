import 'package:material_ui/material_ui.dart';
import 'package:flutter_sentient_shield/router/router.dart';
import 'package:flutter_sentient_shield/theme/sentient_shield_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Sentient Shield',
      theme: SentientShieldTheme.darkTheme,
      routerConfig: router,
    );
  }
}
