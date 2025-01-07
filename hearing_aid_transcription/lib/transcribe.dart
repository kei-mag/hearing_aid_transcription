import 'package:flutter/material.dart';
import 'package:hearing_aid_transcription/main.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class TranscribePage extends StatefulWidget {
  const TranscribePage(this.speechToText, {super.key});

  final stt.SpeechToText speechToText;

  @override
  State<StatefulWidget> createState() => _TranscribePageState();
}

class _TranscribePageState extends State<TranscribePage> {
  final List<Widget> _conversationResults = [
    const Text("以下に会話が文字起こしされていきます...",
        style: TextStyle(fontWeight: FontWeight.bold)),
    const Text(""),
  ];

  @override
  void initState() {
    super.initState();
    _startRepeatedlyListening();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("会話を聞き取り中・・・"),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _conversationResults,
              ),
            ),
          ),
          FilledButton(
              onPressed: () {
                _stopListening();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text("会話を終わる"))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            widget.speechToText.isListening ? _stopListening : _startListening,
        child: widget.speechToText.isListening
            ? Icon(Icons.stop_circle)
            : Icon(Icons.play_circle),
      ),
    );
  }

  void _startListening() async {
    await widget.speechToText.listen(
        pauseFor: Duration(minutes: 10),
        listenOptions: stt.SpeechListenOptions(
            autoPunctuation: true,
            enableHapticFeedback: true,
            listenMode: stt.ListenMode.dictation),
        onResult: (result) {
          setState(
              () => _conversationResults.add(Text(result.recognizedWords)));
        });
  }

  void _startRepeatedlyListening() async {
    if (widget.speechToText.isNotListening) {
      print("startListening!");
      await widget.speechToText.listen(
          pauseFor: Duration(minutes: 10),
          listenOptions: stt.SpeechListenOptions(
              autoPunctuation: true,
              enableHapticFeedback: true,
              listenMode: stt.ListenMode.dictation),
          onResult: (result) {
            if (result.finalResult) {
              setState(
                  () => _conversationResults.add(Text(result.recognizedWords)));
              _startRepeatedlyListening();
            }
          });
    }
  }

  void _stopListening() async {
    await widget.speechToText.stop();
    setState(() {});
  }
}
