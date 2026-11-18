import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/utils/form_validators.dart';

/// Scroll sampai widget dengan [text] terlihat, lalu tap.
Future<void> scrollAndTap(WidgetTester tester, String text) async {
  await tester.ensureVisible(find.text(text));
  await tester.pumpAndSettle();
  await tester.tap(find.text(text));
  await tester.pumpAndSettle();
}

void main() {
  // ================= Validator =================
  group('Validator', () {
    test('teks wajib menolak isian kosong, hanya spasi, atau hanya tag HTML',
        () {
      expect(validateRequiredText(null, fieldName: 'Nama'), isNotNull);
      expect(validateRequiredText('   ', fieldName: 'Nama'), isNotNull);
      expect(validateRequiredText('<b></b>', fieldName: 'Nama'), isNotNull);
    });

    test('teks wajib menolak isian yang melebihi batas panjang', () {
      expect(
        validateRequiredText('a' * 256, fieldName: 'Nama', maxLength: 255),
        isNotNull,
      );
      expect(
        validateRequiredText('a' * 255, fieldName: 'Nama', maxLength: 255),
        isNull,
      );
    });

    test('URL opsional menerima kosong dan URL http/https yang valid', () {
      expect(validateOptionalUrl(''), isNull);
      expect(validateOptionalUrl('https://github.com/tanniajju'), isNull);
      expect(validateOptionalUrl('http://example.com'), isNull);
    });

    test('URL opsional menolak format salah dan URL yang terlalu panjang', () {
      expect(validateOptionalUrl('github.com/tanniajju'), isNotNull);
      expect(validateOptionalUrl('bukan url'), isNotNull);
      expect(
        validateOptionalUrl('https://example.com/${'a' * 200}', maxLength: 200),
        isNotNull,
      );
    });
  });

  // ================= Form Pengalaman =================
  group('Form Pengalaman', () {
    testWidgets('kartu Tambah Pengalaman membuka form pengalaman',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await scrollAndTap(tester, 'Tambah Pengalaman');

      expect(find.byType(ExperienceFormPage), findsOneWidget);
    });

    testWidgets('Simpan dengan isian kosong menampilkan pesan error',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ExperienceFormPage()));
      await scrollAndTap(tester, 'Simpan');

      expect(find.text('Nama pengalaman tidak boleh kosong!'), findsOneWidget);
      expect(
          find.text('Deskripsi pengalaman tidak boleh kosong!'), findsOneWidget);
      expect(find.text('Pilih kategori pengalaman!'), findsOneWidget);
      // Dialog tidak boleh muncul jika ada input yang tidak valid.
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('Simpan dengan isian valid menampilkan dialog ringkasan',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ExperienceFormPage()));

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nama Pengalaman').first,
        'Staff Acara Project Kesenian',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Deskripsi Pengalaman').first,
        'Mengatur rundown acara',
      );

      // Pilih kategori dari dropdown.
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Internship').last);
      await tester.pumpAndSettle();

      await scrollAndTap(tester, 'Simpan');

      expect(find.text('Pengalaman berhasil ditambahkan!'), findsOneWidget);
      expect(find.text('Nama Pengalaman: Staff Acara Project Kesenian'),
          findsOneWidget);
      expect(find.text('Kategori: Internship'), findsOneWidget);

      // Tombol OK menutup dialog dan kembali ke formulir.
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.byType(ExperienceFormPage), findsOneWidget);
    });
  });

  // ================= Form Proyek =================
  group('Form Proyek', () {
    testWidgets('kartu Tambah Proyek membuka form proyek',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await scrollAndTap(tester, 'Tambah Proyek');

      expect(find.byType(ProjectFormPage), findsOneWidget);
    });

    testWidgets('Save dengan isian kosong menampilkan pesan error',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ProjectFormPage()));
      await scrollAndTap(tester, 'Save');

      expect(find.text('Nama Proyek tidak boleh kosong!'), findsOneWidget);
      expect(find.text('Deskripsi Proyek tidak boleh kosong!'), findsOneWidget);
      expect(find.text('Tech Stack tidak boleh kosong!'), findsOneWidget);
      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
