import 'dart:async';
import 'package:flutter_sentient_shield/models/system_model.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_sentient_shield/shared/app_scaffold.dart';
import 'package:flutter_sentient_shield/theme/sentient_shield_theme.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  System systemView = System.home;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  int _activeCameras = 3;
  bool _isEmergencyActive = false;
  Timer? _statusTimer;

  final Map<String, bool> _deviceStatus = {
    'frontDoor': true,
    'backDoor': true,
    'garageDoor': true,
    'motionSensor1': false,
    'motionSensor2': false,
    'motionSensor3': false,
  };

  void _triggerEmergency() {
    setState(() {
      _isEmergencyActive = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Alert'),
        content: const Text(
          'Emergency services have been notified. Stay calm and wait for assistance.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _isEmergencyActive = false;
              });
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                _isEmergencyActive = false;
              });
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showQuickActionDialog(BuildContext context, String action) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Action'),
        content: Text('Are you sure you want to $action?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$action initiated'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showDeviceDetail(BuildContext context, String device) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(device, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            const Text('Status: Normal'),
            const SizedBox(height: 8),
            const Text('Battery: 95%'),
            const SizedBox(height: 8),
            const Text('Last check: Just now'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _statusTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _deviceStatus['motionSensor1'] = DateTime.now().second.isEven;
          _deviceStatus['motionSensor2'] = DateTime.now().second % 3 == 0;
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _statusTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tokens = Theme.of(context).extension<SentientTokens>()!;

    return AppScaffold(
      currentIndex: 0,
      child: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 800));
          if (mounted) {
            setState(() {
              _activeCameras = 3 + (DateTime.now().second % 2);
            });
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(tokens.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusCard(context),
              SizedBox(height: tokens.spacingLg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Quick Actions', style: textTheme.headlineSmall),
                  TextButton(onPressed: () {}, child: const Text('See All')),
                ],
              ),
              SizedBox(height: tokens.spacingLg),
              _buildQuickActions(context),
              SizedBox(height: tokens.spacingLg),
              _buildCameras(context),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Device Status', style: textTheme.headlineSmall),
                  TextButton(onPressed: () {}, child: const Text('See All')),
                ],
              ),
              SizedBox(height: tokens.spacingSm),
              _buildDeviceStatus(context),
              SizedBox(height: tokens.spacingLg),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isEmergencyActive ? null : _triggerEmergency,
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.error,
                    foregroundColor: colorScheme.onError,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: _isEmergencyActive
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Icon(Symbols.emergency, fill: 1),
                  label: Text(
                    _isEmergencyActive
                        ? 'Emergency Alert Sent!'
                        : 'Emergency SOS',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tokens = Theme.of(context).extension<SentientTokens>()!;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(tokens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'System Status',
                        style: textTheme.labelLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          letterSpacing: 0.6,
                        ),
                      ),
                      SizedBox(height: tokens.spacingXs),
                      Text(
                        systemView == System.home
                            ? 'Armed - Home'
                            : systemView == System.away
                            ? 'Armed - Away'
                            : 'Disarmed',
                        style: textTheme.headlineMedium?.copyWith(
                          color: systemView != System.disarmed
                              ? colorScheme.primary
                              : colorScheme.error,
                        ),
                      ),
                      Text(
                        systemView != System.disarmed
                            ? 'All systems active'
                            : 'All systems offline',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: systemView != System.disarmed
                            ? colorScheme.primary
                            : colorScheme.error,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        systemView != System.disarmed
                            ? Symbols.shield
                            : Symbols.shield_lock,
                        fill: 1,
                        color: systemView != System.disarmed
                            ? colorScheme.onPrimary
                            : colorScheme.onError,
                        size: 36,
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: tokens.spacingMd),
            SegmentedButton<System>(
              showSelectedIcon: false,
              style: SegmentedButton.styleFrom(
                backgroundColor: tokens.surfaceContainerLow,
                selectedBackgroundColor: systemView != System.disarmed
                    ? colorScheme.primary
                    : colorScheme.error,
                selectedForegroundColor: systemView != System.disarmed
                    ? colorScheme.onPrimary
                    : colorScheme.onError,
              ),
              segments: const <ButtonSegment<System>>[
                ButtonSegment<System>(
                  value: System.disarmed,
                  label: Text('Disarmed'),
                ),
                ButtonSegment<System>(value: System.home, label: Text('Home')),
                ButtonSegment<System>(value: System.away, label: Text('Away')),
              ],
              selected: <System>{systemView},
              onSelectionChanged: (Set<System> newSelection) {
                setState(() {
                  systemView = newSelection.first;
                  if (newSelection.first != System.disarmed) {
                    _pulseController.repeat(reverse: true);
                  } else {
                    _pulseController.stop();
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tokens = Theme.of(context).extension<SentientTokens>()!;

    final actions = [
      {
        'icon': Symbols.lock,
        'label': 'Unlock Front Door',
        'color': colorScheme.primary,
        'iconColor': colorScheme.onPrimary,
      },
      {
        'icon': Symbols.lightbulb,
        'label': 'Lights On',
        'color': colorScheme.tertiary,
        'iconColor': colorScheme.onTertiary,
      },
      {
        'icon': Symbols.thermostat,
        'label': 'Climate',
        'color': colorScheme.secondary,
        'iconColor': colorScheme.onSecondary,
      },
      {
        'icon': Symbols.music_note,
        'label': 'Music',
        'color': colorScheme.primary,
        'iconColor': colorScheme.onPrimary,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: tokens.spacingSm,
        mainAxisSpacing: tokens.spacingSm,
        childAspectRatio: 1.0,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return _buildQuickActionCard(
          context,
          icon: action['icon'] as IconData,
          label: action['label'] as String,
          color: action['color'] as Color,
          iconColor: action['iconColor'] as Color,
        );
      },
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required Color iconColor,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final tokens = Theme.of(context).extension<SentientTokens>()!;

    return Card(
      child: InkWell(
        onTap: () => _showQuickActionDialog(context, label),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              SizedBox(height: tokens.spacingMd),
              Text(
                label,
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCameras(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tokens = Theme.of(context).extension<SentientTokens>()!;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(tokens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Symbols.videocam, color: colorScheme.primary, size: 24),
                const SizedBox(width: 12),
                Text('Live Feeds', style: textTheme.titleMedium),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$_activeCameras Active',
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Symbols.keyboard_arrow_right),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _activeCameras,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return Container(
                    width: 160,
                    decoration: BoxDecoration(
                      color: tokens.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: colorScheme.outlineVariant,
                        width: 1,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            Symbols.videocam,
                            color: colorScheme.onSurfaceVariant.withValues(
                              alpha: 0.3,
                            ),
                            size: 32,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'CAM ${index + 1}',
                              style: const TextStyle(
                                fontSize: 8,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 4,
                          left: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Symbols.circle,
                                  size: 6,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Live',
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceStatus(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tokens = Theme.of(context).extension<SentientTokens>()!;

    final devices = [
      {
        'icon': Symbols.door_front,
        'label': 'Lock & Entries',
        'status': 'All Secured',
        'statusIcon': Symbols.check_circle,
        'isSecure': true,
      },
      {
        'icon': Symbols.motion_sensor_active,
        'label': 'Motion Sensors',
        'status':
            _deviceStatus['motionSensor1']! || _deviceStatus['motionSensor2']!
            ? 'Activity detected'
            : 'No activity',
        'statusIcon':
            _deviceStatus['motionSensor1']! || _deviceStatus['motionSensor2']!
            ? Symbols.warning
            : Symbols.check_circle,
        'isSecure':
            !(_deviceStatus['motionSensor1']! ||
                _deviceStatus['motionSensor2']!),
      },
      {
        'icon': Symbols.sensors,
        'label': 'Window Sensors',
        'status': 'All Closed',
        'statusIcon': Symbols.check_circle,
        'isSecure': true,
      },
      {
        'icon': Symbols.detector_smoke,
        'label': 'Smoke Alarms',
        'status': 'All Clear',
        'statusIcon': Symbols.check_circle,
        'isSecure': true,
      },
    ];

    return Column(
      children: devices.map((device) {
        final isSecure = device['isSecure'] as bool;
        return Card(
          margin: EdgeInsets.only(bottom: tokens.spacingXs),
          child: ListTile(
            onTap: () => _showDeviceDetail(context, device['label'] as String),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSecure ? colorScheme.primary : colorScheme.error,
                shape: BoxShape.circle,
              ),
              child: Icon(
                device['icon'] as IconData,
                color: isSecure ? colorScheme.onPrimary : colorScheme.onError,
                fill: 1,
              ),
            ),
            title: Text(device['label'] as String, style: textTheme.bodyLarge),
            subtitle: Text(
              device['status'] as String,
              style: textTheme.bodyMedium?.copyWith(
                color: isSecure
                    ? colorScheme.onSurfaceVariant
                    : colorScheme.error,
              ),
            ),
            trailing: Icon(
              device['statusIcon'] as IconData,
              color: isSecure ? Colors.green : colorScheme.error,
              size: 24,
            ),
          ),
        );
      }).toList(),
    );
  }
}
