import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // 1. 初始化方法：settings 是位置参数（不带名字）
    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse payload) {
        // 处理通知点击事件
      },
    );

    tz.initializeTimeZones();
  }

  static Future<void> scheduleMedicineReminder(
    String id,
    String title,
    String body,
    DateTime scheduledDate,
  ) async {
    // 2. 定时通知：前5个参数必须按顺序填，不能带名字！
    await _notifications.zonedSchedule(
      id.hashCode % 100000,                  // 参数1：ID
      title,                                 // 参数2：标题
      body,                                  // 参数3：内容
      tz.TZDateTime.from(scheduledDate, tz.local), // 参数4：时间
      const NotificationDetails(             // 参数5：详情配置
        android: AndroidNotificationDetails(
          'medicine_channel',
          'Medicine Reminders',
          channelDescription: 'Reminders for taking medicine',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      // 后面的参数才是带名字的
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // 18.0.1 必须加这个
    );
  }

  static Future<void> cancelNotification(int id) async {
    // 3. 取消通知：id 是位置参数，不要写 id:
    await _notifications.cancel(id);
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

    // 4. 立即显示：前4个参数必须按顺序填
    await _notifications.show(
      0,      // 参数1：ID
      title,  // 参数2：标题
      body,   // 参数3：内容
      details // 参数4：详情配置
    );
  }
}
