import 'package:flutter/material.dart';
import 'package:progressive_image/progressive_image.dart';
import '../res/colors.dart';
import '../utils/utils.dart';

class ShowImageContainerWid extends StatelessWidget {
  final Color color;
  final Function() imageTap;
  final String imageHol;

  const ShowImageContainerWid(
      {Key? key,
      required this.color,
      required this.imageTap,
      required this.imageHol})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: imageTap,
          child: Container(
            // height: 300,
            // width: 200,
            decoration: BoxDecoration(
                border: Border.all(color: color, width: 4.8),
                // color: Colors.red,
                borderRadius: BorderRadius.circular(10)),
            child: ProgressiveImage(
              fit: BoxFit.cover,
              fadeDuration: Duration(seconds: 5),
              placeholder: AssetImage('asset/loader_image.gif'),
              thumbnail: NetworkImage(
                  "https://images.pexels.com/photos/17077796/pexels-photo-17077796/free-photo-of-palazzo-pesaro-papafava-in-venice.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load"),
              image: NetworkImage(imageHol),
              width: 200,
              height: 300,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "12:34",
                  style: TextStyle(color: Colors.white),
                ),
                AppUtils.sizedBox(0.0, 4.0),
                Icon(
                  Icons.done_all_sharp,
                  color: Colors.blue,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
