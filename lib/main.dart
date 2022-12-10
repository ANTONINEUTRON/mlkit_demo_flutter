import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mlkit_demo_flutter/pages/capture_image_page.dart';

import 'pages/home_page.dart';

late CameraDescription camera;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Initiliaz camera that'll passed to capture page
  var cameras =  await availableCameras();
  camera = cameras.first;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: CaptureImagePage(
        camera: camera,
      ),
    );
  }
}