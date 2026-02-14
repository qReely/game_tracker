import 'package:game_tracker/features/auth/domain/auth_repository.dart';
import 'package:game_tracker/features/library/data/datasources/library_local_data_source.dart';
import 'package:game_tracker/features/library/data/models/local_library_item.dart';
import 'package:game_tracker/features/library/domain/entities/library_item.dart';
import 'package:game_tracker/features/library/domain/library_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  final LibraryLocalDataSource _localDataSource;
  final FirebaseFirestore _firestore;
  final AuthRepository _authRepository;

  LibraryRepositoryImpl(
      this._localDataSource,
      this._firestore,
      this._authRepository,
      );

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
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<List<LibraryItem>> getMyLibrary() {
    return _localDataSource.watchLibrary().map((items) => items.map((i) => i.toEntity()).toList(),);
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
    final localItem = await _localDataSource.getItem(gameId);
    if (localItem != null) {
      localItem.privateNote = note;
      await _localDataSource.saveItem(localItem);
    }

    // 2. Update Firestore
    if (_authRepository.currentUser?.isAnonymous == true) return;
    
    await _firestore
      .collection('users')
      .doc(userId)
      .collection('library')
      .doc(gameId.toString())
      .collection('restricted')
      .doc('private_data')
      .set({
        'privateNote': note, // note is saved into a 'restricted' sub-collection
        'updatedAt': FieldValue.serverTimestamp(),
      },
    );
  }

  @override
  Future<void> updateUserRating(int gameId, double rating) async {
    final userId = _authRepository.currentUser?.id;
    if (userId == null) return;

    // 1. Update Isar (Local Cache)
    final localItem = await _localDataSource.getItem(gameId);
    if (localItem != null) {
      localItem.userRating = rating;
      await _localDataSource.saveItem(localItem);
    }

    // 2. Update Firestore
    if (_authRepository.currentUser?.isAnonymous == true) return;
    
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('library')
        .doc(gameId.toString())
        .update({'userRating': rating});
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
        'privateNote': item.privateNote, // Note: Simplification for sync, ideally privateNote goes to subcollection
        'addedAt': FieldValue.serverTimestamp(), // Use server timestamp to avoid clock skew
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
}