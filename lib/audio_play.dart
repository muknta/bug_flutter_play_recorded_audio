import 'package:just_audio/just_audio.dart';
import 'package:audioplayers/audioplayers.dart' as old_audio;

class AudioPlay {
  AudioPlay({required String fileName}) : _fileName = fileName;

  final String _fileName;

  final AudioPlayer _player = AudioPlayer();

  Future<void> playFromLocalRecord(String _basePath) async {
    /// NOT working
    ///
    /// Comment to check another library
    await _player.setFilePath('$_basePath$_fileName');
    await _player.play();
    return _player.pause();

    /// working
    ///
    /// Uncomment to check library
    // final _anotherPlayer = old_audio.AudioPlayer();
    // await _anotherPlayer.play(_basePath + _fileName, isLocal: true);
  }

  Future<void> stopPlaying() async => _player.stop();

  Future<void> dispose() async => _player.dispose();
}
