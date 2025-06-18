import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Request permission for notifications
    await Permission.notification.request();

    // Initialize local notifications
    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      channelDescription: 'Default notification channel',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecond,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  void _onNotificationTap(NotificationResponse response) {
    print('Local notification tapped: ${response.payload}');
    // TODO: Navigate to appropriate screen based on the notification payload
  }

  // Sample method to show a notification for new listings
  Future<void> showNewListingNotification(String vehicleTitle) async {
    await showNotification(
      title: 'New Vehicle Listed',
      body: 'Check out the new $vehicleTitle!',
      payload: 'new_listing',
    );
  }

  // Sample method to show a notification for price updates
  Future<void> showPriceUpdateNotification(String vehicleTitle, String newPrice) async {
    await showNotification(
      title: 'Price Update',
      body: 'The price of $vehicleTitle has been updated to $newPrice',
      payload: 'price_update',
    );
  }

  // Sample method to show a notification for messages
  Future<void> showMessageNotification(String senderName) async {
    await showNotification(
      title: 'New Message',
      body: 'You have a new message from $senderName',
      payload: 'message',
    );
  }

  // Sample method to show a notification for offers
  Future<void> showOfferNotification(String vehicleTitle, String offerAmount) async {
    await showNotification(
      title: 'New Offer',
      body: 'You received an offer of $offerAmount for $vehicleTitle',
      payload: 'offer',
    );
  }
} 