import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/data_provider.dart';
import '../../theme/app_colors.dart';
import '../../models/project.dart';
import '../../models/note.dart';
import '../../models/list_model.dart';
import '../notes/note_detail_screen.dart';
import '../lists/list_detail_screen.dart';

class ProjectDetailScreen extends StatefulWidget {
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  bool _isSelectionMode = false;
  final Set<String> _selectedListIds = {};
  final Set<String> _selectedNoteIds = {};

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      _selectedListIds.clear();
      _selectedNoteIds.clear();
    });
  }

  void _toggleListSelection(String id) {
    setState(() {
      if (_selectedListIds.contains(id)) {
        _selectedListIds.remove(id);
      } else {
        _selectedListIds.add(id);
      }
    });
  }

  void _toggleNoteSelection(String id) {
    setState(() {
      if (_selectedNoteIds.contains(id)) {
        _selectedNoteIds.remove(id);
      } else {
        _selectedNoteIds.add(id);
      }
    });
  }

  Future<void> _deleteSelected(DataProvider dataProvider) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('UsuĹ„ wybrane elementy'),
        content: Text('Czy na pewno chcesz usunÄ…Ä‡ ${_selectedListIds.length + _selectedNoteIds.length} element(Ăłw)?'),
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
            child: const Text('UsuĹ„'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      for (final id in _selectedListIds) {
        await dataProvider.deleteList(id);
      }
      for (final id in _selectedNoteIds) {
        await dataProvider.deleteNote(id);
      }
      _toggleSelectionMode();
    }
  }

  void _showEditProjectDialog(BuildContext context, DataProvider dataProvider) {
    final titleController = TextEditingController(text: widget.project.title);
    final descController = TextEditingController(text: widget.project.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edytuj Projekt'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Nazwa projektu'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Opis (opcjonalnie)'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Anuluj'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                final updatedProject = widget.project.copyWith(
                  title: titleController.text,
                  description: descController.text,
                );
                dataProvider.updateProject(updatedProject);
                Navigator.pop(context);
              }
            },
            child: const Text('Zapisz'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isSelectionMode 
          ? 'Wybrano: ${_selectedListIds.length + _selectedNoteIds.length}' 
          : widget.project.title),
        actions: [
          if (_isSelectionMode) ...[
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.error),
              onPressed: (_selectedListIds.isEmpty && _selectedNoteIds.isEmpty) 
                ? null 
                : () => _deleteSelected(Provider.of<DataProvider>(context, listen: false)),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _toggleSelectionMode,
            ),
          ] else ...[
            /*IconButton(
              icon: Icon(widget.project.isArchived ? Icons.unarchive : Icons.archive),
              tooltip: widget.project.isArchived ? 'PrzywrĂłÄ‡ z archiwum' : 'Archiwizuj',
              onPressed: () => _toggleArchive(context),
            ),*/
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showEditProjectDialog(context, Provider.of<DataProvider>(context, listen: false)),
            ),
          ],
        ],
      ),
      body: Consumer<DataProvider>(
        builder: (context, dataProvider, _) {
          final projectNotes = dataProvider.getProjectNotes(widget.project.id);
          final projectLists = dataProvider.getProjectLists(widget.project.id);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!_isSelectionMode)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    color: AppColors.projectsBg.withOpacity(0.3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.project.description.isNotEmpty) ...[
                          Text(
                            widget.project.description,
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(height: 16),
                        ],
                        Row(
                          children: [
                            _StatChip(
                              icon: Icons.list,
                              label: '${projectLists.length} list',
                              color: AppColors.listsBg,
                            ),
                            const SizedBox(width: 12),
                            _StatChip(
                              icon: Icons.note,
                              label: '${projectNotes.length} notatek',
                              color: AppColors.notesBg,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Progress bar
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Postęp zadań',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${widget.project.progressPercentage}%',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.yellow,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: widget.project.progress,
                              backgroundColor: AppColors.mediumGray,
                              valueColor: const AlwaysStoppedAnimation(AppColors.yellow),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 24),

                // Lists section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Listy',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (!_isSelectionMode)
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_square, color: AppColors.darkGray),
                              onPressed: _toggleSelectionMode,
                              tooltip: 'ZarzÄ…dzaj',
                            ),
                            TextButton.icon(
                              onPressed: () => _showAddListDialog(context),
                              icon: const Icon(Icons.add),
                              label: const Text('Dodaj'),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                
                if (projectLists.isEmpty)
                  Builder(
                    builder: (context) {
                      final isDark = Theme.of(context).brightness == Brightness.dark;
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: Text(
                            'Brak list w tym projekcie',
                            style: TextStyle(
                              color: isDark ? Colors.grey[400] : AppColors.darkGray,
                            ),
                          ),
                        ),
                      );
                    },
                  )
                else
                  ...projectLists.map((list) => _ListTile(
                    list: list,
                    isSelectionMode: _isSelectionMode,
                    isSelected: _selectedListIds.contains(list.id),
                    onSelectionChanged: (val) => _toggleListSelection(list.id),
                  )),

                const SizedBox(height: 24),

                // Notes section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Notatki',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (!_isSelectionMode)
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_square, color: AppColors.darkGray),
                              onPressed: _toggleSelectionMode,
                              tooltip: 'ZarzÄ…dzaj',
                            ),
                            TextButton.icon(
                              onPressed: () => _showAddNoteDialog(context),
                              icon: const Icon(Icons.add),
                              label: const Text('Dodaj'),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

                if (projectNotes.isEmpty)
                  Builder(
                    builder: (context) {
                      final isDark = Theme.of(context).brightness == Brightness.dark;
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: Text(
                            'Brak notatek w tym projekcie',
                            style: TextStyle(
                              color: isDark ? Colors.grey[400] : AppColors.darkGray,
                            ),
                          ),
                        ),
                      );
                    },
                  )
                else
                  ...projectNotes.map((note) => _NoteTile(
                    note: note,
                    isSelectionMode: _isSelectionMode,
                    isSelected: _selectedNoteIds.contains(note.id),
                    onSelectionChanged: (val) => _toggleNoteSelection(note.id),
                  )),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddListDialog(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ListDetailScreen(projectId: widget.project.id),
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NoteDetailScreen(projectId: widget.project.id),
      ),
    );
  }

  Future<void> _toggleArchive(BuildContext context) async {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final updatedProject = widget.project.copyWith(
      isArchived: !widget.project.isArchived,
    );
    await dataProvider.updateProject(updatedProject);
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.project.isArchived
            ? 'Projekt przywrócony z archiwum'
            : 'Projekt zarchiwizowany'),
          backgroundColor: AppColors.yellow,
        ),
      );
      Navigator.pop(context);
    }
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.darkNavy,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.darkNavy,
            ),
          ),
        ],
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  final ListModel list;
  final bool isSelectionMode;
  final bool isSelected;
  final ValueChanged<bool?>? onSelectionChanged;

  const _ListTile({
    required this.list,
    this.isSelectionMode = false,
    this.isSelected = false,
    this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: InkWell(
        onTap: isSelectionMode
            ? () => onSelectionChanged?.call(!isSelected)
            : () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ListDetailScreen(list: list),
                  ),
                );
              },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12), // Reduced padding for ListTile feel
          child: Row(
            children: [
              if (isSelectionMode)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Checkbox(
                    value: isSelected,
                    onChanged: onSelectionChanged,
                  ),
                ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.listsBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.list, color: Color(0xFF4CAF50), size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      list.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${list.completedCount}/${list.totalCount} ukończone',
                      style: TextStyle(fontSize: 12, color: AppColors.darkGray),
                    ),
                  ],
                ),
              ),
              if (!isSelectionMode)
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoteTile extends StatelessWidget {
  final Note note;
  final bool isSelectionMode;
  final bool isSelected;
  final ValueChanged<bool?>? onSelectionChanged;

  const _NoteTile({
    required this.note,
    this.isSelectionMode = false,
    this.isSelected = false,
    this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: InkWell(
        onTap: isSelectionMode
            ? () => onSelectionChanged?.call(!isSelected)
            : () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => NoteDetailScreen(note: note),
                  ),
                );
              },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12), // Reduced padding for ListTile feel
          child: Row(
            children: [
              if (isSelectionMode)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Checkbox(
                    value: isSelected,
                    onChanged: onSelectionChanged,
                  ),
                ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.notesBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.note, color: Color(0xFF2196F3), size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    if (note.content.isNotEmpty)
                      Text(
                        note.content,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: AppColors.darkGray),
                      ),
                  ],
                ),
              ),
              if (!isSelectionMode)
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
