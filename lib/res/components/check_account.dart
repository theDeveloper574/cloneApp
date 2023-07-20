import 'package:flutter/material.dart';
import 'package:maanaap/res/colors.dart';

class CheckAccountCompo extends StatelessWidget {
  final String accountDesc;
  final Function() onTap;
  final String buttonText;

  const CheckAccountCompo(
      {Key? key,
      required this.accountDesc,
      required this.onTap,
      required this.buttonText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(accountDesc),
        InkWell(
          onTap: onTap,
          child: Text(buttonText,
            style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
                color: AppColors.defaultColor),
          ),
        ),
      ],
    );
  }
}
