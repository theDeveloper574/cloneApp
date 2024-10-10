// import 'package:audioplayers/audioplayers.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
//
// class AudioScreen extends StatefulWidget {
//   String? voiceUrl;
//   bool? isMe = true;
//   String? date;
//
//   AudioScreen({required this.voiceUrl, required this.isMe, required this.date});
//
//   @override
//   State<AudioScreen> createState() => _AudioScreenState();
// }
//
// class _AudioScreenState extends State<AudioScreen> {
//   final audioPlayer = AudioPlayer();
//   bool isPlaying = false;
//   Duration duration = Duration.zero;
//   Duration position = Duration.zero;
//   String? image;
//   @override
//   void initState() {
//     super.initState();
//     // TODO: implement initState
//     setAudio();
//     // getCuUserImage();
//     ///listen to the audio state
//     audioPlayer.onPlayerStateChanged.listen((event) {
//       setState(() {
//         isPlaying = event == PlayerState.PLAYING;
//       });
//
//       ///listen to the audio duration
//       audioPlayer.onDurationChanged.listen((newDuration) {
//         setState(() {
//           duration = newDuration;
//         });
//       });
//
//       ///listen to the audio position
//       audioPlayer.onAudioPositionChanged.listen((newPosition) {
//         setState(() {
//           position = newPosition;
//         });
//       });
//     });
//   }
//
//   Future setAudio() async {
//     ///repeat the audio when completed
//     // audioPlayer.setReleaseMode(ReleaseMode.LOOP);
//     //now we loading audio from url
//     String url =
//         'https://firebasestorage.googleapis.com/v0/b/practiceappmy.appspot.com/o/chatVoice%20%2F%202200c416-38b3-499d-a1ab-d68a13a0df1d?alt=media&token=d8ae51d0-8d2f-43b8-b23d-aa01745f4438';
//     audioPlayer.set(widget.voiceUrl!);
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     audioPlayer.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       // mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Row(
//           mainAxisAlignment:
//               widget.isMe! ? MainAxisAlignment.end : MainAxisAlignment.start,
//           children: [
//             Container(
//               height: 75,
//               width: 300,
//               decoration: BoxDecoration(
//                   color: Colors.black, borderRadius: BorderRadius.circular(15)),
//               // padding: EdgeInsets.symmetric(vertical: 10),
//               // width: ,
//               margin: const EdgeInsets.symmetric(vertical: 5),
//               // color: Colors.black,
//               child: Row(
//                 mainAxisAlignment: widget.isMe!
//                     ? MainAxisAlignment.end
//                     : MainAxisAlignment.start,
//                 children: [
//                   widget.isMe!
//                       ? Expanded(
//                           flex: 2,
//                           child: CircleAvatar(
//                             radius: 28,
//                             backgroundColor: Colors.green,
//                             backgroundImage: image == null
//                                 ? null
//                                 : CachedNetworkImageProvider(image!),
//                           ),
//                         )
//                       : Expanded(
//                           flex: 2,
//                           child: CircleAvatar(
//                             radius: 28,
//                             backgroundColor: Colors.green,
//                             backgroundImage: image == null
//                                 ? null
//                                 : CachedNetworkImageProvider(image!),
//                           ),
//                         ),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.only(bottom: 15.0, right: 10),
//                       child: IconButton(
//                           iconSize: 35,
//                           onPressed: () async {
//                             if (isPlaying) {
//                               await audioPlayer.pause();
//                             } else {
//                               await audioPlayer.resume();
//                             }
//                           },
//                           icon:
//                               Icon(isPlaying ? Icons.pause : Icons.play_arrow),
//                           color: Colors.white),
//                     ),
//                   ),
//                   Expanded(
//                       flex: 5,
//                       child: Column(
//                         children: [
//                           const SizedBox(
//                             height: 5,
//                           ),
//                           Slider(
//                               min: 0,
//                               max: duration.inSeconds.toDouble(),
//                               value: position.inSeconds.toDouble(),
//                               onChanged: (val) async {
//                                 final position = Duration(seconds: val.toInt());
//                                 await audioPlayer.seek(position);
//
//                                 ///if audio player paused
//                                 await audioPlayer.resume();
//                               }),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 1.0, horizontal: 5),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   formatTime(position),
//                                   style: const TextStyle(color: Colors.white),
//                                 ),
//                                 // Text(
//                                 //   formatTime(duration),
//                                 //   style: const TextStyle(color: Colors.white),
//                                 // )
//                                 Text(
//                                   widget.date!,
//                                   style: const TextStyle(color: Colors.white),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ],
//                       )),
//                 ],
//               ),
//             ),
//           ],
//         )
//       ],
//     );
//   }
//
//   String formatTime(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final hours = twoDigits(duration.inHours);
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final senonds = twoDigits(duration.inSeconds.remainder(60));
//     return [
//       if (duration.inHours > 0) hours,
//       minutes,
//       senonds,
//     ].join(':');
//   }
// }
