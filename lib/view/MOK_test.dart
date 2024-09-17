import 'package:flutter_tts/flutter_tts.dart';
import 'package:kpathshala/app_base/common_imports.dart';

class ColorsScreen extends StatefulWidget {
  const ColorsScreen({super.key, required this.title});

  final String title;

  @override
  State<ColorsScreen> createState() => _ColorsScreenState();
}

class _ColorsScreenState extends State<ColorsScreen> {
  late FlutterTts flutterTts;
  bool isPlaying = false;
  String _currentColor = "black";
  String get currentColorName => _currentColor;

  @override
  void initState() {
    super.initState();
    initTts();

    flutterTts.setStartHandler(() {
      setState(() {
        isPlaying = true;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
      });
    });
  }

  initTts() async {
    flutterTts = FlutterTts();
  }

  Future _readColorName() async {
    await flutterTts.setVolume(1);
    await flutterTts.setSpeechRate(1);
    await flutterTts.setPitch(1);
    var result = await flutterTts.speak(currentColorName);
    if (result == 1) {
      setState(() {
        isPlaying = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: IconButton(
        padding: const EdgeInsets.all(0),
        icon: const Icon(
          Icons.play_circle_fill_rounded,
          color: Colors.red,
          size: 50,
          semanticLabel: 'Play color name',
        ),
        onPressed: _readColorName,
      ),
    );
  }
}
