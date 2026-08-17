import 'dart:async';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_sentient_shield/shared/app_scaffold.dart';
import 'package:flutter_sentient_shield/theme/sentient_shield_theme.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class Cameras extends StatefulWidget {
  const Cameras({super.key});

  @override
  State<Cameras> createState() => _CamerasState();
}

class _CamerasState extends State<Cameras> with SingleTickerProviderStateMixin {
  late AnimationController _recordingIndicatorController;
  late Animation<double> _pulseAnimation;
  Timer? _statusUpdateTimer;
  String _selectedFilter = 'All';
  bool _isGridView = false;
  int _selectedCameraIndex = 0;

  final List<Camera> _cameras = [
    Camera(
      id: 'front_door',
      name: 'Front Door',
      image: 'images/front_door.png',
      location: 'Entryway',
      status: CameraStatus.motion,
      lastActivity: 'Motion detected 2m ago',
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      isFavorite: true,
    ),
    Camera(
      id: 'backyard',
      name: 'Backyard',
      image: 'images/backyard.png',
      location: 'Outdoor',
      status: CameraStatus.clear,
      lastActivity: 'All Clear',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      isFavorite: false,
    ),
    Camera(
      id: 'garage',
      name: 'Garage',
      image: 'images/garage.png',
      location: 'Indoor',
      status: CameraStatus.clear,
      lastActivity: 'All clear',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      isFavorite: false,
    ),
    Camera(
      id: 'living_room',
      name: 'Living Room',
      image: 'images/living_room.png',
      location: 'Indoor',
      status: CameraStatus.person,
      lastActivity: 'Family member present',
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
      isFavorite: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _recordingIndicatorController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _recordingIndicatorController,
        curve: Curves.easeInOut,
      ),
    );
    _statusUpdateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _cameras.forEach((camera) {
            if (camera.status != CameraStatus.offline) {
              if (DateTime.now().second % 7 == 0) {
                camera.status = CameraStatus.motion;
                camera.lastActivity = 'Motion detected just now';
                camera.timestamp = DateTime.now();
              } else if (DateTime.now().second % 13 == 0) {
                camera.status = CameraStatus.person;
                camera.lastActivity = 'Person detected';
                camera.timestamp = DateTime.now();
              } else {
                camera.status = CameraStatus.clear;
                camera.lastActivity = 'All clear';
                camera.timestamp = DateTime.now();
              }
            }
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _recordingIndicatorController.dispose();
    _statusUpdateTimer?.cancel();
    super.dispose();
  }

  List<Camera> get _filteredCameras {
    if (_selectedFilter == 'All') return _cameras;
    if (_selectedFilter == 'Favorites') {
      return _cameras.where((c) => c.isFavorite).toList();
    }
    if (_selectedFilter == 'Motion') {
      return _cameras.where((c) => c.status == CameraStatus.motion).toList();
    }
    if (_selectedFilter == 'Online') {
      return _cameras.where((c) => c.status != CameraStatus.offline).toList();
    }
    return _cameras;
  }

  int get _onlineCount =>
      _cameras.where((c) => c.status != CameraStatus.offline).length;

  Future<void> _refreshCameras() async {
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _cameras.forEach((camera) {
        if (camera.status != CameraStatus.offline) {
          camera.status = CameraStatus.clear;
          camera.lastActivity = 'All clear';
          camera.timestamp = DateTime.now();
        }
      });
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cameras refreshed'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _showCameraDetail(BuildContext context, Camera camera) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CameraDetailSheet(camera: camera),
    );
  }

  void _showCameraOptions(BuildContext context, Camera camera) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(camera.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.star),
              title: Text(
                camera.isFavorite
                    ? 'Remove from favorites'
                    : 'Add to favorites',
              ),
              onTap: () {
                setState(() {
                  camera.isFavorite = !camera.isFavorite;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Camera settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('View history'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFullscreenPreview(BuildContext context, Camera camera) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 400,
                    width: double.infinity,
                    color: Colors.black,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Symbols.videocam,
                            size: 48,
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            camera.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Live Preview',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.black.withValues(alpha: 0.8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.camera, color: Colors.white),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(
                            Icons.record_voice_over,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(
                            Icons.screenshot,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCloudRecordings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cloud Recordings'),
        content: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.video_library),
                title: const Text('Today\'s recordings'),
                subtitle: const Text('12 events recorded'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Past recordings'),
                subtitle: const Text('View archive'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.download),
                title: const Text('Download recordings'),
                subtitle: const Text('Select date range'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tokens = Theme.of(context).extension<SentientTokens>()!;

    return AppScaffold(
      currentIndex: 1,
      child: RefreshIndicator(
        onRefresh: _refreshCameras,
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
                              Text(
                                'Live Feeds',
                                style: textTheme.headlineMedium,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    '$_onlineCount cameras online',
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primaryContainer
                                          .withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${_cameras.length - _onlineCount} offline',
                                      style: textTheme.labelMedium?.copyWith(
                                        color: colorScheme.error,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // View toggle
                        Container(
                          decoration: BoxDecoration(
                            color: tokens.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              _buildViewToggle(
                                icon: Symbols.list_alt,
                                isSelected: !_isGridView,
                                onTap: () =>
                                    setState(() => _isGridView = false),
                              ),
                              _buildViewToggle(
                                icon: Symbols.grid_view,
                                isSelected: _isGridView,
                                onTap: () => setState(() => _isGridView = true),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Filter chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('All', Symbols.camera_alt),
                          _buildFilterChip('Favorites', Symbols.star),
                          _buildFilterChip(
                            'Motion',
                            Symbols.notifications_active,
                          ),
                          _buildFilterChip('Online', Symbols.wifi),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Camera grid/list
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: tokens.spacingMd),
              sliver: _isGridView ? _buildCameraGrid() : _buildCameraList(),
            ),

            // Bottom button
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(tokens.spacingMd),
                child: _buildCloudRecordingsButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewToggle({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primaryContainer : null,
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          color: isSelected
              ? colorScheme.primary
              : colorScheme.onSurfaceVariant,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = selected ? label : 'All';
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
        label: Text(label),
        avatar: Icon(
          icon,
          color: isSelected
              ? colorScheme.primary
              : colorScheme.onSurfaceVariant,
          size: 16,
        ),
      ),
    );
  }

  SliverGrid _buildCameraGrid() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final camera = _filteredCameras[index];
        return _buildCameraCard(context, camera, compact: true);
      }, childCount: _filteredCameras.length),
    );
  }

  SliverList _buildCameraList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final camera = _filteredCameras[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildCameraCard(context, camera, compact: false),
        );
      }, childCount: _filteredCameras.length),
    );
  }

  Widget _buildCameraCard(
    BuildContext context,
    Camera camera, {
    required bool compact,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tokens = Theme.of(context).extension<SentientTokens>()!;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showCameraDetail(context, camera),
        onLongPress: () => _showCameraOptions(context, camera),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Container(
                  height: compact ? 120 : 180,
                  decoration: BoxDecoration(
                    color: tokens.surfaceContainerLow,
                    image: camera.status == CameraStatus.offline
                        ? null
                        : DecorationImage(
                            image: AssetImage(camera.image),
                            fit: BoxFit.cover,
                          ),
                  ),
                  child: camera.status == CameraStatus.offline
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Symbols.videocam_off,
                                size: 32,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Offline',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        )
                      : null,
                ),
                if (camera.status != CameraStatus.offline)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'LIVE',
                                style: textTheme.labelLarge?.copyWith(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                if (camera.status != CameraStatus.offline)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _formatTime(camera.timestamp),
                        style: textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: _buildStatusBadge(camera.status),
                ),
                Positioned(
                  top: 8,
                  right: camera.status == CameraStatus.offline ? 8 : 60,
                  child: IconButton(
                    icon: Icon(
                      camera.isFavorite ? Icons.star : Icons.star_border,
                      color: camera.isFavorite ? Colors.amber : Colors.white,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        camera.isFavorite = !camera.isFavorite;
                      });
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Symbols.fullscreen,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => _showFullscreenPreview(context, camera),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(tokens.spacingSm),
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
                              camera.name,
                              style: textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (!compact) ...[
                              Text(
                                camera.location,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Text(
                        camera.lastActivity,
                        style: textTheme.bodyMedium?.copyWith(
                          color: camera.status == CameraStatus.offline
                              ? colorScheme.error
                              : camera.status == CameraStatus.motion
                              ? colorScheme.tertiary
                              : colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  if (compact) ...[
                    const SizedBox(height: 4),
                    Text(
                      camera.lastActivity,
                      style: textTheme.bodyMedium?.copyWith(
                        color: camera.status == CameraStatus.offline
                            ? colorScheme.error
                            : camera.status == CameraStatus.motion
                            ? colorScheme.tertiary
                            : colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(CameraStatus status) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case CameraStatus.motion:
        bgColor = colorScheme.tertiaryContainer;
        textColor = colorScheme.onTertiaryContainer;
        label = 'Motion';
        break;
      case CameraStatus.person:
        bgColor = colorScheme.primaryContainer;
        textColor = colorScheme.onPrimaryContainer;
        label = 'Person';
        break;
      case CameraStatus.clear:
        bgColor = Colors.green.withValues(alpha: 0.7);
        textColor = Colors.white;
        label = 'Clear';
        break;
      case CameraStatus.offline:
        bgColor = Colors.grey.withValues(alpha: 0.7);
        textColor = Colors.white;
        label = 'Offline';
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text(
        label,
        style: textTheme.labelLarge?.copyWith(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildCloudRecordingsButton() {
    return FilledButton.icon(
      onPressed: () => _showCloudRecordings(context),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: const Icon(Symbols.cloud),
      label: const Text('View Cloud Recordings'),
    );
  }
}

class CameraDetailSheet extends StatefulWidget {
  final Camera camera;

  const CameraDetailSheet({super.key, required this.camera});

  @override
  State<CameraDetailSheet> createState() => _CameraDetailSheetState();
}

class _CameraDetailSheetState extends State<CameraDetailSheet> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.camera.name, style: textTheme.headlineSmall),
                    Text(
                      widget.camera.location,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  widget.camera.isFavorite ? Icons.star : Icons.star_border,
                  color: widget.camera.isFavorite ? Colors.amber : null,
                ),
                onPressed: () {
                  setState(() {
                    widget.camera.isFavorite = !widget.camera.isFavorite;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Symbols.videocam,
                    size: 48,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Live Feed',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text('Status'),
                    Text(
                      widget.camera.status.toString().split('.').last,
                      style: textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text('Last Activity'),
                    Text(
                      widget.camera.lastActivity,
                      style: textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.screenshot),
                  label: const Text('Snapshot'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.record_voice_over),
                  label: const Text('Record'),
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
}

enum CameraStatus { motion, person, clear, offline }

class Camera {
  final String id;
  final String name;
  final String image;
  final String location;
  CameraStatus status;
  String lastActivity;
  DateTime timestamp;
  bool isFavorite;

  Camera({
    required this.id,
    required this.name,
    required this.image,
    required this.location,
    required this.status,
    required this.lastActivity,
    required this.timestamp,
    this.isFavorite = false,
  });
}
