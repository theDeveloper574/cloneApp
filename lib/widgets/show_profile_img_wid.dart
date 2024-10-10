import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maanaap/res/colors.dart';
import 'package:maanaap/utils/utils.dart';

class ShowProfileImgWid extends StatelessWidget {
  final String image;

  ShowProfileImgWid({super.key, required this.image});

  final TransformationController _transformationController =
      TransformationController();
  TapDownDetails? _doubleTapDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Hero(
        tag: "show-profile-picture",
        child: GestureDetector(
          onDoubleTapDown: (d) => _doubleTapDetails = d,
          onDoubleTap: _handleDoubleTap,
          child: Container(
            color: Colors.black,
            height: double.infinity,
            width: double.infinity,
            child: InteractiveViewer(
              transformationController: _transformationController,
              minScale: 0.9,
              maxScale: 4,
              child: CachedNetworkImage(imageUrl: image, fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails!.localPosition;
      // For a 3x zoom
      _transformationController.value = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0);
      // Fox a 2x zoom
      // ..translate(-position.dx, -position.dy)
      // ..scale(2.0);
    }
  }
}

///show image before send

class ImageBeforeSend extends StatelessWidget {
  final File image;
  final void Function()? imageSendCall;

  ImageBeforeSend(
      {super.key, required this.image, required this.imageSendCall});

  final TransformationController _transformationController =
      TransformationController();
  TapDownDetails? _doubleTapDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        // iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
        ),
        backgroundColor: Colors.black,
      ),
      body: GestureDetector(
        onDoubleTapDown: (d) => _doubleTapDetails = d,
        onDoubleTap: _handleDoubleTap,
        child: Container(
          color: Colors.black,
          height: double.infinity,
          width: double.infinity,
          child: InteractiveViewer(
            transformationController: _transformationController,
            // transformationController: TrackingScrollController,
            // panEnabled: false, // Set it to false to prevent panning.
            // boundaryMargin: EdgeInsets.all(80),
            minScale: 0.9,
            maxScale: 4,
            child: Image.file(image, fit: BoxFit.contain),
          ),
        ),
      ),
      bottomSheet: Container(
        color: AppColors.blackColor,
        height: Get.height * 0.07,
        child: Row(
          children: [
            AppUtils.sizedBox(0.0, 12.0),
            Expanded(
              flex: 5,
              child: TextFormField(
                style: TextStyle(color: AppColors.whiteColor),
                cursorColor: AppColors.whiteColor,
                decoration: AppUtils.sendImageDecoration(),
              ),
            ),
            Expanded(
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  onPressed: imageSendCall,
                  icon: Icon(
                    Icons.send,
                    color: AppColors.defaultColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails!.localPosition;
      // For a 3x zoom
      _transformationController.value = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0);
      // Fox a 2x zoom
      // ..translate(-position.dx, -position.dy)
      // ..scale(2.0);
    }
  }
}
