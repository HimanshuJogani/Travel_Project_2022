import 'package:flutter/material.dart';

import '../../../../core/theme/make_my_trip_colors.dart';

class CircleIconButton extends StatelessWidget {
  CircleIconButton({
    Key? key,
    required this.iconData,
    required this.isRotete,
    required this.iconBtn,
  }) : super(key: key);

  final bool isRotete;
  final IconData iconData;
  VoidCallback iconBtn;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: iconBtn,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: 1,
              color: MakeMyTripColors.color50gray,
            )),
        child: Transform.rotate(
            angle: (isRotete) ? 0.8 : 0,
            child: Icon(iconData, color: MakeMyTripColors.color50gray)),
      ),
    );
  }
}