import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../core/app_controller.dart';
import 'analysis_screen.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  Future<void> _pickFile(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );

      if (result == null) {
        return;
      }

      final pickedFile = result.files.single;
      final bytes = pickedFile.bytes;

      if (bytes == null) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('JETS could not read this PDF.'),
          ),
        );
        return;
      }

      final controller = AppController.instance;

      final analysis = await controller.documents.analyzePdf(
        bytes,
        pickedFile.name,
      );

      if (analysis.hasText) {
        controller.intelligence.analyze(
          fileName: analysis.fileName,
          text: analysis.text,
        );
      }

      if (!context.mounted) {
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AnalysisScreen(document: analysis),
        ),
      );
    } catch (error) {
      debugPrint('PDF upload failed: $error');

      messenger.showSnackBar(
        const SnackBar(
          content: Text('Upload failed. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Notes'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.upload_file,
                size: 100,
                color: Colors.blue,
              ),
              const SizedBox(height: 25),
              const Text(
                'Upload your notes or past paper',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Joseph will analyse the document and prepare learning '
                'resources.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _pickFile(context),
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Choose PDF'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}