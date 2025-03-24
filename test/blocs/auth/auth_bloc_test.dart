import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jaclean/main.dart'; // Import the main.dart file
import 'package:jaclean/blocs/auth/auth_bloc.dart';

// Mock classes
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUserCredential extends Mock implements UserCredential {}
class MockUser extends Mock implements User {}

void main() {
  group('AuthBloc', () {
    late MockFirebaseAuth mockFirebaseAuth;
    late AuthBloc authBloc;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      authBloc = AuthBloc(firebaseAuth: mockFirebaseAuth);
    });

    tearDown(() {
      authBloc.close();
    });

    test('initial state is AuthInitial', () {
      expect(authBloc.state, AuthInitial());
    });

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when LoginRequested is added and login is successful',
      build: () => authBloc,
      setUp: () {
        final mockUserCredential = MockUserCredential();
        final mockUser = MockUser();
        when(mockUserCredential.user).thenReturn(mockUser);
        when(mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password',
        )).thenAnswer((_) async => mockUserCredential);
        when(mockUser.emailVerified).thenReturn(true);
      },
      act: (bloc) => bloc.add(const LoginRequested('test@example.com', 'password')),
      expect: () => [
        AuthLoading(),
        AuthAuthenticated(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthEmailNotVerified] when LoginRequested is added and email is not verified',
      build: () => authBloc,
      setUp: () {
        final mockUserCredential = MockUserCredential();
        final mockUser = MockUser();
        when(mockUserCredential.user).thenReturn(mockUser);
        when(mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password',
        )).thenAnswer((_) async => mockUserCredential);
        when(mockUser.emailVerified).thenReturn(false);
      },
      act: (bloc) => bloc.add(const LoginRequested('test@example.com', 'password')),
      expect: () => [
        AuthLoading(),
        AuthEmailNotVerified(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when LoginRequested is added and login fails',
      build: () => authBloc,
      setUp: () {
        when(mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password',
        )).thenThrow(FirebaseAuthException(code: 'user-not-found'));
      },
      act: (bloc) => bloc.add(const LoginRequested('test@example.com', 'password')),
      expect: () => [
        AuthLoading(),
        AuthError('user-not-found'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthEmailNotVerified] when RegisterRequested is added and registration is successful',
      build: () => authBloc,
      setUp: () {
        final mockUserCredential = MockUserCredential();
        final mockUser = MockUser();
        when(mockUserCredential.user).thenReturn(mockUser);
        when(mockFirebaseAuth.createUserWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password',
        )).thenAnswer((_) async => mockUserCredential);
        when(mockUser.sendEmailVerification()).thenAnswer((_) async {});
      },
      act: (bloc) => bloc.add(const RegisterRequested('test@example.com', 'password')),
      expect: () => [
        AuthLoading(),
        AuthEmailNotVerified(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when RegisterRequested is added and registration fails',
      build: () => authBloc,
      setUp: () {
        when(mockFirebaseAuth.createUserWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password',
        )).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));
      },
      act: (bloc) => bloc.add(const RegisterRequested('test@example.com', 'password')),
      expect: () => [
        AuthLoading(),
        AuthError('email-already-in-use'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthInitial] when LogoutRequested is added',
      build: () => authBloc,
      setUp: () {
        when(mockFirebaseAuth.signOut()).thenAnswer((_) async {});
      },
      act: (bloc) => bloc.add(LogoutRequested()),
      expect: () => [
        AuthInitial(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthPasswordReset] when PasswordResetRequested is added and reset is successful',
      build: () => authBloc,
      setUp: () {
        when(mockFirebaseAuth.sendPasswordResetEmail(email: 'test@example.com')).thenAnswer((_) async {});
      },
      act: (bloc) => bloc.add(const PasswordResetRequested('test@example.com')),
      expect: () => [
        AuthLoading(),
        AuthPasswordReset(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when PasswordResetRequested is added and reset fails',
      build: () => authBloc,
      setUp: () {
        when(mockFirebaseAuth.sendPasswordResetEmail(email: 'test@example.com')).thenThrow(FirebaseAuthException(code: 'user-not-found'));
      },
      act: (bloc) => bloc.add(const PasswordResetRequested('test@example.com')),
      expect: () => [
        AuthLoading(),
        AuthError('user-not-found'),
      ],
    );
  });
}