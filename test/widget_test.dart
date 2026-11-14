// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';

void main() {
  testWidgets('Menekan tombol menampilkan Snackbar', (WidgetTester tester) async {
    // Build app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the NPM on app.
    expect(find.text('NPM'), findsOneWidget);

    // Verify that the logout button on app and trigger a frame.
    await tester.tap(find.text('Logout'));
    await tester.pump();

    // Verify that the SnackBar appear when button clicked.
    expect(find.text('Kamu telah menekan tombol Logout!'), findsOneWidget);
  });
}
