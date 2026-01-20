import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/data_provider.dart';
import '../../models/diary_entry.dart';
import '../../theme/app_colors.dart';

class DiaryEntryDetailScreen extends StatefulWidget {
  final DiaryEntry? entry;
  final DateTime? date;

  const DiaryEntryDetailScreen({super.key, this.entry, this.date});

  @override
  State<DiaryEntryDetailScreen> createState() => _DiaryEntryDetailScreenState();
}

class _DiaryEntryDetailScreenState extends State<DiaryEntryDetailScreen> {
  late TextEditingController _contentController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.entry?.content ?? '');
    _selectedDate = widget.entry?.date ?? widget.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _saveEntry() {
    if (_contentController.text.trim().isEmpty) return;

    final provider = Provider.of<DataProvider>(context, listen: false);

    if (widget.entry == null) {
      final newEntry = DiaryEntry(
        title: DateFormat('yyyy-MM-dd').format(_selectedDate),
        content: _contentController.text,
        date: _selectedDate,
      );
      provider.addDiaryEntry(newEntry);
    } else {
      final updatedEntry = widget.entry!.copyWith(
        content: _contentController.text,
        date: _selectedDate,
        updatedAt: DateTime.now(),
      );
      provider.updateDiaryEntry(updatedEntry);
    }
  }

  void _deleteEntry() {
    if (widget.entry != null) {
      final provider = Provider.of<DataProvider>(context, listen: false);
      provider.deleteDiaryEntry(widget.entry!.id);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat('d MMMM yyyy', 'pl_PL').format(_selectedDate)),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                setState(() => _selectedDate = picked);
              }
            },
          ),
          if (widget.entry != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.error),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Usunąć wpis?'),
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
                  _deleteEntry();
                }
              },
            ),
          IconButton(
            icon: const Icon(Icons.check, color: AppColors.darkNavy),
            onPressed: () {
              _saveEntry();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _contentController,
                style: const TextStyle(fontSize: 16, height: 1.6),
                decoration: const InputDecoration(
                  hintText: 'Jak minął Twój dzień?',
                  border: InputBorder.none,
                ),
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
