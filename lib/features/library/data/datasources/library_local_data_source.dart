import 'package:game_tracker/features/library/data/models/local_library_item.dart';
import 'package:isar_community/isar.dart';

abstract class LibraryLocalDataSource {
  Future<void> saveItem(LocalLibraryItem item);
  Stream<List<LocalLibraryItem>> watchLibrary();
  Future<LocalLibraryItem?> getItem(int gameId);

  Future<void> deleteItem(int gameId);
  Future<List<LocalLibraryItem>> getAllItems();
}

class LibraryLocalDataSourceImpl implements LibraryLocalDataSource {
  final Isar isar;
  LibraryLocalDataSourceImpl(this.isar);

  @override
  Future<void> saveItem(LocalLibraryItem item) async {
    await isar.writeTxn(() => isar.localLibraryItems.put(item));
  }

  @override
  Stream<List<LocalLibraryItem>> watchLibrary() {
    return isar.localLibraryItems.where().sortByAddedAtDesc().watch(fireImmediately: true);
  }

  @override
  Future<LocalLibraryItem?> getItem(int gameId) {
    return isar.localLibraryItems.filter().gameIdEqualTo(gameId).findFirst();
  }

  @override
  Future<void> deleteItem(int gameId) async {
    await isar.writeTxn(() => isar.localLibraryItems.filter().gameIdEqualTo(gameId).deleteAll());
  }

  @override
  Future<List<LocalLibraryItem>> getAllItems() async {
    return isar.localLibraryItems.where().findAll();
  }
}