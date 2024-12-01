import 'package:flutter/material.dart';

class InstructionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instructions'),
        backgroundColor: Colors.blue[800],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to the Live Feedback App! Here\'s how you can use it:\n\n'
                    '1. Select an emoji to express how you feel.\n'
                    '2. (Optional) Add a message with your feedback.\n'
                    '3. Click the "Submit" button to send your feedback.\n\n'
                    'At the end of the class, click the "Class_end" button to finalize and view the summary.\n\n'
                    'Enjoy using the app and let us know if you have any questions!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Back to Feedback'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[200],
                    padding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
