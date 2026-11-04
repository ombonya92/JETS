import 'package:flutter/material.dart';

import '../core/app_controller.dart';
import '../models/document_record.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppController.instance.state,
      builder: (context, _) {
        final docs = AppController.instance.state.documents;
        return _LibraryView(documents: docs);
      },
    );
  }
}

class _LibraryView extends StatelessWidget {
  final List<DocumentRecord> documents;

  const _LibraryView({required this.documents});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text(
          'My Library',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(documents.length),
            const SizedBox(height: 25),
            const Text(
              'Uploaded Documents',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: documents.isEmpty
                  ? _emptyState()
                  : ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        return _documentCard(context, documents[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(int count) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Academic Library',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$count document${count == 1 ? '' : 's'}',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.upload_file_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No documents yet.',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Text(
            'Upload a PDF from the Upload tab.',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _documentCard(BuildContext context, DocumentRecord doc) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: const CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.description, color: Colors.white),
        ),
        title: Text(
          doc.fileName,
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${doc.pageCount} pages - ${doc.subjects.join(", ")}'),
            if (doc.tags.isNotEmpty)
              Wrap(
                spacing: 4,
                children: doc.tags
                    .map(
                      (tag) => Chip(
                        label: Text(tag, style: const TextStyle(fontSize: 11)),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (action) => _handleAction(context, doc, action),
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'rename', child: Text('Rename')),
            PopupMenuItem(value: 'tag', child: Text('Add Tag')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
        isThreeLine: doc.tags.isNotEmpty,
      ),
    );
  }

  void _handleAction(
    BuildContext context,
    DocumentRecord doc,
    String action,
  ) {
    switch (action) {
      case 'rename':
        _showRenameDialog(context, doc);
      case 'tag':
        _showTagDialog(context, doc);
      case 'delete':
        _showDeleteDialog(context, doc);
    }
  }

  void _showRenameDialog(BuildContext context, DocumentRecord doc) {
    final controller = TextEditingController(text: doc.fileName);

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Document'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'File name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                AppController.instance.state.updateDocument(
                  doc.copyWith(fileName: name),
                );
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ).then((_) => controller.dispose());
  }

  void _showTagDialog(BuildContext context, DocumentRecord doc) {
    final controller = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Tag'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Tag',
            hintText: 'e.g. Important, Exam, Revision',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final tag = controller.text.trim();
              if (tag.isNotEmpty && !doc.tags.contains(tag)) {
                AppController.instance.state.updateDocument(
                  doc.copyWith(tags: [...doc.tags, tag]),
                );
              }
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    ).then((_) => controller.dispose());
  }

  void _showDeleteDialog(BuildContext context, DocumentRecord doc) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Document'),
        content: Text('Remove "${doc.fileName}" from your library?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              AppController.instance.state.deleteDocument(doc.id);
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}