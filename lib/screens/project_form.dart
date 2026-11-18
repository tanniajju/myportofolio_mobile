import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/utils/form_validators.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

/// Field, label, dan aturan validasi disesuaikan mengikuti model `Project` dan
/// `ProjectForm` pada web portofolio Django (main/models.py & main/forms.py):
/// - title             : wajib, maks. 255 karakter
/// - description       : wajib
/// - tech_stack        : wajib, maks. 255 karakter
/// - project_url       : opsional, URL valid (maks. 200 karakter)
/// - project_image_url : opsional, URL valid (maks. 500 karakter)

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _title = "";
  String _description = "";
  String _techStack = "";
  String _projectUrl = "";
  String _projectImageUrl = "";

  InputDecoration _decoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    );
  }

  /// Mengosongkan tampilan form sekaligus variabel penyimpannya, agar isian
  /// lama tidak ikut muncul di dialog jika field opsional dikosongkan.
  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _title = "";
      _description = "";
      _techStack = "";
      _projectUrl = "";
      _projectImageUrl = "";
    });
  }

  /// Menampilkan "-" untuk field opsional yang dikosongkan.
  String _orDash(String value) => value.trim().isEmpty ? '-' : value.trim();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Add Project Form',
          ),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Header ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Masukkan detail project terbaru.',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),

              // === Project Name (Title) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLength: 255,
                  textInputAction: TextInputAction.next,
                  decoration: _decoration(
                    "Nama Proyek",
                    hint: "Nama Proyek",
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _title = value;
                    });
                  },
                  validator: (String? value) => validateRequiredText(
                    value, 
                    fieldName: "Nama Proyek",
                    maxLength: 255),
                ),
              ),

              // === Description ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  minLines: 3,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  decoration: _decoration(
                    "Deskripsi Proyek",
                    hint: "Deskripsi Proyek",
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _description = value;
                    });
                  },
                  validator: (String? value) => validateRequiredText(
                    value, 
                    fieldName: "Deskripsi Proyek",
                  ),
                ),
              ),

              // === Tech Stack ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLength: 255,
                  textInputAction: TextInputAction.next,
                  decoration: _decoration(
                    "Tech Stack yang digunakan",
                    hint: "Contoh: Django, Flutter, HTML, CSS",
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _techStack = value;
                    });
                  },
                  validator: (String? value) => validateRequiredText(
                    value,
                    fieldName: "Tech Stack",
                    maxLength: 255,
                  ),
                ),
              ),

              // === Project URL ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.next,
                  decoration: _decoration(
                    "URL Proyek (opsional)",
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _projectUrl = value;
                    });
                  },
                  validator: (String? value) =>
                      validateOptionalUrl(value, maxLength: 200),
                ),
              ),

              // === Project Image URL ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.url,
                  decoration: _decoration(
                    "URL Gambar/Sampul Proyek (opsional)",
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _projectImageUrl = value;
                    });
                  },
                  validator: (String? value) =>
                      validateOptionalUrl(value, maxLength: 500),
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
                          WidgetStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Proyek berhasil ditambahkan!'),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Nama Proyek: ${_title.trim()}'),
                                    Text('Deskripsi: ${_description.trim()}'),
                                    Text('Tech Stack: ${_techStack.trim()}'),
                                    Text('URL Proyek: ${_orDash(_projectUrl)}'),
                                    Text('URL Gambar: ${_orDash(_projectImageUrl)}'),
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
                    },
                    child: const Text(
                      "Save",
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