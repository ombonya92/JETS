import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Continue Studying",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 12),
            Text("Medical Biostatistics"),
            SizedBox(height: 12),
            LinearProgressIndicator(
              value: 0.65,
              minHeight: 8,
            ),
            SizedBox(height: 8),
            Text("65% Complete"),
          ],
        ),
      ),
    );
  }
}