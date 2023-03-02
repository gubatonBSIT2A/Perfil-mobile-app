import 'package:perfil/services/auth/auth_exceptions.dart';
import 'package:perfil/services/auth/auth_provider.dart';
import 'package:perfil/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('Should not be initialized to begin with', () {
      expect(provider.isInitialized, false);
    });
    test('cannot logout if not initialized', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });
    test('should be able to be initialized', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });
    test('user should be null after initialization', () {
      expect(provider.currentUser, null);
    });
    test(
      'should be able to initialize in less than 2 seconds',
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );
    test('create user should delegate to login function', () async {
      final badEmailUser = provider.createUser(
        email: 'test@hehe.com',
        password: 'password',
        firstName: 'John ',
        middleName: 'Doe',
        lastName: 'Malagkit',
        birthday: '09/09/1969'
      );
      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));
      final badPasswordUser = provider.createUser(
        email: 'email',
        password: 'hehehehe',
        firstName: 'John ',
        middleName: 'Doe',
        lastName: 'Malagkit',
          birthday: '09/09/1969'
      );
      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));
      final invalidEmailUser = provider.createUser(
        email: 'testhehe.com',
        password: 'password',
        firstName: 'John ',
        middleName: 'Doe',
        lastName: 'Malagkit',
          birthday: '09/09/1969'
      );
      expect(invalidEmailUser,
          throwsA(const TypeMatcher<InvalidEmailAuthException>()));
      final disabledAccountUser = provider.createUser(
        email: 'disabled@email.com',
        password: 'password',
        firstName: 'John ',
        middleName: 'Doe',
        lastName: 'Malagkit',
          birthday: '09/09/1969'
      );
      expect(disabledAccountUser,
          throwsA(const TypeMatcher<UserDisabledAuthException>()));
      final user = await provider.createUser(
        email: 'yey@gmail.com',
        password: 'password',
        firstName: 'John ',
        middleName: 'Doe',
        lastName: 'Malagkit',
          birthday: '09/09/1969'
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });
    test('logged in user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });
    test('should be able to logout and login again', () async {
      await provider.logOut();
      await provider.logIn(
        email: 'user',
        password: 'password',
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String firstName,
    required String middleName,
    required String lastName,
    required String email,
    required String password,
    required String birthday,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'test@hehe.com') throw UserNotFoundAuthException();
    if (password == 'hehehehe') throw WrongPasswordAuthException();
    if (email == 'testhehe.com') throw InvalidEmailAuthException();
    if (email == 'disabled@email.com') throw UserDisabledAuthException();
    const user = AuthUser(isEmailVerified: false, email: 'sample@gmail.com', id: 'anyid');
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true, email: 'sample@gmail.com', id: 'anyid');
    _user = newUser;
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) {
    // TODO: implement sendPasswordReset
    throw UnimplementedError();
  }
}
