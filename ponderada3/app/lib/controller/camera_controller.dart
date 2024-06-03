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

  Future<String?> sendImage(String imagePath) async {
    var uri = Uri.parse('http://10.128.0.1:3000/image-processor/process-image');

    var request = http.MultipartRequest('POST', uri);
    var file = await http.MultipartFile.fromPath(
      'file',
      imagePath,
      contentType: MediaType.parse(lookupMimeType(imagePath) ?? 'image/jpeg'),
    );

    request.files.add(file);

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await http.Response.fromStream(response);
      var decodedData = jsonDecode(responseData.body);
      return decodedData['image'] as String;
    } else {
      print('Error uploading image: ${response.statusCode}');
      return null;
    }
  }

  Future<File> decodeBase64Image(String base64Image, String outputPath) async {
    var bytes = base64Decode(base64Image);
    var file = File(outputPath);
    await file.writeAsBytes(bytes);
    return file;
  }

  
}
