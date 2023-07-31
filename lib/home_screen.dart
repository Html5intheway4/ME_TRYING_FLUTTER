import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'result_screen.dart';
//import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
//import 'package:tflite/tflite.dart';
//import 'package:image_editor/image_editor.dart';
import 'dart:io';
//import 'dart:typed_data';
//import 'dart:ui' as ui;
//import 'package:flutter/painting.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Interpreter? _interpreter;
  File? _image;

  Future<void> _loadModel() async {
    try {

      const modelFile =
          "assets/model_unquant.tflite"; // Replace with your model file path
      _interpreter = await Interpreter.fromAsset(modelFile);
    } catch (e) {
      print("Error loading model: $e");
      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error loading model. Please try again later.')),
      );
    }
  }

  Future<void> _getImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  // Uint8List _preprocessImage(File? image) {
  //   if (image == null) {
  //     // Handle the case when the image is null (optional)
  //     return Uint8List(0);
  //   }
  //
  //   final inputWidth = 224;
  //   final inputHeight = 224;
  //
  //   final imageBytes = image.readAsBytesSync();
  //   final inputImage = img.decodeImage(imageBytes);
  //
  //   final resizedImage =
  //       img.copyResize(inputImage!, width: inputWidth, height: inputHeight);
  //
  //   final resizedImageData = Uint8List.fromList(img.encodePng(resizedImage));
  //   return resizedImageData;
  // }

  Uint8List _preprocessImage(File? image) {
    if (image == null) {
      // Handle the case when the image is null (optional)
      return Uint8List(0);
    }

    const inputWidth = 224;
    const inputHeight = 224;

    final imageBytes = image.readAsBytesSync();
    final inputImage = img.decodeImage(imageBytes);

    final resizedImage = img.copyResize(inputImage!, width: inputWidth, height: inputHeight);

    // Convert the resized image to Uint8List for model inference
    final resizedImageData = resizedImage.getBytes();
    return Uint8List.fromList(resizedImageData);
  }


  Future<void> _performInference() async {
    if (_interpreter == null || _image == null) return;
    try {
      final inputImageData = _preprocessImage(_image!);

      final input = inputImageData.buffer.asUint8List();
      final output = List<double>.filled(
        // Replace with the number of output classes of your model
        _interpreter!.getOutputTensor(0).shape.reduce((a, b) => a * b),
        7,
      );

      _interpreter!.run(input, output);

      print("Output probabilities: $output");

      // Now you can navigate to the results screen and pass the output probabilities to display
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsScreen(output),
        ),
      );
    } catch (e) {
      print("Error performing inference: $e");
      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Error performing inference. Please try again later.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  @override
  Widget build(BuildContext context) {
    final isImageSelected = _image != null;

    return Scaffold(
      appBar: AppBar(
        title: Text('Skin Cancer Detection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_image != null)
              Image.file(
                _image ?? File('assets/image/download (5).jpeg'),
                height: 200,
                width: 200,
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  _getImage, // Call the function to capture the image when the button is pressed
              child: Text('Capture Image'), // Change the text as needed
            ),
            SizedBox(height: 20),
            if (isImageSelected)
              ElevatedButton(
                onPressed:
                    _performInference, // Call the classification function when the button is pressed
                child: Text('Classify Image'), // Change the text as needed
              ),
          ],
        ),
      ),
    );
  }
}
