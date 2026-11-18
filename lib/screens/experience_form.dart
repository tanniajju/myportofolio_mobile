import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/utils/form_validators.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

/// Field, label, dan aturan validasinya mengikuti model `Experience` dan
/// `ExperienceForm` pada web portofolio Django (main/models.py & main/forms.py):
/// - title       : wajib, maks. 255 karakter, tidak boleh hanya berisi tag HTML
/// - description : wajib
/// - category    : wajib, salah satu dari EXPERIENCE_CHOICES
/// - thumbnail   : opsional, harus URL valid (maks. 200 karakter, default URLField)
/// - started_at  : wajib, default hari ini
/// - ended_at    : opsional, tidak boleh sebelum started_at

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Field tanggal diisi lewat date picker, jadi teksnya diatur lewat controller.
  final _startedAtController = TextEditingController();
  final _endedAtController = TextEditingController();

  String _title = "";
  String _description = "";
  String? _category; // null = belum dipilih
  String _thumbnail = "";
  DateTime? _startedAt;
  DateTime? _endedAt;

  static const Map<String, String> _categories = {
    'internship': 'Internship',
    'volunteer': 'Volunteer',
    'part-time': 'Part-Time',
    'full-time': 'Full-Time',
    'organization': 'Organization',
    'committee': 'Committee',
  };

  // Bahasa Indonesia
  static const List<String> _monthNames = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];

  @override
  void initState() {
    super.initState();
    _setDefaultStartDate();
  }

  @override
  void dispose() {
    _startedAtController.dispose();
    _endedAtController.dispose();
    super.dispose();
  }

  /// Tanggal hari ini tanpa jam, agar perbandingan tanggal akurat
  DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Format tanggal, contoh: 18 November 2026
  String _formatDate(DateTime date) =>
      '${date.day} ${_monthNames[date.month - 1]} ${date.year}';

  /// started_at di model default-nya timezone.now, jadi diisi hari ini.
  void _setDefaultStartDate() {
    _startedAt = _today();
    _startedAtController.text = _formatDate(_startedAt!);
  }

  /// Pengalaman dianggap masih berlangsung jika belum ada tanggal selesai
  /// atau tanggal selesainya setelah hari ini (sama seperti is_ongoing di model).
  bool get _isOngoing => _endedAt == null || _endedAt!.isAfter(_today());

  Future<void> _pickDate({required bool isStart}) async {
    final initialDate =
        isStart ? (_startedAt ?? _today()) : (_endedAt ?? _startedAt ?? _today());

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
      helpText: isStart ? 'Pilih tanggal mulai' : 'Pilih tanggal selesai',
    );

    if (picked == null || !mounted) return;

    setState(() {
      if (isStart) {
        _startedAt = picked;
        _startedAtController.text = _formatDate(picked);
      } else {
        _endedAt = picked;
        _endedAtController.text = _formatDate(picked);
      }
    });
  }

  void _clearEndDate() {
    setState(() {
      _endedAt = null;
      _endedAtController.clear();
    });
  }

  // ================= Validator =================

  String? _validateTitle(String? value) => validateRequiredText(
        value,
        fieldName: "Nama pengalaman",
        maxLength: 255,
      );

  String? _validateDescription(String? value) => validateRequiredText(
        value,
        fieldName: "Deskripsi pengalaman",
      );

  String? _validateCategory(String? value) {
    if (value == null || !_categories.containsKey(value)) {
      return "Pilih kategori pengalaman!";
    }
    return null;
  }

  /// thumbnail adalah URLField tanpa max_length, jadi batas default-nya 200
  String? _validateThumbnail(String? value) =>
      validateOptionalUrl(value, maxLength: 200);

  String? _validateStartedAt(String? _) {
    if (_startedAt == null) {
      return "Tanggal mulai tidak boleh kosong!";
    }
    return null;
  }

  String? _validateEndedAt(String? _) {
    if (_endedAt != null &&
        _startedAt != null &&
        _endedAt!.isBefore(_startedAt!)) {
      return "Tanggal selesai tidak boleh sebelum tanggal mulai.";
    }
    return null;
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _title = "";
      _description = "";
      _category = null;
      _thumbnail = "";
      _endedAt = null;
      _endedAtController.clear();
      _setDefaultStartDate();
    });
  }

  void _onSave() {
    // validate() menjalankan semua validator. Jika ada yang gagal,
    // pesan error tampil di kolom terkait dan dialog tidak dibuka.
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pengalaman berhasil ditambahkan!'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Nama Pengalaman: ${_title.trim()}'),
                const SizedBox(height: 4),
                Text('Deskripsi: ${_description.trim()}'),
                const SizedBox(height: 4),
                Text('Kategori: ${_categories[_category]}'),
                const SizedBox(height: 4),
                Text('URL Gambar: ${_thumbnail.trim().isEmpty ? '-' : _thumbnail.trim()}'),
                const SizedBox(height: 4),
                Text('Mulai: ${_formatDate(_startedAt!)}'),
                const SizedBox(height: 4),
                Text('Selesai: ${_endedAt == null ? '-' : _formatDate(_endedAt!)}'),
                const SizedBox(height: 4),
                Text('Status: ${_isOngoing ? 'Sedang berlangsung' : 'Selesai'}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                _resetForm();
              },
            ),
          ],
        );
      },
    );
  }

  // ================= Tampilan =================

  InputDecoration _decoration(String label, {String? hint, Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // Warna AppBar sama dengan halaman utama (colorScheme.primary).
      appBar: AppBar(
        title: const Text(
          'Add Experience Form',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        // SingleChildScrollView membuat semua field dan tombol Simpan
        // tetap bisa dijangkau di layar sempit atau saat keyboard muncul.
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Masukkan detail pengalaman terbaru.',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),

              // === Nama Pengalaman (title) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLength: 255,
                  textInputAction: TextInputAction.next,
                  decoration: _decoration(
                    "Nama Pengalaman",
                    hint: "Nama Pengalaman",
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _title = value;
                    });
                  },
                  validator: _validateTitle,
                ),
              ),

              // === Deskripsi (description) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  minLines: 3,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  decoration: _decoration(
                    "Deskripsi Pengalaman",
                    hint: "Ceritakan tentang pengalamanmu",
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _description = value;
                    });
                  },
                  validator: _validateDescription,
                ),
              ),

              // === Kategori (category) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  initialValue: _category,
                  hint: const Text("Pilih kategori"),
                  decoration: _decoration("Kategori Pengalaman"),
                  items: _categories.entries
                      .map((entry) => DropdownMenuItem(
                            value: entry.key,
                            child: Text(entry.value),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _category = newValue;
                    });
                  },
                  validator: _validateCategory,
                ),
              ),

              // === URL Gambar (thumbnail) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.url,
                  decoration: _decoration(
                    "URL Gambar (opsional)",
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _thumbnail = value;
                    });
                  },
                  validator: _validateThumbnail,
                ),
              ),

              // === Tanggal Mulai (started_at) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _startedAtController,
                  readOnly: true,
                  onTap: () => _pickDate(isStart: true),
                  decoration: _decoration(
                    "Tanggal Mulai",
                    suffixIcon: const Icon(Icons.calendar_today_rounded),
                  ),
                  validator: _validateStartedAt,
                ),
              ),

              // === Tanggal Selesai (ended_at) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _endedAtController,
                  readOnly: true,
                  onTap: () => _pickDate(isStart: false),
                  decoration: _decoration(
                    "Tanggal Selesai (opsional)",
                    suffixIcon: _endedAt == null
                        ? const Icon(Icons.event_rounded)
                        : IconButton(
                            tooltip: 'Hapus tanggal selesai',
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: _clearEndDate,
                          ),
                  ),
                  validator: _validateEndedAt,
                ),
              ),

              // === Tombol Simpan ===
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(colorScheme.primary),
                    ),
                    onPressed: _onSave,
                    child: const Text(
                      "Simpan",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}