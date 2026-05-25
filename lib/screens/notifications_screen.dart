import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:unilink/models/notification.dart';
import 'package:unilink/navigation/routes.dart';
import 'package:unilink/providers/notification_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: const Color(0xFF5D4037),
        title: const Text(
          'Notifications ',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF5F0EB),
              Color(0xFFE6DED7),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: notifications.when(
          data: (notificationsList) {
            if (notificationsList.isEmpty) {
              return const Center(
                child: Text(
                  'No notifications yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF5D4037),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notificationsList.length,
              itemBuilder: (context, index) {
                final notification = notificationsList[index];
                return NotificationTile(notification: notification);
              },
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF5D4037),
            ),
          ),
          error: (error, stackTrace) => Center(
            child: Text(
              'Error: $error',
              style: const TextStyle(
                color: Color(0xFF5D4037),
              ),
            ),
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: const Color(0xFF5D4037),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(Routes.home);
              break;
            case 1:
              break;
            case 2:
              context.go(Routes.profile);
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class NotificationTile extends ConsumerWidget {
  final NotificationItem notification;

  const NotificationTile({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: Key(notification.id),
        background: Container(
          decoration: BoxDecoration(
            color: Colors.red.shade400,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (_) {
          NotificationService().deleteNotification(notification.id);
        },
        child: Card(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            leading: _getNotificationIcon(notification.type),
            title: Text(
              notification.title,
              style: TextStyle(
                fontWeight: notification.isRead
                    ? FontWeight.w500
                    : FontWeight.bold,
                color: const Color(0xFF3E2723),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                notification.message,
                style: const TextStyle(
                  color: Colors.black87,
                ),
              ),
            ),
            trailing: Text(
              _formatDate(notification.createdAt),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
            onTap: () {
              if (!notification.isRead) {
                NotificationService().markAsRead(notification.id);
              }

              context.push(
                '${Routes.itemDetails}/${notification.itemId}',
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _getNotificationIcon(String type) {
    switch (type) {
      case 'lost':
        return const CircleAvatar(
          backgroundColor: Color(0xFFD7A86E),
          child: Icon(
            Icons.search,
            color: Colors.white,
          ),
        );

      case 'found':
        return const CircleAvatar(
          backgroundColor: Color(0xFF8D6E63),
          child: Icon(
            Icons.check_circle,
            color: Colors.white,
          ),
        );

      case 'match':
        return const CircleAvatar(
          backgroundColor: Color(0xFF5D4037),
          child: Icon(
            Icons.compare_arrows,
            color: Colors.white,
          ),
        );

      default:
        return const CircleAvatar(
          backgroundColor: Colors.grey,
          child: Icon(
            Icons.notifications,
            color: Colors.white,
          ),
        );
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}