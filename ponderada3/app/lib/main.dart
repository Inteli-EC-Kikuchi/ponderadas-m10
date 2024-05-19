import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import './views/camera_view.dart';
import './views/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
