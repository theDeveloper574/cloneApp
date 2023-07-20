import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maanaap/res/colors.dart';
import 'package:maanaap/utils/routes/routes_name.dart';
import 'package:maanaap/utils/utils.dart';
import 'package:maanaap/widgets/show_image_container_wid.dart';
import 'package:maanaap/widgets/show_profile_img_wid.dart';
import 'package:maanaap/widgets/text_field_signle_chat_widget.dart';
import 'package:progressive_image/progressive_image.dart';

class SingleChatView extends StatefulWidget {
  const SingleChatView({Key? key}) : super(key: key);

  @override
  State<SingleChatView> createState() => _SingleChatViewState();
}

class _SingleChatViewState extends State<SingleChatView> {
  TextEditingController message = TextEditingController();
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  final messages = [
    'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
    'Lorem Ipsum is simply dummy text of the printing and typesetting industrysadfksanfdknsakfdnlsakflfnlasnd',
    'This is a relatively longer line of text.',
    'Hi!',
    'This is a short message.',
    'This is a relatively longer line of text.',
    'Hi!',
    'This is a short message.',
    'This is a relatively longer line of text.',
    'Hi!',
  ];
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    setAudio();
    audioPlayer.onPlayerStateChanged.listen((event) {
      setState(() {
        isPlaying = event == PlayerState.playing;
      });

      ///listen to the audio duration
      audioPlayer.onDurationChanged.listen((newDuration) {
        setState(() {
          duration = newDuration;
        });
      });

      ///listen to the audio position
      audioPlayer.onPositionChanged.listen((newPosition) {
        setState(() {
          position = newPosition;
        });
      });
    });
  }

  Duration? audioDuration;

  Future setAudio() async {
    ///repeat the audio when completed
    // audioPlayer.setReleaseMode(ReleaseMode.LOOP);
    //now we loading audio from url
    String url =
        'https://firebasestorage.googleapis.com/v0/b/workapp-d4e73.appspot.com/o/Main%20Woh%20Chaand%20-%20Teraa%20Surroor%20-%20Darshan%20Raval%20-%20ClickMaza.com.mp3?alt=media&token=dab88f8e-d967-4645-a5d4-a39167dc1f44';
    await audioPlayer.setSourceUrl(url);
    audioDuration = await audioPlayer.getDuration();
    formatTime(audioDuration!);
    // duration = parseDuration(durationString.toString());
    print('Total duration: $duration');
  }

  // Duration parseDuration(String durationString) {
  //   List<String> parts = durationString.split(':');
  //   if (parts.length < 3) return Duration.zero;
  //
  //   int hours = int.parse(parts[0]);
  //   int minutes = int.parse(parts[1]);
  //   double seconds = double.parse(parts[2]);
  //
  //   return Duration(
  //     hours: hours,
  //     minutes: minutes,
  //     seconds: seconds.floor(),
  //     milliseconds: ((seconds - seconds.floor()) * 1000).round(),
  //   );
  // }
  @override
  void dispose() {
    // TODO: implement dispose
    audioPlayer.dispose();
    audioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreen,
      appBar: AppUtils.appBar(
          context: context,
          profileTap: () {
            Navigator.pushNamed(context, RouteName.userProfileView);
          },
          onCallTap: () {},
          onVideoTap: () {},
          onUpMenuBut: PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<int>(
                    value: 1,
                    child: Text("Settings"),
                  ),
                ];
              },
              onSelected: (val) {
                // if(val=="1"){
                FocusManager.instance.primaryFocus!.unfocus();
                // }
              })),
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: ListView.builder(
              // shrinkWrap: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: index % 2 == 0
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: index % 2 == 0
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.end,
                        children: [
                          ///chat box
                          AppUtils.chatBox(
                              context: context,
                              decoration: index % 2 == 0
                                  ? BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.defaultColor
                                              .withOpacity(0.1)),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.black12,
                                            spreadRadius: 0.01,
                                            blurRadius: 0.01,
                                            blurStyle: BlurStyle.solid)
                                      ],
                                      color: Colors.white,
                                      // border: Border.all(
                                      //   color: Colors.grey,
                                      // ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(14.0),
                                      ),
                                    )
                                  : BoxDecoration(
                                      color: AppColors.defaultColor,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(14.0),
                                      ),
                                    ),
                              message: messages[index],
                              messageTim: "12:11",
                              msgTextColor: index % 2 == 0
                                  ? AppColors.defaultColor
                                  : Colors.white,
                              msgTimColor: index % 2 == 0
                                  ? AppColors.defaultColor
                                  : Colors.white,
                              sentOrNot: index % 2 == 0
                                  ? AppUtils.sizedBox(0.0, 0.0)
                                  : const Icon(
                                      Icons.done_all_sharp,
                                      color: Colors.blue,
                                      size: 14,
                                    )),

                          ///voice message box
                          AppUtils.voiceBox(
                              context: context,
                              boxColor: index % 2 == 0
                                  ? AppColors.defaultColor
                                  : Colors.white,
                              rowAlignment: index % 2 == 0
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              onPlayTap: () async {
                                if (isPlaying) {
                                  await audioPlayer.pause();
                                } else {
                                  await audioPlayer.resume();
                                }
                              },
                              icon: isPlaying ? Icons.pause : Icons.play_arrow,
                              max: double.parse(duration.inSeconds.toString()),
                              val: position.inSeconds.toDouble(),
                              onSliderCh: (val) async {
                                final position = Duration(seconds: val.toInt());
                                await audioPlayer.seek(position);
                                ///if audio player paused
                                await audioPlayer.resume();
                              },
                              seekTime: formatTime(position),
                              voiceTime: "12:45"),

                          ///show image
                          ShowImageContainerWid(
                              imageHol: AppUtils.imageHolder,
                              imageTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ShowProfileImgWid(
                                      image: AppUtils.imageHolder,
                                    ),
                                  ),
                                );
                              },
                              color: index % 2 == 0
                                  ? Colors.white
                                  : AppColors.defaultColor),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          ///show container for text field
          ContainerTextFieldClassWid(
            controller: message,
          )
          // TextFieldSingleChatWidget(
          //   controller: message,
          //   onSend: () {
          //     message.clear();
          //   },
          // ),
        ],
      ),
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

  List singleChat = [
    "yaar bhul hi gaya",
    "aur sab thek",
    "ghar sab kase han",
    "aur kia chal raha hai life main hope everything is fine",
    'Main b thek hhu life bilkul be set nai hai',
    'ghuzara ooka hai',
    "yaar bhul hi gaya",
    "aur sab thek",
    "ghar sab kase han",
    "aur kia chal raha hai life main hope everything is fine",
    'Main b thek hhu life bilkul be set nai hai',
    'ghuzara ooka hai',
    "yaar bhul hi gaya",
    "aur sab thek",
    "ghar sab kase han",
    "aur kia chal raha hai life main hope everything is fine",
    'Main b thek hhu life bilkul be set nai hai',
    'ghuzara ooka hai',
  ];
}
