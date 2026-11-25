// Fungsi bantu validasi yang dipakai untuk forms
// Aturannya sama seperti validasi pada porto web

/// Menghapus tag HTML dari teks, meniru `strip_tags()` di forms.py web
String stripHtml(String value) => value.replaceAll(RegExp(r'<[^>]*>'), '');

/// Validasi field teks wajib: tidak boleh kosong, hanya spasi, atau hanya
/// berisi tag HTML, dan tidak melebihi [maxLength] karakter (jika diberikan)
String? validateRequiredText(
  String? value, {
  required String fieldName,
  int? maxLength,
}) {
  final text = (value ?? '').trim();
  if (text.isEmpty) {
    return "$fieldName tidak boleh kosong!";
  }
  if (stripHtml(text).trim().isEmpty) {
    return "$fieldName tidak boleh hanya berisi tag HTML.";
  }
  if (maxLength != null && text.length > maxLength) {
    return "$fieldName maksimal $maxLength karakter.";
  }
  return null;
}

/// Validasi URL opsional (URLField dengan blank=True di Django).
/// Kosong dianggap valid; jika diisi harus diawali http:// atau https://
/// dan tidak melebihi [maxLength] karakter
String? validateOptionalUrl(String? value, {int maxLength = 200}) {
  final text = (value ?? '').trim();
  if (text.isEmpty) return null;

  final uri = Uri.tryParse(text);
  final isValidUrl =
      uri != null &&
      (uri.scheme == 'http' || uri.scheme == 'https') &&
      uri.host.contains('.');
  if (!isValidUrl) {
    return "Masukkan URL yang valid, diawali http:// atau https://";
  }
  if (text.length > maxLength) {
    return "URL maksimal $maxLength karakter.";
  }
  return null;
}

/// Validasi URL wajib: tidak boleh kosong, harus URL absolut (punya scheme
/// http/https dan host), dan tidak melebihi [maxLength] karakter.
String? validateRequiredUrl(
  String? value, {
  required String fieldName,
  int maxLength = 200,
}) {
  final text = (value ?? '').trim();
  if (text.isEmpty) {
    return "$fieldName tidak boleh kosong!";
  }
  return validateOptionalUrl(text, maxLength: maxLength);
}
