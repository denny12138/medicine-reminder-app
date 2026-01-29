import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Android 设置：参数名改为 defaultIcon
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // iOS 设置
    const iosSettings = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // 初始化：这里必须使用命名参数 initializationSettings
    await _notifications.initialize(
      settings, 
      onDidReceiveNotificationResponse: (NotificationResponse payload) {
        // 处理通知点击事件
      },
    );

    // 初始化时区
    tz.initializeTimeZones();
  }

  static Future<void> scheduleMedicineReminder(
    String id,
    String title,
    String body,
    DateTime scheduledDate,
  ) async {
    await _notifications.zonedSchedule(
      id: id.hashCode % 100000, // 参数名 id
      title: title,             // 参数名 title
      body: body,               // 参数名 body
      scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local), // 参数名 scheduledDate
      notificationDetails: const NotificationDetails( // 参数名 notificationDetails
        android: AndroidNotificationDetails(
          'medicine_channel',
          'Medicine Reminders',
          channelDescription: 'Reminders for taking medicine',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // 新版本建议加上这个
    );
  }

  static Future<void> cancelNotification(int id) async {
    // 取消：必须加参数名 id
    await _notifications.cancel(id: id);
  }

  static Future<void> showImmediateNotification(
    String title,
    String body,
  ) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'medicine_channel',
        'Medicine Reminders',
        channelDescription: 'Reminders for taking medicine',
      ),
      iOS: DarwinNotificationDetails(),
    );

    // 显示：所有参数都必须带名字
    await _notifications.show(
      id: 0,
      title: title,
      body: body,
      notificationDetails: details,
    );
  }
}
