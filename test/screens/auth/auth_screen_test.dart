import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaclean/blocs/auth/auth_bloc.dart';
import 'package:jaclean/presentation/screens/auth/forgot_password_screen.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'auth_screen_test.mocks.dart';

@GenerateMocks([AuthBloc])
void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    when(mockAuthBloc.state).thenReturn(AuthInitial());
    when(mockAuthBloc.stream).thenAnswer((_) => Stream<AuthState>.empty());
  });

  Widget wrapWithBloc(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: child,
        ),
      ),
    );
  }

  group('ForgotPasswordScreen', () {
    testWidgets('shows error if email field is empty', (tester) async {
      await tester.pumpWidget(wrapWithBloc(ForgotPasswordScreen()));

      // Simulate form submission without entering an email
      await tester.tap(find.byType(ElevatedButton)); // Assuming there's a submit button
      await tester.pump();

      // Check for validation message
      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('dispatches PasswordResetRequested if email is entered', (tester) async {
      await tester.pumpWidget(wrapWithBloc(ForgotPasswordScreen()));

      // Enter a valid email
      await tester.enterText(find.byType(TextFormField), 'user@example.com');
      await tester.tap(find.byType(ElevatedButton)); // Assuming there's a submit button
      await tester.pump();

      // Verify that the correct event is dispatched
      verify(mockAuthBloc.add(PasswordResetRequested('user@example.com'))).called(1);
    });
  });
}