import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'recognize_text_page.dart';

///capture flag determines which page to send the captured image to for processing
enum CaptureFlag{
  translation
}

///Will be responsible for capturing image and forward it to the appropriate page
class CaptureImagePage extends StatefulWidget {
  const CaptureImagePage({Key? key, required this.camera}) : super(key: key);

  final CameraDescription camera;

  @override
  State<CaptureImagePage> createState() => _CaptureImagePageState();
}

class _CaptureImagePageState extends State<CaptureImagePage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;


  @override
  void initState() {
    //initialize camera controller
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return Column(
              children: [
                CameraPreview(_controller),
                FloatingActionButton(
                  // Provide an onPressed callback.
                  onPressed: () async {
                    // Take the Picture in a try / catch block. If anything goes wrong,
                    // catch the error.
                    try {
                      // Ensure that the camera is initialized.
                      await _initializeControllerFuture;

                      // Attempt to take a picture and get the file `image`
                      // where it was saved.
                      final image = await _controller.takePicture();

                      if (!mounted) return;

                      // If the picture was taken, display it on a new screen.
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RecognizeTextPage(
                            // Pass the automatically generated path to
                            // the DisplayPictureScreen widget.
                            path: image.path,
                          ),
                        ),
                      );
                    } catch (e) {
                      // If an error occurs, log the error to the console.
                      debugPrint(e.toString());
                    }
                  },
                  child: const Icon(Icons.camera_alt),
                )
              ],
            );
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }


  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }
}
