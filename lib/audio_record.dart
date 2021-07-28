import 'dart:io';

import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';

class AudioRecord {
  AudioRecord({required String fileName}) : _fileName = fileName;

  final String _fileName;

  FlutterAudioRecorder? _audioRecorder;

  Future<bool?> get hasPermission async => FlutterAudioRecorder.hasPermissions;

  Future<void> startRecord(String _basePath) async {
    if (await checkRecStatus() == RecordingStatus.Recording) {
      await _audioRecorder?.stop();
    }
    await _delFile(_basePath);
    _audioRecorder = FlutterAudioRecorder(_basePath + _fileName, audioFormat: AudioFormat.AAC, sampleRate: 44100);
    await _audioRecorder?.initialized;
    await _audioRecorder?.start();
  }

  Future<RecordingStatus?> checkRecStatus() async {
    final Recording? rec = await _audioRecorder?.current();
    if (rec == null) {
      return RecordingStatus.Unset;
    } else {
      return rec.status;
    }
  }

  Future<void> stopRecord() async {
    if (await checkRecStatus() == RecordingStatus.Recording) {
      await _audioRecorder?.stop();
    }
  }

  Future<void> _delFile(String _basePath) async {
    final File delFile = File(_basePath + _fileName);
    if (delFile.existsSync()) {
      await delFile.delete(recursive: true);
    }
  }
}
