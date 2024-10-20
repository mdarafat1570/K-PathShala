import 'package:http/http.dart' as http;
import 'dart:typed_data';

class AzureTTS {
  final String apiKey = 'efef202bedc846ad81274b6e3c3107da';
  final String region = 'southeastasia';

  final String maleVoiceName = 'ko-KR-HyunsuMultilingualNeural';
  final String femaleVoiceName = 'ko-KR-SoonBokNeural';

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

  // Synthesize speech and return the audio as Uint8List
  Future<Uint8List> synthesizeSpeech(String text, String gender) async {
    String voiceName = gender == 'male' ? maleVoiceName : femaleVoiceName;
    final token = await _fetchToken();
    final url = 'https://$region.tts.speech.microsoft.com/cognitiveservices/v1';

    // Headers for the API request
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/ssml+xml',
      'X-Microsoft-OutputFormat': 'audio-16khz-32kbitrate-mono-mp3',
      'User-Agent': 'flutter-azure-tts',
    };

    // XML body for SSML (Speech Synthesis Markup Language)
    final body = '''
    <speak version="1.0" xmlns="http://www.w3.org/2001/10/synthesis" xml:lang="ko-KR">
        <voice name="$voiceName">
            <prosody rate="0.67">
                $text
            </prosody>
        </voice>
    </speak>
    ''';

    // Send the POST request to synthesize speech
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    // Check if the request was successful
    if (response.statusCode == 200) {
      return response.bodyBytes; // Return the audio data
    } else {
      throw Exception('Failed to synthesize speech: ${response.body}');
    }
  }
}
