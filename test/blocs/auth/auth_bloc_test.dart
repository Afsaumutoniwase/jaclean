import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jaclean/blocs/auth/auth_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late AuthBloc authBloc;

  setUpAll(() {
    registerFallbackValue(MockUserCredential());
  });

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    authBloc = AuthBloc(firebaseAuth: mockFirebaseAuth);
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc Tests', () {
    test('initial state is AuthInitial', () {
      expect(authBloc.state, AuthInitial());
      print('Test Passed: initial state is AuthInitial');
    });

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] on successful verified login',
      build: () {
        final mockUser = MockUser(
          email: 'test@example.com',
          isEmailVerified: true, // Ensure email is verified
        );

        final mockUserCredential = MockUserCredential();

        // Mock the user returned by userCredential.user
        when(() => mockUserCredential.user).thenReturn(mockUser);

        // Mock the sign-in behavior
        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => mockUserCredential);

        return AuthBloc(firebaseAuth: mockFirebaseAuth);
      },
      act: (bloc) => bloc.add(LoginRequested('test@example.com', 'password123')),
      expect: () => [AuthLoading(), AuthAuthenticated()],
      verify: (_) => print('Test Passed: emits [AuthLoading, AuthAuthenticated] on successful verified login'),
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthEmailNotVerified] on unverified email login',
      build: () {
        final mockUser = MockUser(
          email: 'test@example.com',
          isEmailVerified: false, // Email is not verified
        );

        final mockUserCredential = MockUserCredential();

        // Mock the user returned by userCredential.user
        when(() => mockUserCredential.user).thenReturn(mockUser);

        // Mock the sign-in behavior
        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => mockUserCredential);

        return AuthBloc(firebaseAuth: mockFirebaseAuth);
      },
      act: (bloc) => bloc.add(LoginRequested('test@example.com', 'password123')),
      expect: () => [AuthLoading(), AuthEmailNotVerified()],
      verify: (_) => print('Test Passed: emits [AuthLoading, AuthEmailNotVerified] on unverified email login'),
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] on login failure',
      build: () {
        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(FirebaseAuthException(
          code: 'user-not-found',
          message: 'No user found with this email.',
        ));

        return AuthBloc(firebaseAuth: mockFirebaseAuth);
      },
      act: (bloc) => bloc.add(LoginRequested('bad@example.com', 'wrongpass')),
      expect: () => [
        AuthLoading(),
        AuthError('[firebase_auth/user-not-found] No user found with this email.'),
      ],
      verify: (_) => print('Test Passed: emits [AuthLoading, AuthError] on login failure'),
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthPasswordReset] on successful password reset',
      build: () {
        when(() => mockFirebaseAuth.sendPasswordResetEmail(
              email: any(named: 'email'),
            )).thenAnswer((_) async => Future.value());

        return AuthBloc(firebaseAuth: mockFirebaseAuth);
      },
      act: (bloc) => bloc.add(PasswordResetRequested('user@example.com')),
      expect: () => [AuthLoading(), AuthPasswordReset()],
      verify: (_) => print('Test Passed: emits [AuthLoading, AuthPasswordReset] on successful password reset'),
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] on password reset failure',
      build: () {
        when(() => mockFirebaseAuth.sendPasswordResetEmail(
              email: any(named: 'email'),
            )).thenThrow(FirebaseAuthException(
          code: 'invalid-email',
          message: 'The email address is badly formatted.',
        ));

        return AuthBloc(firebaseAuth: mockFirebaseAuth);
      },
      act: (bloc) => bloc.add(PasswordResetRequested('invalid-email')),
      expect: () => [
        AuthLoading(),
        AuthError('[firebase_auth/invalid-email] The email address is badly formatted.'),
      ],
      verify: (_) => print('Test Passed: emits [AuthLoading, AuthError] on password reset failure'),
    );
  });
}