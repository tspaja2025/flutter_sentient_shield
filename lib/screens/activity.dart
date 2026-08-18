import 'dart:async';
import 'package:flutter_sentient_shield/theme/sentient_shield_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_sentient_shield/shared/app_scaffold.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class Activity extends StatefulWidget {
  const Activity({super.key});

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  Timer? _updateTimer;
  String _selectedFilter = 'All Events';
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  final List<ActivityItem> _allActivities = [
    ActivityItem(
      id: '1',
      title: 'Access Granted',
      subtitle: 'Front Door Unlocked',
      description: 'Unlocked by John using Smart Lock PIN.',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      type: ActivityType.access,
      icon: Symbols.person,
      priority: ActivityPriority.high,
      isRead: false,
    ),
    ActivityItem(
      id: '2',
      title: 'System Status',
      subtitle: 'System Armed: Away Mode',
      description:
          'All exterior sensors active. Interior motion sensors armed.',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      type: ActivityType.system,
      icon: Symbols.shield,
      priority: ActivityPriority.medium,
      isRead: true,
    ),
    ActivityItem(
      id: '3',
      title: 'Motion Detected',
      subtitle: 'Backyard Camera',
      description: 'Unrecognized movement detected near the patio.',
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      type: ActivityType.alarm,
      icon: Symbols.motion_sensor_active,
      priority: ActivityPriority.critical,
      isRead: false,
    ),
    ActivityItem(
      id: '4',
      title: 'Doorbell Ring',
      subtitle: 'Front Door Camera',
      description: 'Visitor detected at front door.',
      timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      type: ActivityType.access,
      icon: Symbols.doorbell,
      priority: ActivityPriority.medium,
      isRead: true,
    ),
    ActivityItem(
      id: '5',
      title: 'Temperature Alert',
      subtitle: 'Basement Sensor',
      description: 'Temperature dropped below 5°C.',
      timestamp: DateTime.now().subtract(const Duration(hours: 12)),
      type: ActivityType.alarm,
      icon: Symbols.thermostat,
      priority: ActivityPriority.high,
      isRead: false,
    ),
    ActivityItem(
      id: '6',
      title: 'System Status',
      subtitle: 'System Armed: Home Mode',
      description: 'Scheduled routine \'Goodnight\' executed.',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
      type: ActivityType.system,
      icon: Symbols.home,
      priority: ActivityPriority.medium,
      isRead: true,
    ),
    ActivityItem(
      id: '7',
      title: 'Access Granted',
      subtitle: 'Front Door Unlocked',
      description: 'Unlocked by Sarah using Mobile App.',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
      type: ActivityType.access,
      icon: Symbols.person,
      priority: ActivityPriority.high,
      isRead: true,
    ),
    ActivityItem(
      id: '8',
      title: 'Camera Offline',
      subtitle: 'Garage Camera',
      description: 'Camera connection lost. Attempting to reconnect.',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
      type: ActivityType.system,
      icon: Symbols.videocam_off,
      priority: ActivityPriority.high,
      isRead: true,
    ),
    ActivityItem(
      id: '9',
      title: 'Motion Detected',
      subtitle: 'Living Room',
      description: 'Pet detected in living room.',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 10)),
      type: ActivityType.alarm,
      icon: Symbols.pets,
      priority: ActivityPriority.low,
      isRead: true,
    ),
    ActivityItem(
      id: '10',
      title: 'System Test',
      subtitle: 'All Devices',
      description:
          'Scheduled system health check completed. All devices online.',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 14)),
      type: ActivityType.system,
      icon: Symbols.check_circle,
      priority: ActivityPriority.low,
      isRead: true,
    ),
    ActivityItem(
      id: '11',
      title: 'Access Denied',
      subtitle: 'Side Gate',
      description: 'Invalid PIN attempt at side gate.',
      timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
      type: ActivityType.access,
      icon: Symbols.block,
      priority: ActivityPriority.critical,
      isRead: true,
    ),
    ActivityItem(
      id: '12',
      title: 'Firmware Update',
      subtitle: 'Smart Hub',
      description: 'Firmware updated to version 3.2.1',
      timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 12)),
      type: ActivityType.system,
      icon: Symbols.system_update,
      priority: ActivityPriority.medium,
      isRead: true,
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
    _updateTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        setState(() {
          if (DateTime.now().second % 5 == 0) {
            final newActivity = ActivityItem(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              title: 'New Event',
              subtitle: 'Sensor Triggered',
              description: 'New activity detected by your security system.',
              timestamp: DateTime.now(),
              type: ActivityType.alarm,
              icon: Symbols.notifications_active,
              priority: ActivityPriority.high,
              isRead: false,
            );
            _allActivities.insert(0, newActivity);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _updateTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  List<ActivityItem> get _filteredActivities {
    var activities = _allActivities;

    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      activities = activities
          .where(
            (item) =>
                item.title.toLowerCase().contains(query) ||
                item.subtitle.toLowerCase().contains(query) ||
                item.description.toLowerCase().contains(query),
          )
          .toList();
    }

    if (_selectedFilter != 'All Events') {
      final typeMap = {
        'Alarms': ActivityType.alarm,
        'Access': ActivityType.access,
        'System': ActivityType.system,
      };
      final filterType = typeMap[_selectedFilter];
      if (filterType != null) {
        activities = activities
            .where((item) => item.type == filterType)
            .toList();
      }
    }

    return activities;
  }

  List<ActivityItem> get _todayActivities => _filteredActivities
      .where(
        (item) => item.timestamp.isAfter(
          DateTime.now().subtract(const Duration(days: 1)),
        ),
      )
      .toList();

  List<ActivityItem> get _yesterdayActivities => _filteredActivities
      .where(
        (item) =>
            item.timestamp.isAfter(
              DateTime.now().subtract(const Duration(days: 2)),
            ) &&
            item.timestamp.isBefore(
              DateTime.now().subtract(const Duration(days: 1)),
            ),
      )
      .toList();

  List<ActivityItem> get _olderActivities => _filteredActivities
      .where(
        (item) => item.timestamp.isBefore(
          DateTime.now().subtract(const Duration(days: 2)),
        ),
      )
      .toList();

  int get _unreadCount => _allActivities.where((item) => !item.isRead).length;

  Future<void> _refreshActivities() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _isLoading = false;
      _allActivities.forEach((item) => item.isRead = true);
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Activities refreshed'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _showDeviceDetail(BuildContext context, ActivityItem item) {}
  void _showDeviceOptions(BuildContext context, ActivityItem item) {}

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tokens = Theme.of(context).extension<SentientTokens>()!;

    return AppScaffold(
      currentIndex: 3,
      child: RefreshIndicator(
        onRefresh: _refreshActivities,
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
                              Text('Activity', style: textTheme.headlineMedium),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    'Track all events and system activity',
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (_unreadCount > 0)
                          Container(
                            decoration: BoxDecoration(
                              color: colorScheme.error,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Symbols.notifications,
                                  color: colorScheme.onError,
                                  size: 16,
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  _unreadCount.toString(),
                                  style: textTheme.labelLarge?.copyWith(
                                    color: colorScheme.onError,
                                    fontSize: 14,
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
                    const SizedBox(height: 8),
                    _buildQuickStats(context),
                  ],
                ),
              ),
            ),
            _filteredActivities.isEmpty
                ? SliverToBoxAdapter(child: _buildEmptyState(context))
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index == 0 && _todayActivities.isNotEmpty) {
                          return _buildSectionHeader(context, 'Today');
                        } else if (index == _todayActivities.length &&
                            _yesterdayActivities.isNotEmpty) {
                          return _buildSectionHeader(context, 'Yesterday');
                        } else if (index ==
                                _todayActivities.length +
                                    _yesterdayActivities.length &&
                            _olderActivities.isNotEmpty) {
                          return _buildSectionHeader(context, 'Older');
                        }

                        int itemIndex;
                        if (index < _todayActivities.length) {
                          itemIndex = index;
                          final item = _todayActivities[itemIndex];
                          return _buildActivityCard(context, item);
                        } else if (index <
                            _todayActivities.length +
                                _yesterdayActivities.length) {
                          itemIndex = index - _todayActivities.length;
                          final item = _yesterdayActivities[itemIndex];
                          return _buildActivityCard(context, item);
                        } else {
                          itemIndex =
                              index -
                              _todayActivities.length -
                              _yesterdayActivities.length;
                          final item = _olderActivities[itemIndex];
                          return _buildActivityCard(context, item);
                        }
                      },
                      childCount:
                          _todayActivities.length +
                          _yesterdayActivities.length +
                          _olderActivities.length +
                          (_todayActivities.isNotEmpty ? 1 : 0) +
                          (_yesterdayActivities.isNotEmpty ? 1 : 0) +
                          (_olderActivities.isNotEmpty ? 1 : 0),
                    ),
                  ),
            SliverToBoxAdapter(child: _buildEndOfHistory(context)),
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
    final tokens = Theme.of(context).extension<SentientTokens>()!;
    return Container();
  }

  Widget _buildQuickStats(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(
                  Symbols.timeline,
                  color: colorScheme.onSurfaceVariant,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  '${_allActivities.length} total events',
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        // in progress
      ],
    );
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

  Widget _buildSectionHeader(BuildContext context, String title) {
    final textTheme = Theme.of(context).textTheme;
    final tokens = Theme.of(context).extension<SentientTokens>()!;
    return Padding(
      padding: EdgeInsets.only(
        top: tokens.spacingSm,
        bottom: tokens.spacingXs,
        left: tokens.spacingMd,
        right: tokens.spacingMd,
      ),
      child: Row(
        children: [
          Text(
            title,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          TextButton(onPressed: () {}, child: const Text('View All')),
        ],
      ),
    );
  }

  Widget _buildActivityCard(BuildContext context, ActivityItem item) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tokens = Theme.of(context).extension<SentientTokens>()!;
    return Padding(
      padding: EdgeInsets.only(
        left: tokens.spacingMd,
        right: tokens.spacingMd,
        bottom: tokens.spacingXs,
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _showDeviceDetail(context, item),
          onLongPress: () => _showDeviceOptions(context, item),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: _getPriorityColor(item.priority),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item.icon,
                        color: _getPriorityColor(item.priority),
                        fill: 1,
                        size: 24,
                      ),
                    ),
                    if (!item.isRead)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorScheme.surface,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            _formatTime(item.timestamp),
                            style: textTheme.labelMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.description,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 4,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _getPriorityColor(item.priority),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEndOfHistory(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tokens = Theme.of(context).extension<SentientTokens>()!;
    return Padding(
      padding: EdgeInsets.all(tokens.spacingLg),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Opacity(
                opacity: _animationController.value,
                child: Icon(
                  Symbols.history,
                  color: colorScheme.onSurfaceVariant,
                  size: 32,
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Text(
            'End of recent history',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

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

  Color _getPriorityColor(ActivityPriority priority) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (priority) {
      case ActivityPriority.critical:
        return colorScheme.error;
      case ActivityPriority.high:
        return colorScheme.tertiary;
      case ActivityPriority.medium:
        return colorScheme.primary;
      case ActivityPriority.low:
        return colorScheme.onSurfaceVariant;
    }
  }
}

class ActivityDetailSheet extends StatefulWidget {
  const ActivityDetailSheet({super.key});

  @override
  State<ActivityDetailSheet> createState() => _ActivityDetailSheetState();
}

class _ActivityDetailSheetState extends State<ActivityDetailSheet> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tokens = Theme.of(context).extension<SentientTokens>()!;
    // TODO: implement build
    throw UnimplementedError();
  }
}

enum ActivityType { access, alarm, system }

enum ActivityPriority { critical, high, medium, low }

class ActivityItem {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final DateTime timestamp;
  final ActivityType type;
  final IconData icon;
  final ActivityPriority priority;
  bool isRead;

  ActivityItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.timestamp,
    required this.type,
    required this.icon,
    required this.priority,
    this.isRead = false,
  });
}
