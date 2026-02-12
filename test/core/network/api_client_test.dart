import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_tracker/core/network/api_client.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late ApiClient apiClient;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    when(() => mockDio.interceptors).thenReturn(Interceptors());
    apiClient = ApiClient(dio: mockDio);
  });

  test('should perform a GET request using the injected Dio', () async {
    // Arrange
    when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
        .thenAnswer((_) async => Response(requestOptions: RequestOptions(), statusCode: 200));

    // Act
    await apiClient.get('/test');

    // Assert
    verify(() => mockDio.get('/test', queryParameters: any(named: 'queryParameters'))).called(1);
  });

  test('should perform a GET request with the full URI', () async {
    // Arrange
    when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
        .thenAnswer((_) async => Response(requestOptions: RequestOptions(), statusCode: 200));

    // Act
    await apiClient.get('/games');

    // Assert
    // Use the actual full path that Dio would be trying to reach
    verify(() => mockDio.get('/games', queryParameters: any(named: 'queryParameters'))).called(1);
  });
}