import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class AppScaffold extends StatefulWidget {
  final int currentIndex;
  final Widget child;

  const AppScaffold({
    super.key,
    required this.currentIndex,
    required this.child,
  });

  @override
  State<AppScaffold> createState() => _AppScaffold();
}

class _AppScaffold extends State<AppScaffold> {
  void _onDestinationSelected(int index) {
    if (index == widget.currentIndex) return;

    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/cameras');
        break;
      case 2:
        context.go('/devices');
        break;
      case 3:
        context.go('/activity');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: UnconstrainedBox(
          child: const CircleAvatar(
            backgroundImage: AssetImage('images/sentient_shield_logo.png'),
          ),
        ),
        title: const Text('Sentient Shield'),
        actionsPadding: const EdgeInsets.only(right: 8),
        actions: [
          const CircleAvatar(
            backgroundImage: AssetImage(
              'images/professional_headshot_of_a_friendly_man_in_his_early_40s_smiling_clean_shaven.png',
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _onDestinationSelected,
        selectedIndex: widget.currentIndex,
        indicatorColor: Colors.transparent,
        destinations: [
          NavigationDestination(
            selectedIcon: Icon(
              Symbols.dashboard,
              fill: 1,
              color: colorScheme.primary,
            ),
            icon: Icon(Symbols.dashboard, color: colorScheme.onSurfaceVariant),
            label: 'Dashboard',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Symbols.videocam,
              fill: 1,
              color: colorScheme.primary,
            ),
            icon: Icon(Symbols.videocam, color: colorScheme.onSurfaceVariant),
            label: 'Cameras',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Symbols.detector,
              fill: 1,
              color: colorScheme.primary,
            ),
            icon: Icon(Symbols.detector, color: colorScheme.onSurfaceVariant),
            label: 'Devices',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Symbols.notifications_active,
              fill: 1,
              color: colorScheme.primary,
            ),
            icon: Icon(
              Symbols.notifications_active,
              color: colorScheme.onSurfaceVariant,
            ),
            label: 'Activity',
          ),
        ],
      ),
      body: widget.child,
    );
  }
}
