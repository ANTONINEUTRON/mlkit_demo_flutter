import 'dart:io';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter/material.dart';

class RecognizeTextPage extends StatefulWidget {
  RecognizeTextPage({Key? key, required this.path}) : super(key: key);

  String path;

  @override
  State<RecognizeTextPage> createState() => _RecognizeTextPageState();
}

class _RecognizeTextPageState extends State<RecognizeTextPage> {
  late InputImage inputImage;
  var textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  @override
  void initState() {
    inputImage = InputImage.fromFile(File(widget.path));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recognized Text"),
      ),
      body: FutureBuilder(
          future: textRecognizer.processImage(inputImage),
          builder: (context, snapshot){
            if(!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            var recognizedText = snapshot.data as RecognizedText;
            return ListView(
              children: [
                Text(recognizedText.text),
                ElevatedButton(
                    onPressed: (){
                      Clipboard
                          .setData(ClipboardData(text: recognizedText.text))
                          .then((value){
                            //alert user
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Copied"))
                            );
                          });
                    },
                    child: const Text("Copy")
                )
              ],
            );
          }
      ),
    );
  }

  @override
  void dispose() {
    textRecognizer.close();
    super.dispose();
  }
}
