class NotificationService {
  static List<Map<String, String>> _notifications = [];

  static List<Map<String, String>> get notifications => _notifications;

  static void addNotification(String title, String body) {
    _notifications.insert(0, {
      'title': title,
      'body': body,
      'time': DateTime.now().toString(),
    });
  }

  static void clearAll() {
    _notifications = [];
  }
}