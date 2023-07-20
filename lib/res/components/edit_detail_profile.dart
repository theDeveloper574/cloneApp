import 'package:flutter/material.dart';
import 'package:maanaap/res/colors.dart';

class EditDetailProfileCompo extends StatelessWidget {
  final IconData iconData;
  final String name;
  final Widget widget;
  final Widget editIcon;

  const EditDetailProfileCompo(
      {Key? key,
      required this.iconData,
      required this.name,
      required this.widget,
      required this.editIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(iconData),
      title: Text(name),
      subtitle: widget,
      trailing: editIcon,
    );
  }
}
