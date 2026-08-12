import 'package:flutter/material.dart';
import 'package:flutter_sentient_shield/shared/app_scaffold.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class Cameras extends StatelessWidget {
  const Cameras({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppScaffold(
      currentIndex: 1,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Devices'),
            const Text('Manage and monitor your security hardware.'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Locks'),
                const Badge(label: Text('2 Online')),
              ],
            ),
            ListTile(
              leading: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Symbols.lock, fill: 1),
              ),
              title: const Text('Front Door'),
              subtitle: const Text('Locked'),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Symbols.settings),
              ),
            ),
            ListTile(
              leading: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Symbols.lock_open),
              ),
              title: const Text('Side Gate'),
              subtitle: const Text('Unlocked'),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Symbols.settings),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Sensors'),
                const Badge(label: Text('1 Alert')),
              ],
            ),
            ListTile(
              leading: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Symbols.window_open),
              ),
              title: const Text('Living Room Window'),
              subtitle: const Text('Open'),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Symbols.settings),
              ),
            ),
            ListTile(
              leading: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Symbols.motion_sensor_active),
              ),
              title: const Text('Hallway Motion'),
              subtitle: const Text('Active'),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Symbols.settings),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Alarms'),
                const Badge(label: Text('2 online')),
              ],
            ),
            ListTile(
              leading: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Symbols.notifications_active),
              ),
              title: const Text('Main Siren'),
              subtitle: const Text('Armed'),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Symbols.settings),
              ),
            ),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Symbols.add),
              label: const Text('Add New Device'),
            ),
          ],
        ),
      ),
    );
  }
}
