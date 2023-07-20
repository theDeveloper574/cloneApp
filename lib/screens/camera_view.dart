import 'package:flutter/material.dart';

class CameraView extends StatelessWidget {
  const CameraView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: 1,
            (context, index) {
          return const Center(
            child: Text("Coming soon..."),
          );
        },
      ),
    );
  }
}