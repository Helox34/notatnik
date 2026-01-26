import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/project.dart';
import '../models/note.dart';
import '../models/list_model.dart';
import '../models/diary_entry.dart';
import '../models/reminder.dart';
import '../services/firebase_sync_service.dart';

class DataProvider extends ChangeNotifier {
  final FirebaseSyncService _syncService = FirebaseSyncService();
  
  List<Project> _projects = [];
  List<Note> _notes = [];
  List<ListModel> _lists = [];
  List<DiaryEntry> _diaryEntries = [];
  List<Reminder> _reminders = [];

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  
  FirebaseSyncService get syncService => _syncService;

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

  List<Reminder> get reminders {
    final sorted = List<Reminder>.from(_reminders);
    sorted.sort((a, b) => a.dateTime.compareTo(b.dateTime));
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

      final remindersJson = prefs.getString('reminders');
      if (remindersJson != null) {
        final List decoded = jsonDecode(remindersJson);
        _reminders = decoded.map((json) => Reminder.fromJson(json)).toList();
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

  Future<void> _saveReminders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(_reminders.map((r) => r.toJson()).toList());
      await prefs.setString('reminders', json);
    } catch (e) {
      debugPrint('Error saving reminders: $e');
    }
  }

  // Project methods
  Future<void> addProject(Project project) async {
    _projects.add(project);
    await _saveProjects();
    notifyListeners();
    // Sync to cloud in background
    _syncService.uploadProject(project).catchError((e) {
      debugPrint('Background sync failed for project: $e');
    });
  }

  Future<void> updateProject(Project project) async {
    project.updatedAt = DateTime.now();
    final index = _projects.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      _projects[index] = project;
      await _saveProjects();
      notifyListeners();
      // Sync to cloud in background
      _syncService.uploadProject(project).catchError((e) {
        debugPrint('Background sync failed for project: $e');
      });
    }
  }

  Future<void> deleteProject(String id) async {
    _projects.removeWhere((p) => p.id == id);
    _notes.removeWhere((n) => n.projectId == id);
    _lists.removeWhere((l) => l.projectId == id);
    
    await Future.wait([_saveProjects(), _saveNotes(), _saveLists()]);
    notifyListeners();
    // Sync to cloud in background
    _syncService.deleteProject(id).catchError((e) {
      debugPrint('Background sync failed for project deletion: $e');
    });
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
    // Sync to cloud in background
    _syncService.uploadNote(note).catchError((e) {
      debugPrint('Background sync failed for note: $e');
    });
  }

  Future<void> updateNote(Note note) async {
    note.updatedAt = DateTime.now();
    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      _notes[index] = note;
      await _saveNotes();
      notifyListeners();
      // Sync to cloud in background
      _syncService.uploadNote(note).catchError((e) {
        debugPrint('Background sync failed for note: $e');
      });
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
    // Sync to cloud in background
    _syncService.deleteNote(id).catchError((e) {
      debugPrint('Background sync failed for note deletion: $e');
    });
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
    // Sync to cloud in background
    _syncService.uploadList(list).catchError((e) {
      debugPrint('Background sync failed for list: $e');
    });
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
    // Sync to cloud in background
    _syncService.uploadList(list).catchError((e) {
      debugPrint('Background sync failed for list: $e');
    });
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
    // Sync to cloud in background
    _syncService.deleteList(id).catchError((e) {
      debugPrint('Background sync failed for list deletion: $e');
    });
  }

  List<ListModel> getProjectLists(String projectId) {
    return lists.where((list) => list.projectId == projectId).toList();
  }

  // Diary methods
  Future<void> addDiaryEntry(DiaryEntry entry) async {
    _diaryEntries.add(entry);
    await _saveDiary();
    notifyListeners();
    // Sync to cloud in background
    _syncService.uploadDiaryEntry(entry).catchError((e) {
      debugPrint('Background sync failed for diary entry: $e');
    });
  }

  Future<void> updateDiaryEntry(DiaryEntry entry) async {
    entry.updatedAt = DateTime.now();
    final index = _diaryEntries.indexWhere((d) => d.id == entry.id);
    if (index != -1) {
      _diaryEntries[index] = entry;
      await _saveDiary();
      notifyListeners();
      // Sync to cloud in background
      _syncService.uploadDiaryEntry(entry).catchError((e) {
        debugPrint('Background sync failed for diary entry: $e');
      });
    }
  }

  Future<void> deleteDiaryEntry(String id) async {
    _diaryEntries.removeWhere((d) => d.id == id);
    await _saveDiary();
    notifyListeners();
    // Sync to cloud in background
    _syncService.deleteDiaryEntry(id).catchError((e) {
      debugPrint('Background sync failed for diary entry deletion: $e');
    });
  }

  // Clear all data
  Future<void> clearAllData() async {
    _projects.clear();
    _notes.clear();
    _lists.clear();
    _diaryEntries.clear();
    _reminders.clear();
    
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.remove('projects'),
      prefs.remove('notes'),
      prefs.remove('lists'),
      prefs.remove('diary'),
      prefs.remove('reminders'),
    ]);
    
    notifyListeners();
  }

  // Reminder methods
  Future<void> addReminder(Reminder reminder) async {
    _reminders.add(reminder);
    await _saveReminders();
    notifyListeners();
    // Sync to cloud in background
    _syncService.uploadReminder(reminder).catchError((e) {
      debugPrint('Background sync failed for reminder: $e');
    });
  }

  Future<void> updateReminder(Reminder reminder) async {
    reminder.updatedAt = DateTime.now();
    final index = _reminders.indexWhere((r) => r.id == reminder.id);
    if (index != -1) {
      _reminders[index] = reminder;
      await _saveReminders();
      notifyListeners();
      // Sync to cloud in background
      _syncService.uploadReminder(reminder).catchError((e) {
        debugPrint('Background sync failed for reminder: $e');
      });
    }
  }

  Future<void> deleteReminder(String id) async {
    _reminders.removeWhere((r) => r.id == id);
    await _saveReminders();
    notifyListeners();
    // Sync to cloud in background
    _syncService.deleteReminder(id).catchError((e) {
      debugPrint('Background sync failed for reminder deletion: $e');
    });
  }

  List<Reminder> getRemindersByDate(DateTime date) {
    return _reminders.where((r) {
      return r.dateTime.year == date.year &&
             r.dateTime.month == date.month &&
             r.dateTime.day == date.day;
    }).toList();
  }

  // ==================== SYNC METHODS ====================

  /// Initial sync - downloads data from Firestore if available,
  /// otherwise uploads local data to cloud
  Future<void> initialSync() async {
    try {
      final cloudData = await _syncService.downloadAllData();
      
      // Check if cloud has any data
      final hasCloudData = 
          (cloudData['projects'] as List).isNotEmpty ||
          (cloudData['notes'] as List).isNotEmpty ||
          (cloudData['lists'] as List).isNotEmpty ||
          (cloudData['diary'] as List).isNotEmpty ||
          (cloudData['reminders'] as List).isNotEmpty;

      if (hasCloudData) {
        // Cloud has data - use it
        debugPrint('Using data from cloud');
        _projects = List<Project>.from(cloudData['projects']);
        _notes = List<Note>.from(cloudData['notes']);
        _lists = List<ListModel>.from(cloudData['lists']);
        _diaryEntries = List<DiaryEntry>.from(cloudData['diary']);
        _reminders = List<Reminder>.from(cloudData['reminders']);
        
        // Save to local storage
        await Future.wait([
          _saveProjects(),
          _saveNotes(),
          _saveLists(),
          _saveDiary(),
          _saveReminders(),
        ]);
      } else if (hasLocalData()) {
        // No cloud data, but has local - upload to cloud
        debugPrint('Uploading local data to cloud');
        await _syncService.uploadAllData(
          projects: _projects,
          notes: _notes,
          lists: _lists,
          diary: _diaryEntries,
          reminders: _reminders,
        );
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Initial sync error: $e');
    }
  }

  /// Manually trigger full sync
  Future<void> syncAll() async {
    await initialSync();
  }

  /// Check if has local data
  bool hasLocalData() {
    return _projects.isNotEmpty ||
           _notes.isNotEmpty ||
           _lists.isNotEmpty ||
           _diaryEntries.isNotEmpty ||
           _reminders.isNotEmpty;
  }
}

