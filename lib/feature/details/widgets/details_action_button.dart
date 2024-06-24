import 'package:flutter/material.dart';
import 'package:tracking_app/common/theme/colors.dart';

class DetailsActionButton {
  static Widget staticActionButton({
    required String text,
    required IconData icon,
    Size size = const Size(150, 100),
    void Function()? onPressed,
    Color color = AppColors.primary,
  }) {
    return _StaticActionButton(
      text: text,
      icon: icon,
      onPressed: onPressed,
      color: color,
      size: size,
    );
  }

  static Widget animatedActionButton({
    required String text,
    required IconData icon,
    required bool animate,
    required Color animationColor,
    Size size = const Size(150, 100),
    void Function()? onPressed,
    Color color = AppColors.primary,
  }) {
    return _AnimatedActionButton(
      text: text,
      icon: icon,
      onPressed: onPressed,
      color: color,
      size: size,
      animationColor: animationColor,
      animate: animate,
    );
  }
}

class _StaticActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Size size;
  final void Function()? onPressed;
  final Color color;

  const _StaticActionButton(
      {required this.text,
      required this.icon,
      required this.size,
      this.onPressed,
      this.color = AppColors.primary});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
            ),
            Text(
              text,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedActionButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final Size size;
  final void Function()? onPressed;
  final Color color;
  final Color animationColor;
  final bool animate;

  const _AnimatedActionButton({
    required this.text,
    required this.icon,
    required this.size,
    this.onPressed,
    required this.color,
    required this.animationColor,
    required this.animate,
  });

  @override
  State<_AnimatedActionButton> createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<_AnimatedActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation =
        ColorTween(begin: widget.color, end: widget.animationColor)
            .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return _StaticActionButton(
          text: widget.text,
          icon: widget.icon,
          size: widget.size,
          onPressed: widget.onPressed,
          color: widget.animate
              ? _colorAnimation.value ?? widget.color
              : widget.color,
        );
      },
    );
  }
}
