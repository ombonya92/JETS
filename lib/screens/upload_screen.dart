import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../core/app_controller.dart';
import '../models/document_record.dart';
import '../state/app_state.dart';
import 'analysis_screen.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  bool _loading = false;

  Future<void> _pickFile() async {
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _loading = true);

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );

      if (result == null) {
        setState(() => _loading = false);
        return;
      }

      final picked = result.files.single;
      final bytes = picked.bytes;

      if (bytes == null) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Could not read this PDF.')),
        );
        setState(() => _loading = false);
        return;
      }

      final controller = AppController.instance;
      final analysis = await controller.documents.analyzePdf(
        bytes,
        picked.name,
      );

      final record = DocumentRecord(
        id: AppState.generateId(),
        fileName: analysis.fileName,
        pageCount: analysis.pageCount,
        subjects: analysis.subjects,
        keywords: analysis.keywords,
        uploadedAt: DateTime.now(),
      );

      if (analysis.hasText) {
        await controller.intelligence.analyzeRecord(record, analysis.text);
      } else {
        await controller.state.addDocument(record);
      }

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AnalysisScreen(document: analysis),
        ),
      );
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Upload failed. Please try again.')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Notes')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.upload_file, size: 90, color: Colors.blue.shade300),
              const SizedBox(height: 28),
              const Text(
                'Upload Notes or Past Papers',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Joseph will analyse the document and prepare summaries, '
                'quizzes, questions and a study plan.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 44),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _pickFile,
                  icon: _loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.upload_file),
                  label: Text(
                    _loading ? 'Analysing...' : 'Choose PDF',
                    style: const TextStyle(fontSize: 17),
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