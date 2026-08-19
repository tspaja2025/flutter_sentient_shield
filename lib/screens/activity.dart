import 'dart:async';
import 'package:flutter_sentient_shield/models/activity_model.dart';
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

  int get _unreadCount => _allActivities.where((item) => !item.isRead).length;

  List<MapEntry<String, List<ActivityItem>>> get _activitySections {
    final activities = _filteredActivities;
    final now = DateTime.now();

    final today = activities
        .where(
          (item) =>
              item.timestamp.isAfter(now.subtract(const Duration(days: 1))),
        )
        .toList();
    final yesterday = activities
        .where(
          (item) =>
              item.timestamp.isAfter(now.subtract(const Duration(days: 2))) &&
              item.timestamp.isBefore(now.subtract(const Duration(days: 1))),
        )
        .toList();
    final older = activities
        .where(
          (item) => item.timestamp.isBefore(
            DateTime.now().subtract(const Duration(days: 2)),
          ),
        )
        .toList();

    return [
      if (today.isNotEmpty) MapEntry('Today', today),
      if (yesterday.isNotEmpty) MapEntry('Yesterday', yesterday),
      if (older.isNotEmpty) MapEntry('Older', older),
    ];
  }

  Future<void> _refreshActivities() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      for (final item in _allActivities) {
        item.isRead = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Activities refreshed'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showActivityDetail(BuildContext context, ActivityItem item) {
    setState(() => item.isRead = true);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ActivityDetailSheet(activity: item),
    );
  }

  void _showActivityOptions(BuildContext context, ActivityItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Activity Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {
                setState(() => item.isRead = !item.isRead);
                Navigator.pop(context);
              },
              leading: Icon(
                item.isRead
                    ? Symbols.mark_email_unread
                    : Symbols.mark_email_read,
              ),
              title: Text(item.isRead ? 'Mark as unread' : 'Mark as read'),
            ),
            ListTile(
              onTap: () => Navigator.pop(context),
              leading: const Icon(Symbols.share),
              title: const Text('Share Event'),
            ),
            if (item.type == ActivityType.alarm)
              ListTile(
                onTap: () => Navigator.pop(context),
                leading: const Icon(Symbols.snooze),
                title: Text('Snooze alert'),
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tokens = Theme.of(context).extension<SentientTokens>()!;
    final sections = _activitySections;
    final itemCount = sections.fold<int>(
      0,
      (count, section) => count + section.value.length + 1,
    );

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
                    delegate: SliverChildBuilderDelegate((context, index) {
                      int currentIndex = 0;
                      for (final section in sections) {
                        final headerIndex = currentIndex;
                        final itemsStartIndex = currentIndex + 1;
                        final itemsEndIndex =
                            itemsStartIndex + section.value.length;

                        if (index == headerIndex) {
                          return _buildSectionHeader(context, section.key);
                        }

                        if (index >= itemsStartIndex && index < itemsEndIndex) {
                          final item = section.value[index - itemsStartIndex];

                          return _buildActivityCard(context, item);
                        }

                        currentIndex = itemsEndIndex;
                      }
                      return const SizedBox.shrink();
                    }, childCount: itemCount),
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
    final filters = ['All Events', 'Alarms', 'Access', 'System'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          int count = 0;
          if (filter == 'All Events') {
            count = _allActivities.length;
          } else {
            final type = filter.toLowerCase();
            count = _allActivities
                .where(
                  (item) =>
                      item.type.toString().split('.').last.toLowerCase() ==
                      type,
                )
                .length;
          }
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              label: Text(filter),
              avatar: filter != 'All events'
                  ? Icon(
                      _getFilterIcon(filter),
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                      size: 16,
                    )
                  : null,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = selected ? filter : 'All Events';
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
                      : colorScheme.outlineVariant,
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
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _unreadCount > 0 ? colorScheme.error : Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _unreadCount > 0 ? '$_unreadCount unread' : 'All read',
                  style: textTheme.labelMedium?.copyWith(
                    color: _unreadCount > 0 ? colorScheme.error : Colors.green,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
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
          onTap: () => _showActivityDetail(context, item),
          onLongPress: () => _showActivityOptions(context, item),
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

  IconData _getFilterIcon(String filter) {
    switch (filter) {
      case 'Alarms':
        return Symbols.warning;
      case 'Access':
        return Symbols.key;
      case 'System':
        return Symbols.security;
      default:
        return Symbols.list_alt;
    }
  }
}

class ActivityDetailSheet extends StatefulWidget {
  final ActivityItem activity;

  const ActivityDetailSheet({super.key, required this.activity});

  @override
  State<ActivityDetailSheet> createState() => _ActivityDetailSheetState();
}

class _ActivityDetailSheetState extends State<ActivityDetailSheet> {
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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getPriorityColor(widget.activity.priority),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.activity.icon,
                  color: _getPriorityColor(widget.activity.priority),
                  size: 28,
                  fill: 1,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.activity.title, style: textTheme.headlineSmall),
                    Text(
                      widget.activity.subtitle,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Event Details',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(widget.activity.description, style: textTheme.bodyMedium),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Time',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            _formatDateTime(widget.activity.timestamp),
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Priority',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            widget.activity.priority
                                .toString()
                                .split('.')
                                .last
                                .toUpperCase(),
                            style: textTheme.bodyMedium?.copyWith(
                              color: _getPriorityColor(
                                widget.activity.priority,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Type',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            widget.activity.type
                                .toString()
                                .split('.')
                                .last
                                .toUpperCase(),
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Status',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: widget.activity.isRead
                                      ? Colors.green
                                      : colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.activity.isRead ? 'Read' : 'Unread',
                                style: textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
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
                  icon: const Icon(Symbols.share),
                  label: const Text('Share'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      widget.activity.isRead = !widget.activity.isRead;
                    });
                  },
                  icon: Icon(
                    widget.activity.isRead
                        ? Symbols.mark_email_unread
                        : Symbols.mark_email_read,
                  ),
                  label: Text(
                    widget.activity.isRead ? 'Mark unread' : 'Mark read',
                  ),
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

  String _formatDateTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} '
        '${time.month}/${time.day}/${time.year}';
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
