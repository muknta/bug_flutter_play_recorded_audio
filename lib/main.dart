import 'package:reproduced_just_audio_issue/audio_play.dart';
import 'package:reproduced_just_audio_issue/audio_record.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recorded Audio Issue',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Recorded Audio Issue'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key) {
    _player = AudioPlay(fileName: fileName);
    _recorder = AudioRecord(fileName: fileName);
  }

  final String title;

  static const String fileName = '/pronunciation_record.mp4';

  late AudioPlay _player;
  late AudioRecord _recorder;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isRecording = false;
  bool _isPlaying = false;

  String? basePath;

  @override
  Widget build(BuildContext context) {
    final String _recordTitle = _isRecording ? 'Stop recording' : 'Record';
    final String _playerTitle = _isPlaying ? 'Stop playing' : 'Play';
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _getTitleWidget(_recordTitle),
                FloatingActionButton(
                  onPressed: () async => _isRecording ? _stopRecording() : _recordAudio(),
                  tooltip: _recordTitle,
                  child: Icon(Icons.add),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _getTitleWidget(_playerTitle),
                FloatingActionButton(
                  onPressed: () async => _isPlaying ? _stopPlaying() : _playAudio(),
                  tooltip: _playerTitle,
                  child: Icon(Icons.view_array),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _recordAudio() async {
    basePath ??= (await getApplicationDocumentsDirectory()).path;
    if (!_isPlaying) {
      final bool isPermissionGranted = await widget._recorder.hasPermission ?? false;
      if (isPermissionGranted) {
        await _stopRecording();
        await widget._recorder.startRecord(basePath!);

        setState(() {
          _isRecording = true;
        });
      } else {
        _getSnackBar('Permission is not granted');
      }
    } else {
      _getSnackBar('Finish playing before recording');
    }
  }

  Future<void> _stopRecording() async {
    await widget._recorder.stopRecord();
    setState(() {
      _isRecording = false;
    });
  }

  Future<void> _playAudio() async {
    basePath ??= (await getApplicationDocumentsDirectory()).path;
    if (!_isRecording) {
      await widget._player.playFromLocalRecord(basePath!);
      setState(() {
        _isPlaying = true;
      });
    } else {
      _getSnackBar('Finish recording before playing');
    }
  }

  Future<void> _stopPlaying() async {
    await widget._player.stopPlaying();
    setState(() {
      _isPlaying = false;
    });
  }

  ScaffoldFeatureController _getSnackBar([String message = 'Error']) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Widget _getTitleWidget(String title) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Text(title),
    );
  }
}
