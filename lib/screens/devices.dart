import 'package:material_ui/material_ui.dart';
import 'package:flutter_sentient_shield/shared/app_scaffold.dart';
import 'package:flutter_sentient_shield/theme/sentient_shield_theme.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class Devices extends StatelessWidget {
  const Devices({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tokens = Theme.of(context).extension<SentientTokens>()!;

    return AppScaffold(
      currentIndex: 2,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(tokens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Devices'),
            const Text('Manage and monitor your security hardware.'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Locks', style: textTheme.headlineSmall),
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
                child: Icon(
                  Symbols.lock,
                  fill: 1,
                  color: colorScheme.onPrimary,
                ),
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
                child: Icon(Symbols.lock_open, color: colorScheme.onPrimary),
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
                Text('Sensors', style: textTheme.headlineSmall),
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
                child: Icon(Symbols.window_open, color: colorScheme.onPrimary),
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
                child: Icon(
                  Symbols.motion_sensor_active,
                  color: colorScheme.onPrimary,
                ),
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
                Text('Alarms', style: textTheme.headlineSmall),
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
                child: Icon(
                  Symbols.notifications_active,
                  color: colorScheme.onPrimary,
                ),
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
