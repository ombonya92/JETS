import 'dart:io';

class UploadAnalysis {
  final String fileName;
  final String fileType;
  final double fileSizeKB;
  final bool supported;

  UploadAnalysis({
    required this.fileName,
    required this.fileType,
    required this.fileSizeKB,
    required this.supported,
  });
}

class UploadEngine {
  UploadAnalysis analyse(File file) {
    final fileName = file.path.split(Platform.pathSeparator).last;

    final extension =
        fileName.split('.').last.toLowerCase();

    final size =
        file.lengthSync() / 1024;

    const supportedTypes = [
      'pdf',
      'doc',
      'docx',
      'ppt',
      'pptx',
      'jpg',
      'jpeg',
      'png'
    ];

    return UploadAnalysis(
      fileName: fileName,
      fileType: extension,
      fileSizeKB: size,
      supported: supportedTypes.contains(extension),
    );
  }
}