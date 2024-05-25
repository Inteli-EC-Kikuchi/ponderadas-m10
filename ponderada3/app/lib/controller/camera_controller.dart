import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class CameraControllerHandler {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  CameraController get controller => _controller;
  Future<void> get initializeControllerFuture => _initializeControllerFuture;

  void initializeCamera(CameraDescription camera) {
    _controller = CameraController(
      camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  void disposeController() {
    _controller.dispose();
  }

  Future<String?> takePicture() async {
    if (!_controller.value.isInitialized) {
      return null;
    }

    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      return image.path;
    } catch (e) {
      print('Error taking picture: $e');
      return null;
    }
  }

  Future<http.Response> sendImage(String imagePath) async {
    var uri = Uri.parse('http://localhost:3000/image-processor/process-image');

    var request = http.MultipartRequest('POST', uri);
    var file = await http.MultipartFile.fromPath(
      'file',
      imagePath,
      contentType: MediaType.parse(lookupMimeType(imagePath) ?? 'image/jpeg'),
    );

    request.files.add(file);

    var response = await request.send();
    return http.Response.fromStream(response);
  }

  
}
