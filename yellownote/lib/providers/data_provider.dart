import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/project.dart';
import '../models/note.dart';
import '../models/list_model.dart';
import '../models/diary_entry.dart';

class DataProvider extends ChangeNotifier {
  List<Project> _projects = [];
  List<Note> _notes = [];
  List<ListModel> _lists = [];
  List<DiaryEntry> _diaryEntries = [];

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  List<Project> get projects {
    final sorted = List<Project>.from(_projects);
    sorted.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return sorted;
  }

  List<Note> get notes {
    final sorted = List<Note>.from(_notes);
    sorted.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return sorted;
  }

  List<ListModel> get lists {
    final sorted = List<ListModel>.from(_lists);
    sorted.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return sorted;
  }

  List<DiaryEntry> get diaryEntries {
    final sorted = List<DiaryEntry>.from(_diaryEntries);
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted;
  }

  List<Note> get standaloneNotes {
    final sorted = List<Note>.from(_notes.where((n) => n.projectId == null || n.projectId!.isEmpty));
    sorted.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return sorted;
  }

  List<ListModel> get standaloneLists {
    final sorted = List<ListModel>.from(_lists.where((l) => l.projectId == null || l.projectId!.isEmpty));
    sorted.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return sorted;
  }

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      
      final projectsJson = prefs.getString('projects');
      if (projectsJson != null) {
        final List decoded = jsonDecode(projectsJson);
        _projects = decoded.map((json) => Project.fromJson(json)).toList();
      }
      
      final notesJson = prefs.getString('notes');
      if (notesJson != null) {
        final List decoded = jsonDecode(notesJson);
        _notes = decoded.map((json) => Note.fromJson(json)).toList();
      }
      
      final listsJson = prefs.getString('lists');
      if (listsJson != null) {
        final List decoded = jsonDecode(listsJson);
        _lists = decoded.map((json) => ListModel.fromJson(json)).toList();
      }
      
      final diaryJson = prefs.getString('diary');
      if (diaryJson != null) {
        final List decoded = jsonDecode(diaryJson);
        _diaryEntries = decoded.map((json) => DiaryEntry.fromJson(json)).toList();
      }

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing data: $e');
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> _saveProjects() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(_projects.map((p) => p.toJson()).toList());
      await prefs.setString('projects', json);
    } catch (e) {
      debugPrint('Error saving projects: $e');
    }
  }

  Future<void> _saveNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(_notes.map((n) => n.toJson()).toList());
      await prefs.setString('notes', json);
    } catch (e) {
      debugPrint('Error saving notes: $e');
    }
  }

  Future<void> _saveLists() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(_lists.map((l) => l.toJson()).toList());
      await prefs.setString('lists', json);
    } catch (e) {
      debugPrint('Error saving lists: $e');
    }
  }

  Future<void> _saveDiary() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(_diaryEntries.map((d) => d.toJson()).toList());
      await prefs.setString('diary', json);
    } catch (e) {
      debugPrint('Error saving diary: $e');
    }
  }

  // Project methods
  Future<void> addProject(Project project) async {
    _projects.add(project);
    await _saveProjects();
    notifyListeners();
  }

  Future<void> updateProject(Project project) async {
    project.updatedAt = DateTime.now();
    final index = _projects.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      _projects[index] = project;
      await _saveProjects();
      notifyListeners();
    }
  }

  Future<void> deleteProject(String id) async {
    _projects.removeWhere((p) => p.id == id);
    _notes.removeWhere((n) => n.projectId == id);
    _lists.removeWhere((l) => l.projectId == id);
    
    await Future.wait([_saveProjects(), _saveNotes(), _saveLists()]);
    notifyListeners();
  }

  Project? getProject(String id) {
    try {
      return _projects.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // Note methods
  Future<void> addNote(Note note) async {
    _notes.add(note);
    await _saveNotes();
    
    if (note.projectId != null) {
      final project = getProject(note.projectId!);
      if (project != null) {
        project.totalNotes++;
        await updateProject(project);
      }
    }
    
    notifyListeners();
  }

  Future<void> updateNote(Note note) async {
    note.updatedAt = DateTime.now();
    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      _notes[index] = note;
      await _saveNotes();
      notifyListeners();
    }
  }

  Future<void> deleteNote(String id) async {
    Note? note;
    try {
      note = _notes.firstWhere((n) => n.id == id);
    } catch (e) {
      // Note not found
    }
    
    _notes.removeWhere((n) => n.id == id);
    await _saveNotes();
    
    if (note?.projectId != null) {
      final project = getProject(note!.projectId!);
      if (project != null && project.totalNotes > 0) {
        project.totalNotes--;
        await updateProject(project);
      }
    }
    
    notifyListeners();
  }

  List<Note> getProjectNotes(String projectId) {
    return notes.where((note) => note.projectId == projectId).toList();
  }

  // List methods
  Future<void> addList(ListModel list) async {
    _lists.add(list);
    await _saveLists();
    
    if (list.projectId != null) {
      final project = getProject(list.projectId!);
      if (project != null) {
        project.totalLists++;
        project.totalTasks += list.totalCount;
        project.completedTasks += list.completedCount;
        await updateProject(project);
      }
    }
    
    notifyListeners();
  }

  Future<void> updateList(ListModel list) async {
    ListModel? oldList;
    try {
      oldList = _lists.firstWhere((l) => l.id == list.id);
    } catch (e) {
      // List not found
    }
    
    list.updatedAt = DateTime.now();
    final index = _lists.indexWhere((l) => l.id == list.id);
    if (index != -1) {
      _lists[index] = list;
      await _saveLists();
    }
    
    if (list.projectId != null && oldList != null) {
      final project = getProject(list.projectId!);
      if (project != null) {
        project.totalTasks = project.totalTasks - oldList.totalCount + list.totalCount;
        project.completedTasks = project.completedTasks - oldList.completedCount + list.completedCount;
        await updateProject(project);
      }
    }
    
    notifyListeners();
  }

  Future<void> deleteList(String id) async {
    ListModel? list;
    try {
      list = _lists.firstWhere((l) => l.id == id);
    } catch (e) {
      // List not found
    }
    
    _lists.removeWhere((l) => l.id == id);
    await _saveLists();
    
    if (list?.projectId != null) {
      final project = getProject(list!.projectId!);
      if (project != null) {
        if (project.totalLists > 0) project.totalLists--;
        project.totalTasks -= list.totalCount;
        project.completedTasks -= list.completedCount;
        if (project.totalTasks < 0) project.totalTasks = 0;
        if (project.completedTasks < 0) project.completedTasks = 0;
        await updateProject(project);
      }
    }
    
    notifyListeners();
  }

  List<ListModel> getProjectLists(String projectId) {
    return lists.where((list) => list.projectId == projectId).toList();
  }

  // Diary methods
  Future<void> addDiaryEntry(DiaryEntry entry) async {
    _diaryEntries.add(entry);
    await _saveDiary();
    notifyListeners();
  }

  Future<void> updateDiaryEntry(DiaryEntry entry) async {
    entry.updatedAt = DateTime.now();
    final index = _diaryEntries.indexWhere((d) => d.id == entry.id);
    if (index != -1) {
      _diaryEntries[index] = entry;
      await _saveDiary();
      notifyListeners();
    }
  }

  Future<void> deleteDiaryEntry(String id) async {
    _diaryEntries.removeWhere((d) => d.id == id);
    await _saveDiary();
    notifyListeners();
  }

  // Clear all data
  Future<void> clearAllData() async {
    _projects.clear();
    _notes.clear();
    _lists.clear();
    _diaryEntries.clear();
    
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.remove('projects'),
      prefs.remove('notes'),
      prefs.remove('lists'),
      prefs.remove('diary'),
    ]);
    
    notifyListeners();
  }
}
