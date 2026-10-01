import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../services/document_service.dart';
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

      if (result == null) return;

      final pickedFile = result.files.single;

      if (pickedFile.bytes == null) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text(
              "JETS could not read this PDF.",
            ),
          ),
        );
        return;
      }

      final documentService = DocumentService();

      final analysis = await documentService.analyzePdf(
        pickedFile.bytes!,
        pickedFile.name,
      );

      if (!context.mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AnalysisScreen(
            fileName: analysis["fileName"],
            pages: analysis["pages"],
            subjects: List<String>.from(
              analysis["subjects"],
            ),
            keywords: List<String>.from(
              analysis["keywords"],
            ),
            summary: analysis["summary"],
            documentText: analysis["text"] ?? "",
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            "Upload failed. Please try again.\n$e",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Notes"),
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
                "Upload your notes or past paper",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Joseph will analyse the document and prepare learning resources.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _pickFile(context),
                  icon: const Icon(Icons.upload_file),
                  label: const Text("Choose PDF"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}