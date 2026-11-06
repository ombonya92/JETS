import 'package:flutter/material.dart';

import 'package:jets/core/app_controller.dart';
import 'package:jets/models/study_task.dart';
import 'package:jets/models/timeline_event.dart';
import 'package:jets/state/app_state.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text(
          'Timeline',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(text: 'Activity'),
            Tab(text: 'Tasks'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: const Icon(Icons.add),
      ),
      body: ListenableBuilder(
        listenable: AppController.instance.state,
        builder: (context, _) {
          final state = AppController.instance.state;
          return TabBarView(
            controller: _tabs,
            children: [
              _ActivityTab(events: state.timeline),
              _TasksTab(tasks: state.tasks),
            ],
          );
        },
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => const _AddTaskDialog(),
    );
  }
}

// Separate StatefulWidget for the add-task dialog.
// Controllers are owned by this widget and disposed in its dispose()
// so they are always cleaned up regardless of how the dialog closes.
class _AddTaskDialog extends StatefulWidget {
  const _AddTaskDialog();

  @override
  State<_AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<_AddTaskDialog> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime? _dueDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && mounted) {
      setState(() => _dueDate = picked);
    }
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    AppController.instance.state.addTask(
      StudyTask(
        id: AppState.generateId(),
        title: title,
        description: _descController.text.trim().isEmpty
            ? null
            : _descController.text.trim(),
        dueDate: _dueDate,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Task'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              autofocus: true,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              decoration:
                  const InputDecoration(labelText: 'Description (optional)'),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _dueDate == null
                        ? 'No due date'
                        : 'Due: ${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
                TextButton(
                  onPressed: _pickDate,
                  child: const Text('Set Date'),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Add'),
        ),
      ],
    );
  }
}

// Same pattern for the edit dialog.
class _EditTaskDialog extends StatefulWidget {
  final StudyTask task;
  const _EditTaskDialog({required this.task});

  @override
  State<_EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<_EditTaskDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descController =
        TextEditingController(text: widget.task.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    AppController.instance.state.updateTask(
      widget.task.copyWith(
        title: title,
        description: _descController.text.trim().isEmpty
            ? null
            : _descController.text.trim(),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
            autofocus: true,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descController,
            decoration: const InputDecoration(labelText: 'Description'),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _ActivityTab extends StatelessWidget {
  final List<TimelineEvent> events;

  const _ActivityTab({required this.events});

  static const Map<String, IconData> _icons = {
    'Upload': Icons.upload_file,
    'Question': Icons.help_outline,
    'Quiz': Icons.quiz,
    'Study': Icons.menu_book,
    'Learning': Icons.school,
    'Task': Icons.task_alt,
  };

  static const Map<String, Color> _colors = {
    'Upload': Colors.blue,
    'Question': Colors.purple,
    'Quiz': Colors.orange,
    'Study': Colors.green,
    'Learning': Colors.teal,
    'Task': Colors.indigo,
  };

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const Center(
        child: Text(
          'No activity yet.\nUpload a document or ask Joseph.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(18),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return _eventRow(events[index], index == events.length - 1);
      },
    );
  }

  Widget _eventRow(TimelineEvent event, bool isLast) {
    final icon = _icons[event.category] ?? Icons.circle;
    final color = _colors[event.category] ?? Colors.grey;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: color,
                child: Icon(icon, color: Colors.white, size: 16),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 60,
                  color: Colors.grey.shade300,
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.description,
                      style: TextStyle(color: Colors.grey.shade700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTime(event.time),
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${time.day}/${time.month}/${time.year}';
  }
}

class _TasksTab extends StatelessWidget {
  final List<StudyTask> tasks;

  const _TasksTab({required this.tasks});

  @override
  Widget build(BuildContext context) {
    final pending = tasks.where((t) => !t.completed).toList();
    final done = tasks.where((t) => t.completed).toList();

    if (tasks.isEmpty) {
      return const Center(
        child: Text(
          'No tasks yet.\nTap + to add a study task.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        if (pending.isNotEmpty) ...[
          const Text(
            'Pending',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          ...pending.map((t) => _taskCard(context, t)),
          const SizedBox(height: 20),
        ],
        if (done.isNotEmpty) ...[
          const Text(
            'Completed',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          ...done.map((t) => _taskCard(context, t)),
        ],
      ],
    );
  }

  Widget _taskCard(BuildContext context, StudyTask task) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Checkbox(
          value: task.completed,
          onChanged: task.completed
              ? null
              : (_) => AppController.instance.state.completeTask(task.id),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: task.completed ? TextDecoration.lineThrough : null,
            color: task.completed ? Colors.grey : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description != null)
              Text(
                task.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            if (task.dueDate != null)
              Text(
                'Due: ${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}',
                style: TextStyle(
                  color: _dueDateColor(task),
                  fontSize: 12,
                ),
              ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (action) => _handleAction(context, task, action),
          itemBuilder: (_) => [
            if (!task.completed)
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
        isThreeLine: task.description != null || task.dueDate != null,
      ),
    );
  }

  Color _dueDateColor(StudyTask task) {
    if (task.completed || task.dueDate == null) return Colors.grey;
    final diff = task.dueDate!.difference(DateTime.now()).inDays;
    if (diff < 0) return Colors.red;
    if (diff <= 2) return Colors.orange;
    return Colors.grey;
  }

  void _handleAction(BuildContext context, StudyTask task, String action) {
    if (action == 'delete') {
      AppController.instance.state.deleteTask(task.id);
      return;
    }
    if (action == 'edit') {
      showDialog<void>(
        context: context,
        builder: (_) => _EditTaskDialog(task: task),
      );
    }
  }
}