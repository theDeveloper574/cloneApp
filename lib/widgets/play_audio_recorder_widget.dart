import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart' as ap;
import 'package:just_audio/just_audio.dart';
import 'package:maanaap/main.dart';

class AudioPlayerScreen extends StatefulWidget {
  /// Path from where to play recorded audio
  final String source;

  /// Callback when audio file should be removed
  /// Setting this to null hides the delete button
  // final VoidCallback onDelete;

  const AudioPlayerScreen({
    super.key,
    required this.source,
    // required this.onDelete,
  });

  @override
  AudioPlayerScreenState createState() => AudioPlayerScreenState();
}

class AudioPlayerScreenState extends State<AudioPlayerScreen> {
  static const double _controlSize = 36;
  // static const double _deleteBtnSize = 18;

  final _audioPlayer = ap.AudioPlayer();
  late StreamSubscription<ap.PlayerState> _playerStateChangedSubscription;
  final streamController = StreamController();
  Duration? _durationChangedSubscription;
  Duration? _positionChangedSubscription;
  final audioPlayer = AudioPlayer();
  Duration? durationCom;
  Duration? position;
  @override
  void initState() {
    super.initState();
    _playerStateChangedSubscription =
        _audioPlayer.playerStateStream.listen((state) async {
      // if (state.processingState == ap.ProcessingState.completed) {
      //   await stop();
      // }
      // setState(() {});
    });
    _audioPlayer.positionStream.listen((position1) => setState(() {
          position = position1;
          // print(position);
        }));
    // _durationChangedSubscription = _audioPlayer.durationStream.listen(
    //   (duration) => setState(
    //     () {},
    //   ),
    // );
    // _init();
  }

  @override
  void didChangeDependencies() {
    // audioTIme();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // _playerStateChangedSubscription.cancel();
    // _positionChangedSubscription!.cancel();
    // _durationChangedSubscription!.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  left: 18.0, top: MediaQuery.sizeOf(context).height * 0.017),
              child: _buildControl(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: _buildSlider(),
            ),
            // AppUtils.sizedBox(4.0, 0.0),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 6.0, top: 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.sizeOf(context).width * 0.2),
                child: Text(
                  durationCom == null ? "0:0" : formatTime(durationCom!),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              // Text(
              //   formatTime(duration),
              //   style: const TextStyle(color: Colors.white),
              // )
              Padding(
                padding: const EdgeInsets.only(right: 28.0),
                child: Text(
                  position == null ? "0:0" : formatTime(position!),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final senonds = twoDigits(duration.inSeconds.remainder(60));
    return [
      if (duration.inHours > 0) hours,
      minutes,
      senonds,
    ].join(':');
  }

  Widget _buildControl() {
    Icon icon;
    Color color;

    if (_audioPlayer.playerState.playing) {
      icon = const Icon(Icons.pause, color: Colors.white, size: 30);
      color = const Color(0xff2C3375);
    } else {
      final theme = Theme.of(context);
      icon = const Icon(Icons.play_arrow, color: Colors.white, size: 30);
      color = const Color(0xff2C3375);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child:
              SizedBox(width: _controlSize, height: _controlSize, child: icon),
          onTap: () {
            if (_audioPlayer.playerState.playing) {
              pause();
            } else {
              play();
            }
          },
        ),
      ),
    );
  }

  Widget _buildSlider() {
    final position = _audioPlayer.position;
    final duration = _audioPlayer.duration;
    bool canSetValue = false;
    if (duration != null) {
      canSetValue = position.inMilliseconds > 0;
      canSetValue &= position.inMilliseconds < duration.inMilliseconds;
    }

    // double width = widgetWidth - _controlSize - _deleteBtnSize;
    // width -= _deleteBtnSize;

    return SliderTheme(
      data: const SliderThemeData(
        trackHeight: 2.6,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
      ),
      child: Slider(
        activeColor: const Color(0xff2C3375),
        inactiveColor: Colors.grey.withOpacity(0.4),
        onChanged: (v) {
          if (duration != null) {
            final position = v * duration.inMilliseconds;
            _audioPlayer.seek(
              Duration(
                milliseconds: position.round(),
              ),
            );
          }
        },
        value: canSetValue && duration != null
            ? position.inMilliseconds / duration.inMilliseconds
            : 0.0,
      ),
    );
  }

  Future<void> play() async {
    await _audioPlayer.setUrl(widget.source);
    return _audioPlayer.play();
  }

  Future<void> pause() {
    return _audioPlayer.pause();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    return _audioPlayer.seek(const Duration(milliseconds: 0));
  }

  Future audioTIme() async {
    try {
      durationCom = await _audioPlayer.setUrl(widget.source);
    } on PlayerException catch (e) {
      flutterToast(message: e.message.toString());
    }
  }

  Future<void> _init() async {
    // await _audioPlayer.setUrl(widget.source);
    // Catching errors at load time
    try {
      await _audioPlayer.setUrl(widget.source);
      // print(await durationCom);
    } on PlayerException catch (e) {
      // iOS/macOS: maps to NSError.code
      // Android: maps to ExoPlayerException.type
      // Web: maps to MediaError.code
      // Linux/Windows: maps to PlayerErrorCode.index
      // print("Error code: ${e.code}");
      // iOS/macOS: maps to NSError.localizedDescription
      // Android: maps to ExoPlaybackException.getMessage()
      // Web/Linux: a generic message
      // Windows: MediaPlayerError.message
      // print("Error message: ${e.message}");
      flutterToast(message: e.message.toString());
    } on PlayerInterruptedException catch (e) {
      // This call was interrupted since another audio source was loaded or the
      // player was stopped or disposed before this audio source could complete
      // loading.
      // print("Connection aborted: ${e.message}");
      // flutterToast(message: e.message.toString());
    } catch (e) {
      // Fallback for all other errors
      // print('An error occured: $e');
      flutterToast(message: "An error occured: ${e.toString()}");
    }
  }
}
