import 'dart:async';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_sentient_shield/shared/app_scaffold.dart';
import 'package:flutter_sentient_shield/theme/sentient_shield_theme.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class Devices extends StatefulWidget {
  const Devices({super.key});

  @override
  State<Devices> createState() => _DevicesState();
}

class _DevicesState extends State<Devices> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  Timer? _statusUpdateTimer;
  String _selectedCategory = 'All';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  final List<Device> _devices = [
    Device(
      id: 'front_door_lock',
      name: 'Front Door',
      type: DeviceType.lock,
      status: DeviceStatus.secure,
      statusText: 'Locked',
      icon: Symbols.lock,
      location: 'Entryway',
      batteryLevel: 85,
      isOnline: true,
      lastActivity: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    Device(
      id: 'side_gate_lock',
      name: 'Side Gate',
      type: DeviceType.lock,
      status: DeviceStatus.warning,
      statusText: 'Unlocked',
      icon: Symbols.lock_open,
      location: 'Backyard',
      batteryLevel: 45,
      isOnline: true,
      lastActivity: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
    Device(
      id: 'garage_door_lock',
      name: 'Garage Door',
      type: DeviceType.lock,
      status: DeviceStatus.secure,
      statusText: 'Locked',
      icon: Symbols.garage,
      location: 'Garage',
      batteryLevel: 92,
      isOnline: true,
      lastActivity: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    Device(
      id: 'living_room_window',
      name: 'Living Room Window',
      type: DeviceType.sensor,
      status: DeviceStatus.alert,
      statusText: 'Open',
      icon: Symbols.sensors,
      location: 'Living Room',
      batteryLevel: 78,
      isOnline: true,
      lastActivity: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
    Device(
      id: 'hallway_motion',
      name: 'Hallway Motion',
      type: DeviceType.sensor,
      status: DeviceStatus.active,
      statusText: 'Active',
      icon: Symbols.motion_sensor_active,
      location: 'Hallway',
      batteryLevel: 65,
      isOnline: true,
      lastActivity: DateTime.now().subtract(const Duration(seconds: 30)),
    ),
    Device(
      id: 'kitchen_window',
      name: 'Kitchen Window',
      type: DeviceType.sensor,
      status: DeviceStatus.secure,
      statusText: 'Closed',
      icon: Symbols.sensors,
      location: 'Kitchen',
      batteryLevel: 90,
      isOnline: true,
      lastActivity: DateTime.now().subtract(const Duration(minutes: 20)),
    ),
    Device(
      id: 'basement_door_sensor',
      name: 'Basement Door',
      type: DeviceType.sensor,
      status: DeviceStatus.secure,
      statusText: 'Closed',
      icon: Symbols.sensors,
      location: 'Basement',
      batteryLevel: 23,
      isOnline: false,
      lastActivity: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    Device(
      id: 'main_siren',
      name: 'Main Siren',
      type: DeviceType.alarm,
      status: DeviceStatus.secure,
      statusText: 'Armed',
      icon: Symbols.alarm,
      location: 'Main Floor',
      batteryLevel: 100,
      isOnline: true,
      lastActivity: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    Device(
      id: 'backup_siren',
      name: 'Backup Siren',
      type: DeviceType.alarm,
      status: DeviceStatus.secure,
      statusText: 'Armed',
      icon: Symbols.alarm,
      location: 'Basement',
      batteryLevel: 100,
      isOnline: true,
      lastActivity: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    Device(
      id: 'smoke_detector',
      name: 'Smoke Detector',
      type: DeviceType.alarm,
      status: DeviceStatus.secure,
      statusText: 'Clear',
      icon: Symbols.detector_smoke,
      location: 'Kitchen',
      batteryLevel: 88,
      isOnline: true,
      lastActivity: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _statusUpdateTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() {
          _devices.forEach((device) {
            if (device.type == DeviceType.sensor && device.isOnline) {
              if (DateTime.now().second % 5 == 0) {
                device.status = DeviceStatus.active;
                device.statusText = 'Active';
              } else if (DateTime.now().second % 7 == 0) {
                device.status = DeviceStatus.alert;
                device.statusText = 'Alert';
              } else {
                device.status = DeviceStatus.secure;
                device.statusText = 'Clear';
              }
            }
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _statusUpdateTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  List<Device> get _filteredDevices {
    var devices = _devices.where((d) => d.isOnline).toList();

    if (_selectedCategory != 'All') {
      final type = _selectedCategory.toLowerCase();
      if (type == 'locks') {
        devices = devices.where((d) => d.type == DeviceType.lock).toList();
      } else if (type == 'sensors') {
        devices = devices.where((d) => d.type == DeviceType.sensor).toList();
      } else if (type == 'alarms') {
        devices = devices.where((d) => d.type == DeviceType.alarm).toList();
      }
    }

    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      devices = devices
          .where(
            (d) =>
                d.name.toLowerCase().contains(query) ||
                d.location.toLowerCase().contains(query) ||
                d.statusText.toLowerCase().contains(query),
          )
          .toList();
    }

    return devices;
  }

  int get _alertCount => _devices
      .where(
        (d) =>
            d.status == DeviceStatus.alert || d.status == DeviceStatus.warning,
      )
      .length;

  int get _onlineCount => _devices.where((d) => d.isOnline).length;

  Future<void> _refreshDevices() async {
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _devices.forEach((device) {
        device.isOnline = true;
        if (device.type != DeviceType.lock) {
          device.status = DeviceStatus.secure;
          device.statusText = 'Clear';
        }
      });
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Devices refreshed'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _showDeviceDetail(BuildContext context, Device device) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DeviceDetailSheet(device: device),
    );
  }

  void _showDeviceOptions(BuildContext context, Device device) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(device.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {
                Navigator.pop(context);
                _showDeviceDetail(context, device);
              },
              leading: const Icon(Symbols.settings),
              title: const Text('Device settings'),
            ),
            ListTile(
              onTap: () => Navigator.pop(context),
              leading: const Icon(Symbols.history),
              title: const Text('Activity History'),
            ),
            ListTile(
              onTap: () {
                setState(() {
                  device.isOnline = !device.isOnline;
                });
                Navigator.pop(context);
              },
              leading: Icon(
                device.isOnline
                    ? Symbols.power_off
                    : Symbols.power_settings_new,
                color: device.isOnline ? Colors.red : Colors.green,
              ),
              title: Text(
                device.isOnline ? 'Disconnect device' : 'Reconnect device',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleDevice(Device device) {
    setState(() {
      if (device.status == DeviceStatus.secure) {
        device.status = DeviceStatus.warning;
        device.statusText = 'Disabled';
      } else if (device.status == DeviceStatus.warning) {
        device.status = DeviceStatus.secure;
        device.statusText = 'Locked';
      }
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${device.name} ${device.statusText}'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showAddDeviceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Device'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {
                Navigator.pop(context);
                _showAddDeviceForm(context, 'Smart Lock');
              },
              leading: const Icon(Symbols.lock),
              title: const Text('Smart Lock'),
              subtitle: const Text('Add a new door lock'),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                _showAddDeviceForm(context, 'Sensor');
              },
              leading: const Icon(Symbols.sensors),
              title: const Text('Sensor'),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                _showAddDeviceForm(context, 'Alarm');
              },
              leading: const Icon(Symbols.alarm),
              title: const Text('Alarm'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showAddDeviceForm(BuildContext context, String deviceType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add $deviceType'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Device Name',
                hintText: 'Enter device name',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Location',
                hintText: 'Where is this device?',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Device added successfully'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Add Device'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tokens = Theme.of(context).extension<SentientTokens>()!;

    return AppScaffold(
      currentIndex: 2,
      child: RefreshIndicator(
        onRefresh: _refreshDevices,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
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
                              Text('Devices', style: textTheme.headlineMedium),
                              const SizedBox(height: 4),
                              Text(
                                'Manage and monitor your security hardware.',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: _alertCount > 0
                                      ? colorScheme.error
                                      : Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '$_onlineCount Online',
                                style: textTheme.labelMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildSearchBar(context),
                    const SizedBox(height: 12),
                    _buildCategoryFilters(context),
                  ],
                ),
              ),
            ),
            _filteredDevices.isEmpty
                ? SliverToBoxAdapter(child: _buildEmptyState(context))
                : SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final device = _filteredDevices[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          left: tokens.spacingMd,
                          right: tokens.spacingMd,
                          bottom: tokens.spacingXs,
                        ),
                        child: _buildDeviceCard(context, device),
                      );
                    }, childCount: _filteredDevices.length),
                  ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(tokens.spacingMd),
                child: _buildAddDeviceButton(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant, width: 1),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() {}),
        decoration: InputDecoration(
          prefixIcon: Icon(Symbols.search, color: colorScheme.onSurfaceVariant),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                    });
                  },
                  icon: Icon(Symbols.search),
                  color: colorScheme.onSurfaceVariant,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          hintStyle: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          hintText: 'Search devices...',
        ),
        style: textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildCategoryFilters(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final categories = ['All', 'Locks', 'Sensors', 'Alarms'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          final isSelected = _selectedCategory == category;
          int count = 0;
          if (category == 'All') {
            count = _onlineCount;
          } else {
            final type = category.toLowerCase();
            count = _devices
                .where(
                  (d) =>
                      d.type.toString().split('.').last.toLowerCase() == type &&
                      d.isOnline,
                )
                .length;
          }
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              label: Text(category),
              avatar: category != 'All'
                  ? Icon(
                      _getCategoryIcon(category),
                      size: 16,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    )
                  : null,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = selected ? category : 'All';
                });
              },
              backgroundColor: colorScheme.surfaceContainerLow,
              selectedColor: colorScheme.primaryContainer,
              labelStyle: textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'locks':
        return Symbols.lock;
      case 'sensors':
        return Symbols.sensors;
      case 'alarms':
        return Symbols.alarm;
      default:
        return Symbols.devices;
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tokens = Theme.of(context).extension<SentientTokens>()!;

    return Padding(
      padding: EdgeInsets.all(tokens.spacingXl),
      child: Column(
        children: [
          Icon(
            Symbols.devices_off,
            color: colorScheme.onSurfaceVariant,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text('No devices found', style: textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or search terms',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceCard(BuildContext context, Device device) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    Color statusColor;
    IconData statusIcon;

    switch (device.status) {
      case DeviceStatus.secure:
        statusColor = Colors.green;
        statusIcon = Symbols.check_circle;
        break;
      case DeviceStatus.warning:
        statusColor = Colors.orange;
        statusIcon = Symbols.warning;
        break;
      case DeviceStatus.alert:
        statusColor = colorScheme.error;
        statusIcon = Symbols.check_circle;
        break;
      case DeviceStatus.active:
        statusColor = colorScheme.primary;
        statusIcon = Symbols.power;
        break;
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showDeviceDetail(context, device),
        onLongPress: () => _showDeviceOptions(context, device),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: device.status == DeviceStatus.alert
                      ? colorScheme.error
                      : colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  device.icon,
                  color: device.status == DeviceStatus.alert
                      ? colorScheme.onError
                      : colorScheme.onPrimaryContainer,
                  fill: 1,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.name,
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          device.location,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          device.statusText,
                          style: textTheme.bodyMedium?.copyWith(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildBatteryIndicator(device.batteryLevel),
                      const SizedBox(width: 8),
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: device.isOnline
                                  ? (device.status == DeviceStatus.alert
                                        ? colorScheme.error
                                        : Colors.green)
                                  : Colors.grey,
                              shape: BoxShape.circle,
                              boxShadow: device.isOnline
                                  ? [
                                      BoxShadow(
                                        color:
                                            (device.status == DeviceStatus.alert
                                            ? colorScheme.error
                                            : Colors.green),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : [],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => _showDeviceOptions(context, device),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          Symbols.settings,
                          color: colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => _toggleDevice(device),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          device.status == DeviceStatus.secure
                              ? Symbols.power_settings_new
                              : Symbols.power_off,
                          color: device.status == DeviceStatus.secure
                              ? Colors.green
                              : colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBatteryIndicator(int batteryLevel) {
    final textTheme = Theme.of(context).textTheme;
    IconData icon;
    Color color;

    if (batteryLevel >= 80) {
      icon = Symbols.battery_full;
      color = Colors.green;
    } else if (batteryLevel >= 60) {
      icon = Symbols.battery_5_bar;
      color = Colors.green;
    } else if (batteryLevel >= 40) {
      icon = Symbols.battery_4_bar;
      color = Colors.orange;
    } else if (batteryLevel >= 20) {
      icon = Symbols.battery_3_bar;
      color = Colors.orange;
    } else {
      icon = Symbols.battery_2_bar;
      color = Colors.red;
    }
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 2),
        Text(
          '$batteryLevel%',
          style: textTheme.labelMedium?.copyWith(color: color, fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildAddDeviceButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FilledButton.icon(
      onPressed: () => _showAddDeviceDialog(context),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      icon: const Icon(Symbols.add, fill: 1),
      label: const Text('Add New Device'),
    );
  }
}

class DeviceDetailSheet extends StatefulWidget {
  final Device device;

  const DeviceDetailSheet({super.key, required this.device});

  @override
  State<DeviceDetailSheet> createState() => _DeviceDetailSheetState();
}

class _DeviceDetailSheetState extends State<DeviceDetailSheet> {
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.device.icon,
                  color: colorScheme.primary,
                  fill: 1,
                  size: 32,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.device.name, style: textTheme.headlineSmall),
                    Text(
                      widget.device.location,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Symbols.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text('Status'),
                      Text(
                        widget.device.statusText,
                        style: textTheme.titleMedium?.copyWith(
                          color: widget.device.status == DeviceStatus.alert
                              ? colorScheme.error
                              : widget.device.status == DeviceStatus.warning
                              ? Colors.orange
                              : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Text('Battery'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildBatteryIndicator(widget.device.batteryLevel),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Text('Last Active'),
                      Text(
                        _formatTime(widget.device.lastActivity),
                        style: textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Symbols.edit),
                  label: const Text('Settings'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Symbols.history),
                  label: const Text('History'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBatteryIndicator(int batteryLevel) {
    final textTheme = Theme.of(context).textTheme;
    IconData icon;
    Color color;

    if (batteryLevel >= 80) {
      icon = Symbols.battery_full;
      color = Colors.green;
    } else if (batteryLevel >= 60) {
      icon = Symbols.battery_5_bar;
      color = Colors.green;
    } else if (batteryLevel >= 40) {
      icon = Symbols.battery_4_bar;
      color = Colors.orange;
    } else if (batteryLevel >= 20) {
      icon = Symbols.battery_3_bar;
      color = Colors.orange;
    } else {
      icon = Symbols.battery_2_bar;
      color = Colors.red;
    }
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 2),
        Text(
          '$batteryLevel%',
          style: textTheme.labelMedium?.copyWith(color: color, fontSize: 10),
        ),
      ],
    );
  }
}

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
