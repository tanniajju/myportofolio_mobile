import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final String npm = "2506608123";
  final String nama = "Tania Ju";
  final String kelas = "PBP A";

  final List<ItemHomepage> items = [
    ItemHomepage("Lihat Proyek", Icons.folder_special_rounded, Colors.indigo),
    ItemHomepage("Tambah Proyek", Icons.add_circle_rounded, Colors.teal),
    ItemHomepage("Tambah Pengalaman", Icons.work_history_rounded, Colors.orange),
    ItemHomepage("Logout", Icons.logout_rounded, Colors.red),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyPortfolio',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const LeftDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const WelcomeBanner(),

              const SizedBox(height: 16.0),
              Row(
                
                children: [
                  Expanded(
                    child: InfoCard(
                      title: 'NPM',
                      content: npm,
                      icon: Icons.badge_rounded,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: InfoCard(
                      title: 'Name',
                      content: nama,
                      icon: Icons.person_rounded,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: InfoCard(
                      title: 'Class',
                      content: kelas,
                      icon: Icons.school_rounded,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24.0),

              // Judul bagian menu.
              Text(
                'Menu Portofolio',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12.0),

              // GridView 2 kolom
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: items.map((ItemHomepage item) {
                  return ItemCard(item);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Banner sambutan berlatar gradasi di bagian atas halaman.
class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            child: const Icon(Icons.person, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16.0),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat datang di',
                  style: TextStyle(color: Colors.white70, fontSize: 14.0),
                ),
                SizedBox(height: 2.0),
                Text(
                  'MyPortfolio Mobile!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  // Kartu informasi yang menampilkan ikon, judul (title), dan isi (content).
  final String title;
  final String content;
  final IconData icon;

  const InfoCard({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2.0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: colorScheme.primary, size: 22.0),
            const SizedBox(height: 6.0),
            Text(
              title,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 2.0),
            // FittedBox mengecilkan teks panjang (mis. NPM) agar tetap
            // satu baris dan tidak overflow.
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                content,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;

  ItemHomepage(this.name, this.icon, this.color);
}