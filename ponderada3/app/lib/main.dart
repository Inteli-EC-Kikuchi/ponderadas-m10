import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import './views/camera_view.dart';
import './views/login.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    'resource://drawable/image',
    [
      NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white,
          icon: 'resource://drawable/image',
          )
    ],
    // Channel groups are only visual and are not required
    channelGroups: [
      NotificationChannelGroup(
          channelGroupKey: 'basic_channel_group',
          channelGroupName: 'Basic group')
    ],
    debug: true
  );

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
  if (!isAllowed) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
});


  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple
      ),
      home: Login(),
      routes: {
        '/camera': (BuildContext context) => CameraView(camera: firstCamera),
      },
    ),
  );
}
