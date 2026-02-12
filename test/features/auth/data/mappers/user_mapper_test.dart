import 'package:flutter_test/flutter_test.dart';
import 'package:game_tracker/features/auth/domain/entities/app_user.dart';

class FakeFirebaseUser {
  final String uid = '123';
  final String email = 'test@example.com';
  final String displayName = 'Gamer One';
}

void main() {
  test('toEntity should convert Firebase User data into AppUser Entity', () {
    // 1. Arrange
    final fakeUser = FakeFirebaseUser();

    // 2. Act
    final result = AppUser(
      id: fakeUser.uid,
      email: fakeUser.email,
      displayName: fakeUser.displayName,
    );

    // 3. Assert
    expect(result.id, '123');
    expect(result.email, 'test@example.com');
    expect(result.displayName, 'Gamer One');
  });
}