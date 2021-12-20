import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jacobs_job_interview/date_fetch.dart/api_call.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ListenUI extends StatefulWidget {
  const ListenUI({Key? key}) : super(key: key);

  @override
  _ListenUIState createState() => _ListenUIState();
}

class _ListenUIState extends State<ListenUI> {
  late stt.SpeechToText _speech;
  ApiResponse? res;
  bool hasData = false;
  bool _isListening = false;
  String? _text;
  late List _datalist;
  late Map _datamap;
  late String _dataDefinition;
  late String _dataExample;
  late String _dataImageurl;
  late String _dataWord;
  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("PingoLearn-Round 1"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: hasData
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Your word:\n"),
                    Text(_dataWord),
                    Card(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Meaning",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(_dataDefinition),
                          ]),
                    ),
                    Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Example",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(_dataExample),
                        ],
                      ),
                    ),
                    _dataImageurl == "no image"
                        ? Image.asset('asset/image_not_found.png')
                        : Image.network(_dataImageurl),
                  ],
                )
              : Container(),
        ),
      ),
    );
  }

  void _listen() async {
    /// Get the  [word] from the [speech to text package]

    if (!_isListening) {
      bool available = await _speech.initialize();

      if (available) {
        setState(() {
          hasData=false;
          _isListening = true;
         
        });
        
        _speech.listen(
            onResult: (val) => setState(
                  () {
                    _text = val.recognizedWords;
                   
                    _datacall();
                  },
                ));

        

      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _datacall() async {
     /// [word] and the [token] is passed to owlapi

    final OwlApi owlApi =
        OwlApi(token: "f68ee647db7e571df94ff6291ad596f30bac3553");
    res = await owlApi.define(word: _text!);
    _datalist = (res!.definition!);
    _datamap = _datalist[0] as Map;
    _dataDefinition = _datamap["definition"];
    _dataExample = _datamap["example"];
    _dataWord = res!.word!;
    _dataImageurl = _datamap["image_url"] ?? "no image";
    hasData = true;

    setState(() => _isListening = false);
  }
}
