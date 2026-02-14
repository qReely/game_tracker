import 'package:flutter_test/flutter_test.dart';
import 'package:game_tracker/features/auth/domain/auth_repository.dart';
import 'package:game_tracker/features/auth/domain/entities/app_user.dart';
import 'package:game_tracker/features/library/data/datasources/library_local_data_source.dart';
import 'package:game_tracker/features/library/data/models/local_library_item.dart';
import 'package:game_tracker/features/library/data/repositories/library_repository_impl.dart';
import 'package:game_tracker/features/library/domain/entities/library_item.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MockLibraryLocalDataSource extends Mock implements LibraryLocalDataSource {}
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockAuthRepository extends Mock implements AuthRepository {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
class MockWriteBatch extends Mock implements WriteBatch {}

class FakeLocalLibraryItem extends Fake implements LocalLibraryItem {}
class FakeDocumentReference extends Fake implements DocumentReference<Object?> {}
class FakeDocumentReferenceMap extends Fake implements DocumentReference<Map<String, Object?>> {}

void main() {
  late LibraryRepositoryImpl repository;
  late MockLibraryLocalDataSource mockLocalDataSource;
  late MockFirebaseFirestore mockFirestore;
  late MockAuthRepository mockAuthRepository;

  setUpAll(() {
    registerFallbackValue(FakeLocalLibraryItem());
    registerFallbackValue(FakeDocumentReference());
    registerFallbackValue(FakeDocumentReferenceMap());
    registerFallbackValue(LibraryItem(
      gameId: 0,
      gameName: '',
      status: GameStatus.backlog,
      addedAt: DateTime.now(),
    ));
  });

  setUp(() {
    mockLocalDataSource = MockLibraryLocalDataSource();
    mockFirestore = MockFirebaseFirestore();
    mockAuthRepository = MockAuthRepository();
    repository = LibraryRepositoryImpl(
      mockLocalDataSource,
      mockFirestore,
      mockAuthRepository,
    );
  });

  final tLibraryItem = LibraryItem(
    gameId: 1,
    gameName: 'Test Game',
    status: GameStatus.backlog,
    addedAt: DateTime(2023, 1, 1),
  );

  group('addToLibrary', () {
    test('should always save item locally', () async {
      when(() => mockLocalDataSource.saveItem(any())).thenAnswer((_) async {});
      when(() => mockAuthRepository.currentUser).thenReturn(null);

      await repository.addToLibrary(tLibraryItem);

      verify(() => mockLocalDataSource.saveItem(any())).called(1);
    });

    test('should not sync to Firestore if user is anonymous', () async {
      final tUser = AppUser(id: '1', email: 'guest', isAnonymous: true);
      when(() => mockAuthRepository.currentUser).thenReturn(tUser);
      when(() => mockLocalDataSource.saveItem(any())).thenAnswer((_) async {});

      await repository.addToLibrary(tLibraryItem);

      verifyNever(() => mockFirestore.collection(any()));
    });

    test('should sync to Firestore if user is NOT anonymous', () async {
      final tUser = AppUser(id: '123', email: 'test@me.com', isAnonymous: false);
      final mockCollection = MockCollectionReference();
      final mockDoc = MockDocumentReference();
      final mockLibCollection = MockCollectionReference();
      final mockGameDoc = MockDocumentReference();

      when(() => mockAuthRepository.currentUser).thenReturn(tUser);
      when(() => mockLocalDataSource.saveItem(any())).thenAnswer((_) async {});
      
      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);
      when(() => mockCollection.doc('123')).thenReturn(mockDoc);
      when(() => mockDoc.collection('library')).thenReturn(mockLibCollection);
      when(() => mockLibCollection.doc('1')).thenReturn(mockGameDoc);
      when(() => mockGameDoc.set(any())).thenAnswer((_) async {});

      await repository.addToLibrary(tLibraryItem);

      verify(() => mockGameDoc.set(any())).called(1);
    });
  });

  group('syncLocalToRemote', () {
    test('should do nothing if user is anonymous', () async {
       final tUser = AppUser(id: '1', email: 'guest', isAnonymous: true);
       when(() => mockAuthRepository.currentUser).thenReturn(tUser);

       await repository.syncLocalToRemote();

       verifyNever(() => mockFirestore.batch());
    });

    test('should sync all local items using batch if user is authenticated', () async {
      final tUser = AppUser(id: '123', email: 'test@me.com', isAnonymous: false);
      final tLocalItem = LocalLibraryItem()
        ..gameId = 1
        ..gameName = 'Test'
        ..status = GameStatus.playing;
      
      final mockBatch = MockWriteBatch();
      final mockCollection = MockCollectionReference();
      final mockDoc = MockDocumentReference();
      final mockLibCollection = MockCollectionReference();
      final mockGameDoc = MockDocumentReference();

      when(() => mockAuthRepository.currentUser).thenReturn(tUser);
      when(() => mockLocalDataSource.getAllItems()).thenAnswer((_) async => [tLocalItem]);
      when(() => mockFirestore.batch()).thenReturn(mockBatch);
      
      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);
      when(() => mockCollection.doc('123')).thenReturn(mockDoc);
      when(() => mockDoc.collection('library')).thenReturn(mockLibCollection);
      when(() => mockLibCollection.doc('1')).thenReturn(mockGameDoc);
      
      when(() => mockBatch.set<Map<String, Object?>>(any(), any())).thenReturn(null);
      when(() => mockBatch.commit()).thenAnswer((_) async {});

      await repository.syncLocalToRemote();

      verify(() => mockBatch.commit()).called(1);
      verify(() => mockBatch.set<Map<String, Object?>>(any(), any())).called(1);
    });
  });
}
