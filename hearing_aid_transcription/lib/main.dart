import 'package:flutter/material.dart';
import 'package:hearing_aid_transcription/transcribe.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '会話文字起こし',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        textTheme: TextTheme(
            bodySmall: TextStyle(fontSize: 18),
            bodyMedium: TextStyle(fontSize: 22)),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final stt.SpeechToText speechToText = stt.SpeechToText();
  bool _speechEnabled = false;

  @override
  void initState() {
    super.initState();
    _initSpeechToText();
  }

  void _initSpeechToText() async {
    _speechEnabled = await speechToText.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("会話文字起こしへようこそ！"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.all(50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Text("Q. これは何ができるソフトですか？",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                      "A. このアプリを使うと対面での日常会話を文字起こしすることができます。音だけでは聞き取りにくい方も会話内容の文字起こしを見ることで会話により参加できるようになるはずです。"),
                  Text("Q. このアプリは無料で使えますか？",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                      "A. ほとんどの機能は無料で使えますが、Open AIの機能を使いたい場合にはAPIキーを用意する必要があります。（従量課金制）"),
                  Text("Q. どうやって使うのですか？",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("A. 会話を始める前に下のボタンを押してください。画面が切り替わったら会話を始めると文字起こしされます。"),
                ],
              ),
            ),
            FilledButton(
              onPressed: _speechEnabled
                  ? () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TranscribePage(speechToText)))
                  : null,
              child: _speechEnabled
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Icon(Icons.transcribe), Text("会話を始める")],
                    )
                  : Text("準備中… しばらくお待ちください"),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
