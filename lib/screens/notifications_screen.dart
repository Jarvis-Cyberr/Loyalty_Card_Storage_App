import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/card_provider.dart';
import '../services/notification_service.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CardProvider>();
    final notifications = NotificationService.notifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerts & Notifications'),
        centerTitle: true,
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              NotificationService.clearAll();
              (context as Element).markNeedsBuild();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (provider.expiredCards.isNotEmpty) ...[
            _SectionHeader(
                title: 'Expired Cards',
                icon: Icons.error,
                color: Colors.red),
            ...provider.expiredCards.map(
              (card) => _NotificationTile(
                title: '${card.storeName} — Expired',
                subtitle:
                    'Expired on ${card.expiryDate!.day}/${card.expiryDate!.month}/${card.expiryDate!.year}',
                icon: Icons.credit_card_off,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (provider.expiringCards.isNotEmpty) ...[
            _SectionHeader(
                title: 'Expiring Soon',
                icon: Icons.warning_amber,
                color: Colors.orange),
            ...provider.expiringCards.map(
              (card) => _NotificationTile(
                title: '${card.storeName} — Expiring Soon',
                subtitle:
                    'Expires on ${card.expiryDate!.day}/${card.expiryDate!.month}/${card.expiryDate!.year}',
                icon: Icons.access_time,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (notifications.isNotEmpty) ...[
            _SectionHeader(
                title: 'Recent Activity',
                icon: Icons.notifications,
                color: Colors.blue),
            ...notifications.map(
              (n) => _NotificationTile(
                title: n['title']!,
                subtitle: n['body']!,
                icon: Icons.info_outline,
                color: Colors.blue,
              ),
            ),
          ],
          if (provider.expiredCards.isEmpty &&
              provider.expiringCards.isEmpty &&
              notifications.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.notifications_none,
                        size: 60, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      '🎉 All your cards are in good shape!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _SectionHeader(
      {required this.title, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(title,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color)),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _NotificationTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle:
            Text(subtitle, style: const TextStyle(fontSize: 12)),
      ),
    );
  }
}