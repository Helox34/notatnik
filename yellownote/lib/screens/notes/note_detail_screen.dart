import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/data_provider.dart';
import '../../models/note.dart';
import '../../theme/app_colors.dart';

class NoteDetailScreen extends StatefulWidget {
  final Note? note; // null if creating new
  final String? projectId;

  const NoteDetailScreen({super.key, this.note, this.projectId});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isDirty = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    if (_titleController.text.trim().isEmpty) return;

    final provider = Provider.of<DataProvider>(context, listen: false);

    if (widget.note == null) {
      // Create new
      final newNote = Note(
        title: _titleController.text,
        content: _contentController.text,
        projectId: widget.projectId,
      );
      provider.addNote(newNote);
    } else {
      // Update existing
      final updatedNote = widget.note!.copyWith(
        title: _titleController.text,
        content: _contentController.text,
        updatedAt: DateTime.now(),
      );
      provider.updateNote(updatedNote);
    }
  }

  void _deleteNote() {
    if (widget.note != null) {
      final provider = Provider.of<DataProvider>(context, listen: false);
      provider.deleteNote(widget.note!.id);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Nowa notatka' : 'Edycja notatki'),
        actions: [
          if (widget.note != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.error),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Usunąć notatkę?'),
                    content: const Text('Tej operacji nie można cofnąć.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Anuluj'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Usuń'),
                      ),
                    ],
                  ),
                );
                
                if (confirm == true) {
                  _deleteNote();
                }
              },
            ),
          IconButton(
            icon: const Icon(Icons.check, color: AppColors.darkNavy),
            onPressed: () {
              _saveNote();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                hintText: 'Tytuł',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onChanged: (_) => _isDirty = true,
            ),
            const Divider(),
            Expanded(
              child: TextField(
                controller: _contentController,
                style: const TextStyle(fontSize: 16, height: 1.5),
                decoration: const InputDecoration(
                  hintText: 'Zacznij pisać...',
                  border: InputBorder.none,
                ),
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
                textAlignVertical: TextAlignVertical.top,
                onChanged: (_) => _isDirty = true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
