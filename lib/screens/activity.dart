import 'package:material_ui/material_ui.dart';
import 'package:flutter_sentient_shield/shared/app_scaffold.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class Activity extends StatelessWidget {
  const Activity({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppScaffold(
      currentIndex: 3,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Symbols.search),
                suffixIcon: const Icon(Symbols.cancel),
                hintText: 'Search events, devices, or people',
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  FilledButton(
                    onPressed: () {},
                    child: const Text('All Events'),
                  ),
                  FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Symbols.warning),
                    label: const Text('Alarms'),
                  ),
                  FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Symbols.key),
                    label: const Text('Access'),
                  ),
                  FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Symbols.security),
                    label: const Text('System'),
                  ),
                ],
              ),
            ),
            const Text('Today'),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Symbols.person),
                ),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Access Granted'),
                              const Text('10:15 AM'),
                            ],
                          ),
                          const Text('Front Door Unlocked'),
                          const Text('Unlocked by John using Smart Lock PIN.'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Symbols.shield),
                ),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('System Status'),
                              const Text('8:00 AM'),
                            ],
                          ),
                          const Text('System Armed: Away Mode'),
                          const Text(
                            'All exterior sensors active. Interior motion sensors armed.',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Symbols.shield),
                ),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Motion Detected'),
                              const Text('3:42 AM'),
                            ],
                          ),
                          const Text('Backyard Camera'),
                          const Text(
                            'Unrecognized movement detected near the patio.',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Text('Yesterday'),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Symbols.shield),
                ),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('System Status'),
                              const Text('11:30 PM'),
                            ],
                          ),
                          const Text('System Armed: Home Mode'),
                          const Text(
                            'Scheduled routine \'Goodnight\' executed.',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Symbols.shield),
                ),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Access Granted'),
                              const Text('6:45 PM'),
                            ],
                          ),
                          const Text('Front Door Unlocked'),
                          const Text('Unlocked by Sarah using Mobile App.'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: Column(
                children: [
                  const Icon(Symbols.history),
                  const Text('End of recent history'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
