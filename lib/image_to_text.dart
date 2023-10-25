import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class ImageToTextApp extends StatefulWidget {
  @override
  _ImageToTextAppState createState() => _ImageToTextAppState();
}

class _ImageToTextAppState extends State<ImageToTextApp> {
  File? _image;
  final picker = ImagePicker();
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Image to Text'),
        ),
        body: Center(
          child: _image == null
              ? Text('No image selected.')
              : Column(
                  children: [
                    Image.file(
                      _image!,
                      height: MediaQuery.of(context).size.height * 0.6,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          readTextFromImage();
                        },
                        child: const Text("Get Text"))
                  ],
                ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: getImageFromGallery,
          tooltip: 'Select Image',
          child: Icon(Icons.image),
        ),
      ),
    );
  }

  Future<void> readTextFromImage() async {
    final inputImage = InputImage.fromFile(_image!);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    String text = recognizedText.text;

    textRecognizer.close();

    // Process the extracted text as required (e.g., display in a dialog).
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Extracted Text'),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
