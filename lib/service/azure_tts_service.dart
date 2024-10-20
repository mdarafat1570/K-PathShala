import 'package:http/http.dart' as http;

class AzureTTS {
  final String apiKey = 'efef202bedc846ad81274b6e3c3107da'; // Your Azure resource key
  final String region = 'southeastasia'; // Your Azure region


  Future<String> _fetchToken() async {
    final url = 'https://$region.api.cognitive.microsoft.com/sts/v1.0/issueToken';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Ocp-Apim-Subscription-Key': apiKey,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to fetch token: ${response.body}');
    }
  }


  Future<void> speak(String text, String voiceName) async {
    final token = await _fetchToken();
    final url = 'https://$region.tts.speech.microsoft.com/cognitiveservices/v1';


    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/ssml+xml',
      'X-Microsoft-OutputFormat': 'audio-16khz-32kbitrate-mono-mp3',
      'User-Agent': 'flutter-azure-tts',
    };



    final body = '''
    <speak version="1.0" xmlns="http://www.w3.org/2001/10/synthesis" xml:lang="ko-KR">
        <voice name="$voiceName">
            <prosody rate="0.67">
                $text
            </prosody>
        </voice>
    </speak>
    ''';


    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );


    if (response.statusCode == 200) {
      final audioPlayer = AudioPlayer();
      await audioPlayer.play(BytesSource(response.bodyBytes));
    } else {
      throw Exception('Failed to synthesize speech: ${response.body}');
    }
  }
}

