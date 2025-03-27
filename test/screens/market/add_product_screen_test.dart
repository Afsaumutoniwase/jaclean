import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';
import 'package:jaclean/presentation/screens/market/add_product_page.dart';

// Mock ImagePicker
class MockImagePicker extends Mock implements ImagePicker {
  @override
  Future<XFile?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) async {
    return XFile('/path/to/image.jpg');
  }
}

void main() {
  group('AddProductPage Widget Tests', () {
    late MockImagePicker mockImagePicker;

    setUp(() {
      mockImagePicker = MockImagePicker();
    });

    // Helper function to create the widget under test
    Widget createWidgetUnderTest() {
      return const MaterialApp(
        home: Scaffold(
          body: AddProductPage(),
        ),
      );
    }


    testWidgets('Item state dropdown can be changed', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Find the dropdown
      final dropdown = find.byType(DropdownButtonFormField<String>);
      expect(dropdown, findsOneWidget, reason: 'Dropdown should be found');

      // Tap to open the dropdown
      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      // Find and tap 'Fairly used'
      final fairlyUsedOption = find.text('Fairly used').last;
      await tester.tap(fairlyUsedOption);
      await tester.pumpAndSettle();

      // Verify the dropdown now shows 'Fairly used'
      expect(find.text('Fairly used'), findsOneWidget);
    });

    testWidgets('Upload section can be switched using radio buttons', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Find the 'Charity Donation' radio button using text
      final charityDonationRadio = find.text('Charity Donation');
      expect(charityDonationRadio, findsOneWidget, reason: 'Charity Donation radio button should be found');

      // Scroll to make sure the radio button is visible
      await tester.scrollUntilVisible(
          charityDonationRadio,
          50.0,
          scrollable: find.byType(Scrollable).first
      );

      // Tap the 'Charity Donation' radio button
      await tester.tap(charityDonationRadio);
      await tester.pump();
    });

    testWidgets('Tapping add photo initiates image picker', (WidgetTester tester) async {
      // Note: You'll need to modify AddProductPage to accept an ImagePicker
      // or use a dependency injection approach
      await tester.pumpWidget(createWidgetUnderTest());

      // Find the 'Add photo' gesture detector
      final addPhotoGesture = find.text('Add photo');
      expect(addPhotoGesture, findsOneWidget, reason: 'Add photo button should be found');

      // Tap the add photo gesture
      await tester.tap(addPhotoGesture);
      await tester.pumpAndSettle();

      // Note: Actual verification of image picker depends on implementation
    });
  });
}