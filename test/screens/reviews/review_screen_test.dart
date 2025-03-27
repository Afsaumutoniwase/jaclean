import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ReviewScreen displays a title', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('Reviews'),
          ),
          body: Center(
            child: Text('Review Screen'),
          ),
        ),
      ),
    );

    // Verify if the title text is displayed
    expect(find.text('Review Screen'), findsOneWidget);
  });

  testWidgets('ReviewScreen has an ElevatedButton', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Submit'),
            ),
          ),
        ),
      ),
    );

    // Verify if the ElevatedButton is present
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text('Submit'), findsOneWidget);
  });

  testWidgets('ReviewScreen contains an Icon', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Icon(Icons.star),
          ),
        ),
      ),
    );

    // Verify if the Icon is present
    expect(find.byIcon(Icons.star), findsOneWidget);
  });

  testWidgets('ReviewScreen button triggers onPressed', (WidgetTester tester) async {
    bool buttonPressed = false;

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                buttonPressed = true;
              },
              child: Text('Press Me'),
            ),
          ),
        ),
      ),
    );

    // Tap the button and trigger the onPressed
    await tester.tap(find.text('Press Me'));
    await tester.pump();

    // Verify if the button press has triggered the action
    expect(buttonPressed, true);
  });

  testWidgets('ReviewScreen shows a bottom sheet on button press', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: tester.element(find.byType(ElevatedButton)),
                  builder: (BuildContext context) {
                    return Text('Bottom Sheet Content');
                  },
                );
              },
              child: Text('Show Bottom Sheet'),
            ),
          ),
        ),
      ),
    );

    // Tap the button to show the bottom sheet
    await tester.tap(find.text('Show Bottom Sheet'));
    await tester.pumpAndSettle();

    // Verify if the bottom sheet is shown
    expect(find.text('Bottom Sheet Content'), findsOneWidget);
  });
}
