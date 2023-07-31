import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  final List<double> outputProbabilities;

  ResultsScreen(this.outputProbabilities);

  // Replace the skin cancer class names as per your model's output classes
  static const List<String> classNames = [
    'akiec', 'bcc', 'bkl', 'df', 'mel', 'nv', 'vasc'
  ];

  @override
  Widget build(BuildContext context) {
    int maxIndex = outputProbabilities.indexOf(outputProbabilities.reduce((a, b) => a > b ? a : b));
    String predictedClass = classNames[maxIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Skin Cancer Detection Results'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle, // Use appropriate icons for different cases
              size: 100,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Text(
              'Classified as: $predictedClass',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back to the home screen
              },
              child: Text('Go Back'),
            )
          ],
        ),
      ),
    );
  }
}
