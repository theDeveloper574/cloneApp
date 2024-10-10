


import 'package:flutter/material.dart';

class StatusView extends StatelessWidget {
  const StatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: 1,
            (context, index) {
          return const Center(
            child: Text("Status view Screen"),
          );
        },
      ),
    );
  }
}