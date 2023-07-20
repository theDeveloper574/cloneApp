import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ShowProfileImgWid extends StatelessWidget {
  final String image;

  ShowProfileImgWid({Key? key, required this.image}) : super(key: key);

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
              // transformationController: TrackingScrollController,
              // panEnabled: false, // Set it to false to prevent panning.
              // boundaryMargin: EdgeInsets.all(80),
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
