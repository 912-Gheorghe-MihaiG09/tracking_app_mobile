import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CloseButton extends StatelessWidget {
  final EdgeInsets? padding;
  final double? iconSize;
  final void Function()? action;

  const CloseButton({this.action, this.iconSize, this.padding, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 16),
      child: Align(
        alignment: Alignment.centerRight,
        child: IconButton(
          iconSize: iconSize,
          onPressed: action,
          icon: SvgPicture.asset("assets/images/common/close.svg"),
          padding: EdgeInsets.zero,
          // when iconSize is specified add constraints, to keep the button size
          // close to the icon size
          constraints: iconSize != null
              ? BoxConstraints.tight(Size(iconSize! + 4, iconSize! + 4))
              : null,
          style: const ButtonStyle(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: MaterialStatePropertyAll(EdgeInsets.zero),
          ),),
      ),
    );
  }
}
