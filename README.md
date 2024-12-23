# musika

# runs build_runner with watch mode and deleting conflicting files
dart run build_runner watch -d

# AsyncValue
- AsyncValue class is part of the Riverpod library, which is used for state management in Flutter. AsyncValue is a type that can hold a value that is being loaded asynchronously, and it has three states: loading, data, and error

# How you can get access to ref in main method before provider scope
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  ProviderContainer container = ProviderContainer();
  await container.read(authViewModelProvider.notifier).initSharedPreferences();
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

//





//
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class MockHttpClient extends Mock implements http.Client {}
class MockLogger extends Mock implements Logger {}

void main() {
  group('AuthRemoteRepository', () {
    late MockHttpClient _mockHttpClient;
    late MockLogger _mockLogger;
    late AuthRemoteRepository _repository;

    setUp(() {
      _mockHttpClient = MockHttpClient();
      _mockLogger = MockLogger();
      _repository = AuthRemoteRepository(_mockHttpClient, _mockLogger);
    });

    test('signup', () async {
      // Arrange
      final response = http.Response('success', 201);
      when(_mockHttpClient.post(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => response);

      // Act
      await _repository.signup('name', 'email', 'password');

      // Assert
      verify(_mockHttpClient.post(Uri.parse('http://10.0.2.2:8000/auth/signup'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'name': 'name', 'email': 'email', 'password': 'password'})));
      verify(_mockLogger.i(response.body));
      verify(_mockLogger.i(response.statusCode));
    });

    test('signup error', () async {
      // Arrange
      final error = Exception('error');
      when(_mockHttpClient.post(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenThrow(error);

      // Act
      await _repository.signup('name', 'email', 'password');

      // Assert
      verify(_mockLogger.e('error'));
    });
  });
}