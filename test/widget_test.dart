import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('Menekan tombol Logout menampilkan Snackbar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MyApp(apiClient: fakeApiClient()));

    // Verify that the NPM on app.
    expect(find.text('NPM'), findsOneWidget);

    // Scroll until the logout button is visible, because it is in the
    // second row of the 2-column grid (below the test screen).
    await tester.ensureVisible(find.text('Logout'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Logout'));
    await tester.pump();

    // Belum login, jadi SnackBar memberi tahu hal tersebut.
    expect(find.text('Kamu belum login.'), findsOneWidget);
  });
}
