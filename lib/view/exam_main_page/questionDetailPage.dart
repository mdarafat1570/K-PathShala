import 'package:kpathshala/app_base/common_imports.dart';

class QuestionDetailPage extends StatelessWidget {
  final String title;
  final String description;
  final List<String> answers;

  const QuestionDetailPage({
    Key? key,
    required this.title,
    required this.description,
    required this.answers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Answers:',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ...answers.map((answer) => ListTile(
                    title: Text(answer),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
