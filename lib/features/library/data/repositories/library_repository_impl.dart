import 'package:game_tracker/features/auth/domain/auth_repository.dart';
import 'package:game_tracker/features/library/data/datasources/library_local_data_source.dart';
import 'package:game_tracker/features/library/data/models/local_library_item.dart';
import 'package:game_tracker/features/library/domain/entities/library_item.dart';
import 'package:game_tracker/features/library/domain/library_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:async';

class LibraryRepositoryImpl implements LibraryRepository {
  final LibraryLocalDataSource _localDataSource;
  final FirebaseFirestore _firestore;
  final AuthRepository _authRepository;
  StreamSubscription? _librarySubscription;

  LibraryRepositoryImpl(
      this._localDataSource,
      this._firestore,
      this._authRepository,
      ) {
    // Start sync immediately and listen for auth changes
    _authRepository.authStateChanges.listen((user) {
      initializeSync();
    });
  }

  String get _uid => _authRepository.currentUser?.id ?? '';

  @override
  Future<void> addToLibrary(LibraryItem item) async {
    // 1. Local Cache (Immediate)
    await _localDataSource.saveItem(LocalLibraryItem.fromEntity(item));

    if (_uid.isEmpty || _authRepository.currentUser?.isAnonymous == true) return;

    // 2. Firestore Sync
    final docRef = _firestore.collection('users').doc(_uid).collection('library').doc(item.gameId.toString());

    await docRef.set({
      'gameId': item.gameId,
      'gameName': item.gameName,
      'posterPath': item.posterPath,
      'status': item.status.name,
      'userRating': item.userRating,
      'privateNote': item.privateNote,
      'platforms': item.platforms,
      'releasedYear': item.releasedYear,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<List<LibraryItem>> getMyLibrary() {
    return _localDataSource.watchLibrary().map((items) => items
        .where((i) => i.status != GameStatus.none)
        .map((i) => i.toEntity())
        .toList());
  }

  @override
  Future<List<LibraryItem>> getUserLibrary(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('library')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return LibraryItem(
        gameId: data['gameId'],
        gameName: data['gameName'],
        posterPath: data['posterPath'],
        status: GameStatus.values.byName(data['status']),
        userRating: (data['userRating'] as num?)?.toDouble(),
        privateNote: null,
        playtimeMinutes: (data['playtimeMinutes'] as num?)?.toInt(),
        addedAt: (data['addedAt'] as Timestamp).toDate(),
      );
    }).toList();
  }

  @override
  Future<void> updateGameStatus(int gameId, GameStatus newStatus) async {
    final cached = await _localDataSource.getItem(gameId);
    if (cached == null) return;

    cached.status = newStatus;
    await _localDataSource.saveItem(cached);

    final userId = _authRepository.currentUser?.id;
    if (userId == null) return;

    if (_uid.isNotEmpty && _authRepository.currentUser?.isAnonymous == false) {
      await _firestore
        .collection('users')
        .doc(_uid)
        .collection('library')
        .doc(gameId.toString())
        .update({'status': newStatus.name});
    }
  }

  @override
  Future<void> removeFromLibrary(int gameId) async {
    await _localDataSource.deleteItem(gameId);

    final userId = _authRepository.currentUser?.id;
    if (userId == null) return;

    // Reference to the specific game in the library
    final gameDocRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('library')
        .doc(gameId.toString());

    // 2. Delete the private data document in the sub-collection
    // Sub-collections must be deleted manually document-by-document
    await gameDocRef
        .collection('restricted')
        .doc('private_data')
        .delete();

    // 3. Delete the main game document
    if (_authRepository.currentUser?.isAnonymous == false) {
       await gameDocRef.delete();
    }
  }


  @override
  Future<void> updatePrivateNote(int gameId, String note) async {
    final userId = _authRepository.currentUser?.id;
    if (userId == null) return;

    // 1. Update Isar (Local Cache)
    var localItem = await _localDataSource.getItem(gameId);
    if (localItem != null) {
      localItem.privateNote = note;
      await _localDataSource.saveItem(localItem);
    } else {
      // Create a "ghost" entry to hold the note
      localItem = LocalLibraryItem()
        ..gameId = gameId
        ..gameName = "Game" // Fallback name, ideally passed from caller
        ..status = GameStatus.none
        ..privateNote = note
        ..addedAt = DateTime.now();
      await _localDataSource.saveItem(localItem);
    }

    // 2. Update Firestore
    if (_authRepository.currentUser?.isAnonymous == true) return;
    
    // We set (not update) because the main library doc might not exist
    await _firestore
      .collection('users')
      .doc(userId)
      .collection('library')
      .doc(gameId.toString())
      .collection('restricted')
      .doc('private_data')
      .set({
        'privateNote': note,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
  }

  @override
  Future<void> updateUserRating(int gameId, double rating) async {
    final userId = _authRepository.currentUser?.id;
    if (userId == null) return;

    // 1. Update Isar (Local Cache)
    var localItem = await _localDataSource.getItem(gameId);
    if (localItem != null) {
      localItem.userRating = rating;
      await _localDataSource.saveItem(localItem);
    } else {
      localItem = LocalLibraryItem()
        ..gameId = gameId
        ..gameName = "Game"
        ..status = GameStatus.none
        ..userRating = rating
        ..addedAt = DateTime.now();
      await _localDataSource.saveItem(localItem);
    }

    // 2. Update Firestore
    if (_authRepository.currentUser?.isAnonymous == true) return;
    
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('library')
        .doc(gameId.toString())
        .set({'userRating': rating, 'gameId': gameId}, SetOptions(merge: true));

    // 3. Update Global Collective Rating
    final ratingRef = _firestore.collection('ratings').doc(gameId.toString());
    
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(ratingRef);
      
      if (!snapshot.exists) {
        transaction.set(ratingRef, {
          'totalStars': rating,
          'totalVotes': 1,
          'average': rating,
        });
      } else {
        final data = snapshot.data()!;
        final oldRating = localItem?.userRating ?? 0.0;
        final newTotalStars = (data['totalStars'] as num).toDouble() - oldRating + rating;
        final newTotalVotes = data['totalVotes'] + (oldRating == 0 ? 1 : 0);
        
        transaction.update(ratingRef, {
          'totalStars': newTotalStars,
          'totalVotes': newTotalVotes,
          'average': newTotalStars / newTotalVotes,
        });
      }
    });
  }

  @override
  Future<void> updatePlaytime(int gameId, int minutes) async {
    final userId = _authRepository.currentUser?.id;
    if (userId == null) return;

    // 1. Update Isar (Local Cache)
    var localItem = await _localDataSource.getItem(gameId);
    if (localItem != null) {
      localItem.playtimeMinutes = minutes;
      await _localDataSource.saveItem(localItem);
    } else {
      localItem = LocalLibraryItem()
        ..gameId = gameId
        ..gameName = "Game"
        ..status = GameStatus.none
        ..playtimeMinutes = minutes
        ..addedAt = DateTime.now();
      await _localDataSource.saveItem(localItem);
    }

    // 2. Update Firestore
    if (_authRepository.currentUser?.isAnonymous == true) return;

    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('library')
        .doc(gameId.toString())
        .set({'playtimeMinutes': minutes, 'gameId': gameId}, SetOptions(merge: true));
  }

  @override
  Stream<Map<String, dynamic>?> getAverageRating(int gameId) {
    return _firestore
        .collection('ratings')
        .doc(gameId.toString())
        .snapshots()
        .map((doc) => doc.data());
  }


  @override
  Future<void> syncLocalToRemote() async {
    final user = _authRepository.currentUser;
    if (user == null || user.isAnonymous) return;

    final localItems = await _localDataSource.getAllItems();
    if (localItems.isEmpty) return;

    final batch = _firestore.batch();
    final userLibraryRef = _firestore.collection('users').doc(user.id).collection('library');

    for (var item in localItems) {
      final docRef = userLibraryRef.doc(item.gameId.toString());
      
      batch.set(docRef, {
        'gameId': item.gameId,
        'gameName': item.gameName,
        'posterPath': item.posterPath,
        'status': item.status.name,
        'userRating': item.userRating,
        'privateNote': item.privateNote,
        'platforms': item.platforms,
        'releasedYear': item.releasedYear,
        'playtimeMinutes': item.playtimeMinutes,
        'addedAt': FieldValue.serverTimestamp(),
      });

      // Also sync private note to restricted if it exists
      if (item.privateNote != null && item.privateNote!.isNotEmpty) {
        final restrictedRef = docRef.collection('restricted').doc('private_data');
        batch.set(restrictedRef, {
          'privateNote': item.privateNote,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    }

    await batch.commit();
  }

  @override
  Future<void> initializeSync() async {
    await _librarySubscription?.cancel();

    if (_uid.isEmpty || _authRepository.currentUser?.isAnonymous == true) return;

    _librarySubscription = _firestore
        .collection('users')
        .doc(_uid)
        .collection('library')
        .snapshots()
        .listen((snapshot) async {
      for (var change in snapshot.docChanges) {
        final data = change.doc.data();
        if (data == null) continue;

        final gameId = (data['gameId'] as num).toInt();

        if (change.type == DocumentChangeType.removed) {
          await _localDataSource.deleteItem(gameId);
        } else {
          // Check for existing local item to preserve fields not in Firestore main doc if any
          final existing = await _localDataSource.getItem(gameId);
          
          // Fetch private note from subcollection if it exists
          String? privateNote;
          final privateDataDoc = await change.doc.reference.collection('restricted').doc('private_data').get();
          if (privateDataDoc.exists) {
            privateNote = privateDataDoc.data()?['privateNote'] as String?;
          }

          final item = LocalLibraryItem()
            ..gameId = gameId
            ..gameName = data['gameName'] ?? 'Game'
            ..posterPath = data['posterPath']
            ..status = GameStatus.values.byName(data['status'] ?? 'none')
            ..userRating = (data['userRating'] as num?)?.toDouble()
            ..playtimeMinutes = (data['playtimeMinutes'] as num?)?.toInt()
            ..privateNote = privateNote // Use the note fetched from subcollection
            ..platforms = data['platforms'] != null ? List<String>.from(data['platforms']) : []
            ..releasedYear = data['releasedYear']
            ..addedAt = (data['addedAt'] as Timestamp?)?.toDate() ?? existing?.addedAt ?? DateTime.now();

          // If it was modified or added, we update local Isar
          await _localDataSource.saveItem(item);
        }
      }
    });
  }
}