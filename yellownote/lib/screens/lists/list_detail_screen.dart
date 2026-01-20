import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/data_provider.dart';
import '../../models/list_model.dart';
import '../../theme/app_colors.dart';

class ListDetailScreen extends StatefulWidget {
  final ListModel? list; // null if creating new
  final String? projectId;

  const ListDetailScreen({super.key, this.list, this.projectId});

  @override
  State<ListDetailScreen> createState() => _ListDetailScreenState();
}

class _ListDetailScreenState extends State<ListDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _newItemController;
  late List<ChecklistItem> _items;
  ListModel? _currentList;

  @override
  void initState() {
    super.initState();
    _currentList = widget.list;
    _titleController = TextEditingController(text: widget.list?.title ?? '');
    _newItemController = TextEditingController();
    _items = widget.list?.items.map((e) => ChecklistItem(
      id: e.id,
      text: e.text,
      isCompleted: e.isCompleted,
    )).toList() ?? [];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _newItemController.dispose();
    super.dispose();
  }

  void _addItem() {
    final text = _newItemController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _items.add(ChecklistItem(text: text));
        _newItemController.clear();
      });
      _saveList();
    }
  }

  void _saveList() {
    if (_titleController.text.trim().isEmpty) return;

    final provider = Provider.of<DataProvider>(context, listen: false);

    if (_currentList == null) {
      // Create new
      final newList = ListModel(
        title: _titleController.text,
        items: _items,
        projectId: widget.projectId,
      );
      provider.addList(newList);
      _currentList = newList; // Update local reference so next save updates this one
    } else {
      // Update existing
      final updatedList = _currentList!.copyWith(
        title: _titleController.text,
        items: _items,
        updatedAt: DateTime.now(),
      );
      provider.updateList(updatedList);
      _currentList = updatedList;
    }
  }

  void _deleteList() {
    if (_currentList != null) {
      final provider = Provider.of<DataProvider>(context, listen: false);
      provider.deleteList(_currentList!.id);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _titleController,
          style: const TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.bold,
            color: AppColors.darkNavy,
          ),
          decoration: const InputDecoration(
            hintText: 'Nazwa listy',
            border: InputBorder.none,
          ),
          onChanged: (_) => _saveList(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Usunąć listę?'),
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
                _deleteList();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Add new item input
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newItemController,
                    decoration: InputDecoration(
                      hintText: 'Dodaj nowy element...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      prefixIcon: const Icon(Icons.add),
                    ),
                    onSubmitted: (_) => _addItem(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _addItem,
                  icon: const Icon(Icons.arrow_upward),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    foregroundColor: AppColors.darkNavy,
                  ),
                ),
              ],
            ),
          ),
          
          // List Items
          Expanded(
            child: ReorderableListView(
              padding: const EdgeInsets.only(bottom: 20),
              children: [
                for (int index = 0; index < _items.length; index++)
                  _buildListItem(index),
              ],
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final item = _items.removeAt(oldIndex);
                  _items.insert(newIndex, item);
                });
                _saveList();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(int index) {
    final item = _items[index];
    
    return Dismissible(
      key: ValueKey(item.id),
      background: Container(
        color: AppColors.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() {
          _items.removeAt(index);
        });
        _saveList();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: item.isCompleted 
              ? null 
              : Border.all(color: AppColors.lightGray.withOpacity(0.5)),
        ),
        child: ListTile(
          leading: Checkbox(
            value: item.isCompleted,
            activeColor: AppColors.yellow,
            onChanged: (val) {
              setState(() {
                _items[index].isCompleted = val ?? false;
              });
              _saveList();
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          title: Text(
            item.text,
            style: TextStyle(
              decoration: item.isCompleted ? TextDecoration.lineThrough : null,
              color: item.isCompleted ? AppColors.darkGray : null,
            ),
          ),
          trailing: const Icon(Icons.drag_handle, color: AppColors.mediumGray),
        ),
      ),
    );
  }
}
