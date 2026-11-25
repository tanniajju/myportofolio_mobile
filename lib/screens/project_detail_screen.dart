import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(project.title),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (project.projectImageUrl.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  project.projectImageUrl,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              ),
              const SizedBox(height: 16.0),
            ],
            Text(
              project.title,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              project.techStack,
              style: textTheme.titleSmall?.copyWith(color: Colors.indigo),
            ),
            const SizedBox(height: 16.0),
            Text(project.description, style: textTheme.bodyLarge),
            if (project.projectUrl.isNotEmpty) ...[
              const SizedBox(height: 16.0),
              Text('URL Proyek', style: textTheme.labelLarge),
              const SizedBox(height: 4.0),
              SelectableText(project.projectUrl),
            ],
          ],
        ),
      ),
    );
  }
}
