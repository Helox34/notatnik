import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/project.dart';
import '../models/note.dart';
import '../models/list_model.dart';
import '../models/diary_entry.dart';
import '../models/reminder.dart';

enum SyncStatus {
  synced,
  syncing,
  error,
  offline,
}

class FirebaseSyncService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  SyncStatus _status = SyncStatus.synced;
  DateTime? _lastSyncTime;
  String? _errorMessage;
  int _pendingOperations = 0;

  SyncStatus get status => _status;
  DateTime? get lastSyncTime => _lastSyncTime;
  String? get errorMessage => _errorMessage;
  int get pendingOperations => _pendingOperations;

  String? get _userId => _auth.currentUser?.uid;

  // Update status and notify listeners
  void _updateStatus(SyncStatus newStatus, {String? error}) {
    _status = newStatus;
    _errorMessage = error;
    if (newStatus == SyncStatus.synced) {
      _lastSyncTime = DateTime.now();
      _pendingOperations = 0;
    }
    notifyListeners();
  }

  // ==================== PROJECTS ====================

  Future<void> uploadProject(Project project) async {
    if (_userId == null) return;
    
    try {
      _pendingOperations++;
      _updateStatus(SyncStatus.syncing);
      
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('projects')
          .doc(project.id)
          .set(project.toJson());
      
      _pendingOperations--;
      if (_pendingOperations == 0) _updateStatus(SyncStatus.synced);
    } catch (e) {
      _pendingOperations--;
      debugPrint('Error uploading project: $e');
      _updateStatus(SyncStatus.error, error: e.toString());
    }
  }

  Future<void> deleteProject(String projectId) async {
    if (_userId == null) return;
    
    try {
      _pendingOperations++;
      _updateStatus(SyncStatus.syncing);
      
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('projects')
          .doc(projectId)
          .delete();
      
      _pendingOperations--;
      if (_pendingOperations == 0) _updateStatus(SyncStatus.synced);
    } catch (e) {
      _pendingOperations--;
      debugPrint('Error deleting project: $e');
      _updateStatus(SyncStatus.error, error: e.toString());
    }
  }

  Future<List<Project>> downloadProjects() async {
    if (_userId == null) return [];
    
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('projects')
          .get();
      
      return snapshot.docs
          .map((doc) => Project.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error downloading projects: $e');
      return [];
    }
  }

  // ==================== NOTES ====================

  Future<void> uploadNote(Note note) async {
    if (_userId == null) return;
    
    try {
      _pendingOperations++;
      _updateStatus(SyncStatus.syncing);
      
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('notes')
          .doc(note.id)
          .set(note.toJson());
      
      _pendingOperations--;
      if (_pendingOperations == 0) _updateStatus(SyncStatus.synced);
    } catch (e) {
      _pendingOperations--;
      debugPrint('Error uploading note: $e');
      _updateStatus(SyncStatus.error, error: e.toString());
    }
  }

  Future<void> deleteNote(String noteId) async {
    if (_userId == null) return;
    
    try {
      _pendingOperations++;
      _updateStatus(SyncStatus.syncing);
      
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('notes')
          .doc(noteId)
          .delete();
      
      _pendingOperations--;
      if (_pendingOperations == 0) _updateStatus(SyncStatus.synced);
    } catch (e) {
      _pendingOperations--;
      debugPrint('Error deleting note: $e');
      _updateStatus(SyncStatus.error, error: e.toString());
    }
  }

  Future<List<Note>> downloadNotes() async {
    if (_userId == null) return [];
    
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('notes')
          .get();
      
      return snapshot.docs
          .map((doc) => Note.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error downloading notes: $e');
      return [];
    }
  }

  // ==================== LISTS ====================

  Future<void> uploadList(ListModel list) async {
    if (_userId == null) return;
    
    try {
      _pendingOperations++;
      _updateStatus(SyncStatus.syncing);
      
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('lists')
          .doc(list.id)
          .set(list.toJson());
      
      _pendingOperations--;
      if (_pendingOperations == 0) _updateStatus(SyncStatus.synced);
    } catch (e) {
      _pendingOperations--;
      debugPrint('Error uploading list: $e');
      _updateStatus(SyncStatus.error, error: e.toString());
    }
  }

  Future<void> deleteList(String listId) async {
    if (_userId == null) return;
    
    try {
      _pendingOperations++;
      _updateStatus(SyncStatus.syncing);
      
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('lists')
          .doc(listId)
          .delete();
      
      _pendingOperations--;
      if (_pendingOperations == 0) _updateStatus(SyncStatus.synced);
    } catch (e) {
      _pendingOperations--;
      debugPrint('Error deleting list: $e');
      _updateStatus(SyncStatus.error, error: e.toString());
    }
  }

  Future<List<ListModel>> downloadLists() async {
    if (_userId == null) return [];
    
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('lists')
          .get();
      
      return snapshot.docs
          .map((doc) => ListModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error downloading lists: $e');
      return [];
    }
  }

  // ==================== DIARY ====================

  Future<void> uploadDiaryEntry(DiaryEntry entry) async {
    if (_userId == null) return;
    
    try {
      _pendingOperations++;
      _updateStatus(SyncStatus.syncing);
      
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('diary')
          .doc(entry.id)
          .set(entry.toJson());
      
      _pendingOperations--;
      if (_pendingOperations == 0) _updateStatus(SyncStatus.synced);
    } catch (e) {
      _pendingOperations--;
      debugPrint('Error uploading diary entry: $e');
      _updateStatus(SyncStatus.error, error: e.toString());
    }
  }

  Future<void> deleteDiaryEntry(String entryId) async {
    if (_userId == null) return;
    
    try {
      _pendingOperations++;
      _updateStatus(SyncStatus.syncing);
      
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('diary')
          .doc(entryId)
          .delete();
      
      _pendingOperations--;
      if (_pendingOperations == 0) _updateStatus(SyncStatus.synced);
    } catch (e) {
      _pendingOperations--;
      debugPrint('Error deleting diary entry: $e');
      _updateStatus(SyncStatus.error, error: e.toString());
    }
  }

  Future<List<DiaryEntry>> downloadDiaryEntries() async {
    if (_userId == null) return [];
    
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('diary')
          .get();
      
      return snapshot.docs
          .map((doc) => DiaryEntry.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error downloading diary entries: $e');
      return [];
    }
  }

  // ==================== REMINDERS ====================

  Future<void> uploadReminder(Reminder reminder) async {
    if (_userId == null) return;
    
    try {
      _pendingOperations++;
      _updateStatus(SyncStatus.syncing);
      
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('reminders')
          .doc(reminder.id)
          .set(reminder.toJson());
      
      _pendingOperations--;
      if (_pendingOperations == 0) _updateStatus(SyncStatus.synced);
    } catch (e) {
      _pendingOperations--;
      debugPrint('Error uploading reminder: $e');
      _updateStatus(SyncStatus.error, error: e.toString());
    }
  }

  Future<void> deleteReminder(String reminderId) async {
    if (_userId == null) return;
    
    try {
      _pendingOperations++;
      _updateStatus(SyncStatus.syncing);
      
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('reminders')
          .doc(reminderId)
          .delete();
      
      _pendingOperations--;
      if (_pendingOperations == 0) _updateStatus(SyncStatus.synced);
    } catch (e) {
      _pendingOperations--;
      debugPrint('Error deleting reminder: $e');
      _updateStatus(SyncStatus.error, error: e.toString());
    }
  }

  Future<List<Reminder>> downloadReminders() async {
    if (_userId == null) return [];
    
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('reminders')
          .get();
      
      return snapshot.docs
          .map((doc) => Reminder.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error downloading reminders: $e');
      return [];
    }
  }

  // ==================== FULL SYNC ====================

  Future<Map<String, dynamic>> downloadAllData() async {
    if (_userId == null) {
      return {
        'projects': <Project>[],
        'notes': <Note>[],
        'lists': <ListModel>[],
        'diary': <DiaryEntry>[],
        'reminders': <Reminder>[],
      };
    }

    try {
      _updateStatus(SyncStatus.syncing);

      // Add timeout to prevent hanging during login
      final results = await Future.wait([
        downloadProjects(),
        downloadNotes(),
        downloadLists(),
        downloadDiaryEntries(),
        downloadReminders(),
      ]).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('Sync timeout - returning empty data');
          return [<Project>[], <Note>[], <ListModel>[], <DiaryEntry>[], <Reminder>[]];
        },
      );

      _updateStatus(SyncStatus.synced);

      return {
        'projects': results[0],
        'notes': results[1],
        'lists': results[2],
        'diary': results[3],
        'reminders': results[4],
      };
    } catch (e) {
      debugPrint('Error downloading all data: $e');
      _updateStatus(SyncStatus.error, error: e.toString());
      return {
        'projects': <Project>[],
        'notes': <Note>[],
        'lists': <ListModel>[],
        'diary': <DiaryEntry>[],
        'reminders': <Reminder>[],
      };
    }
  }

  Future<void> uploadAllData({
    required List<Project> projects,
    required List<Note> notes,
    required List<ListModel> lists,
    required List<DiaryEntry> diary,
    required List<Reminder> reminders,
  }) async {
    if (_userId == null) return;

    try {
      _updateStatus(SyncStatus.syncing);

      final batch = _firestore.batch();
      final userDoc = _firestore.collection('users').doc(_userId);

      // Upload projects
      for (final project in projects) {
        batch.set(
          userDoc.collection('projects').doc(project.id),
          project.toJson(),
        );
      }

      // Upload notes
      for (final note in notes) {
        batch.set(
          userDoc.collection('notes').doc(note.id),
          note.toJson(),
        );
      }

      // Upload lists
      for (final list in lists) {
        batch.set(
          userDoc.collection('lists').doc(list.id),
          list.toJson(),
        );
      }

      // Upload diary
      for (final entry in diary) {
        batch.set(
          userDoc.collection('diary').doc(entry.id),
          entry.toJson(),
        );
      }

      // Upload reminders
      for (final reminder in reminders) {
        batch.set(
          userDoc.collection('reminders').doc(reminder.id),
          reminder.toJson(),
        );
      }

      await batch.commit();
      _updateStatus(SyncStatus.synced);
    } catch (e) {
      debugPrint('Error uploading all data: $e');
      _updateStatus(SyncStatus.error, error: e.toString());
    }
  }
}
