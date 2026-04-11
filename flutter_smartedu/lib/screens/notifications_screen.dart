import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/theme_provider.dart';
import '../services/mock_data_service.dart';
import '../models/notification_model.dart';
import '../utils/app_theme.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final MockDataService _mockData = MockDataService();
  List<AppNotification> _notifications = [];
  bool _showUnreadOnly = false;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    setState(() {
      _notifications = _mockData.getNotifications();
    });
  }

  List<AppNotification> get _filteredNotifications {
    if (_showUnreadOnly) {
      return _notifications.where((n) => !n.isRead).toList();
    }
    return _notifications;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDark ? AppColors.primaryDark : AppColors.primaryLight;
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
          primaryColor,
          isDark ? AppColors.secondaryDark : AppColors.secondaryLight
        ]))),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return IconButton(
                icon: Icon(themeProvider.isDarkMode
                    ? Icons.light_mode
                    : Icons.dark_mode),
                onPressed: () => themeProvider.toggleTheme(),
              );
            },
          ),
          IconButton(
            icon: Icon(_showUnreadOnly
                ? Icons.notifications_active
                : Icons.notifications),
            onPressed: () => setState(() => _showUnreadOnly = !_showUnreadOnly),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadNotifications(),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: isDark ? AppColors.surfaceDark : Colors.grey.shade100,
              child: Row(
                children: [
                  Icon(Icons.circle, color: primaryColor, size: 12),
                  const SizedBox(width: 8),
                  Text('$unreadCount unread notifications',
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  const Spacer(),
                  if (unreadCount > 0)
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _notifications = _notifications
                              .map((n) => AppNotification(
                                    id: n.id,
                                    userId: n.userId,
                                    role: n.role,
                                    title: n.title,
                                    message: n.message,
                                    type: n.type,
                                    read: true,
                                    createdAt: n.createdAt,
                                  ))
                              .toList();
                        });
                      },
                      icon: const Icon(Icons.done_all, size: 18),
                      label: const Text('Mark all read'),
                    ),
                ],
              ),
            ),
            Expanded(
              child: _filteredNotifications.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = _filteredNotifications[index];
                        return _buildNotificationCard(
                            notification, primaryColor, isDark);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
      AppNotification notification, Color primaryColor, bool isDark) {
    final timeAgo = _getTimeAgo(notification.createdAt);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        setState(() => _notifications.remove(notification));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: const Text('Notification dismissed'),
              action: SnackBarAction(
                  label: 'UNDO', onPressed: () => _loadNotifications())),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: notification.read
                ? Colors.transparent
                : primaryColor.withOpacity(0.3),
            width: notification.read ? 0 : 1.5,
          ),
        ),
        child: InkWell(
          onTap: () => _showNotificationDetails(notification),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getNotificationColor(notification.type)
                        .withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_getNotificationIcon(notification.type),
                      color: _getNotificationColor(notification.type),
                      size: 24),
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
                              notification.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: notification.read
                                    ? FontWeight.w500
                                    : FontWeight.bold,
                              ),
                            ),
                          ),
                          if (!notification.read)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                  color: primaryColor, shape: BoxShape.circle),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getNotificationColor(notification.type)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              notification.type.toUpperCase(),
                              style: TextStyle(
                                color: _getNotificationColor(notification.type),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Icon(Icons.access_time,
                              size: 14, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Text(timeAgo,
                              style: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(_showUnreadOnly ? 'No unread notifications' : 'No notifications',
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
              _showUnreadOnly
                  ? 'You\'ve read all your notifications!'
                  : 'You\'re all caught up!',
              style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  void _showNotificationDetails(AppNotification notification) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    _getNotificationColor(notification.type).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(_getNotificationIcon(notification.type),
                  color: _getNotificationColor(notification.type), size: 32),
            ),
            const SizedBox(height: 16),
            Text(notification.title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color:
                    _getNotificationColor(notification.type).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(notification.type.toUpperCase(),
                  style: TextStyle(
                      color: _getNotificationColor(notification.type),
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
            ),
            const SizedBox(height: 20),
            Text(notification.message,
                style: const TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Text(
                    DateFormat('MMMM dd, yyyy at hh:mm a')
                        .format(notification.createdAt),
                    style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'attendance':
        return Icons.how_to_reg;
      case 'assignment':
        return Icons.assignment;
      case 'quiz':
        return Icons.quiz;
      case 'holiday':
        return Icons.celebration;
      case 'schedule':
        return Icons.schedule;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'attendance':
        return AppColors.warning;
      case 'assignment':
        return AppColors.primary;
      case 'quiz':
        return AppColors.info;
      case 'holiday':
        return AppColors.success;
      case 'schedule':
        return AppColors.secondary;
      default:
        return AppColors.primary;
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
    return 'Just now';
  }
}
