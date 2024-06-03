import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../controller/camera_controller.dart';
import '../controller/notification_controller.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class CameraView extends StatefulWidget {
  final CameraDescription camera;

  const CameraView({super.key, required this.camera});

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  final CameraControllerHandler _cameraControllerHandler = CameraControllerHandler();

  @override
  void initState() {

    AwesomeNotifications().setListeners(
        onActionReceivedMethod:         NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:    NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:  NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:  NotificationController.onDismissActionReceivedMethod
    );

    super.initState();
    _cameraControllerHandler.initializeCamera(widget.camera);
  }

  @override
  void dispose() {
    _cameraControllerHandler.disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      body: FutureBuilder<void>(
        future: _cameraControllerHandler.initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_cameraControllerHandler.controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          AwesomeNotifications().createNotification(
                    content: NotificationContent(
                        id: 10,
                        channelKey: 'basic_channel',
                        title: 'Hello Awesome Notifications!',
                        body: 'Sua imagem foi enviada e está sendo processada! ${DateTime.now()}',
                        notificationLayout: NotificationLayout.Default
                    )
                );

          final imagePath = await _cameraControllerHandler.takePicture();
          if (imagePath != null) {
            if (!context.mounted) return;
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(imagePath: imagePath),
              ),
            );
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Image.file(File(imagePath)),
    );
  }
}
