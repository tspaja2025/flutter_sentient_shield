import 'package:flutter/material.dart';
import 'package:flutter_sentient_shield/shared/app_scaffold.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

enum System { disarmed, home, away }

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  System systemView = System.home;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppScaffold(
      currentIndex: 0,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('System Armed'),
                            const Text('Home Mode'),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Symbols.shield,
                            fill: 1,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                    SegmentedButton<System>(
                      showSelectedIcon: false,
                      segments: const <ButtonSegment<System>>[
                        ButtonSegment<System>(
                          value: System.disarmed,
                          label: Text('Disarmed'),
                        ),
                        ButtonSegment<System>(
                          value: System.home,
                          label: Text('Home'),
                        ),
                        ButtonSegment<System>(
                          value: System.away,
                          label: Text('Away'),
                        ),
                      ],
                      selected: <System>{systemView},
                      onSelectionChanged: (Set<System> newSelection) {
                        setState(() => systemView = newSelection.first);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const Text('Quick Actions'),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Symbols.lock),
                          ),
                          const Text('Unlock Front Door'),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              color: colorScheme.tertiaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Symbols.lightbulb,
                              color: colorScheme.onTertiaryContainer,
                            ),
                          ),
                          const Text('Exterior Lights On'),
                        ],
                      ),
                    ),
                  ),
                ),
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
                child: const Icon(Symbols.videocam),
              ),
              title: const Text('View Live Feeds'),
              subtitle: const Text('3 Cameras Active'),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Symbols.keyboard_arrow_right),
              ),
            ),
            const Text('Device Status'),
            ListTile(
              leading: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Symbols.door_front, fill: 1),
              ),
              title: const Text('Locks & Entries'),
              subtitle: const Text('All locks secured'),
              trailing: const Icon(Symbols.check_circle),
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
              title: const Text('Motion Sensors'),
              subtitle: const Text('No activity detected'),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Symbols.check_circle),
              ),
            ),
            FilledButton.icon(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.tertiary,
                foregroundColor: colorScheme.onTertiary,
              ),
              icon: const Icon(Symbols.asterisk),
              label: const Text('Emergency SOS'),
            ),
          ],
        ),
      ),
    );
  }
}
