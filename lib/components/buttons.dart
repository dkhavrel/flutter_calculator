import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyButton extends StatefulWidget {
  final Color color;
  final Color textColor;
  final String buttonText;
  final VoidCallback buttonTapped;

  const MyButton({
    super.key,
    required this.color,
    required this.textColor,
    required this.buttonText,
    required this.buttonTapped,
  });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  late Color _shadedColor;
  late Color _shadedTextColor;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.97).animate(_animationController);

    _shadedColor =
        widget.color.withOpacity(0.7); // Slightly shaded color for the button
    _shadedTextColor =
        widget.textColor.withOpacity(0.7); // Slightly shaded color for the text

    _colorAnimation = ColorTween(
      begin: widget.color,
      end: _shadedColor,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticFeedback.selectionClick();
    _animationController.forward().then((_) {
      _animationController.reverse();
      widget.buttonTapped();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget? child) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  color: _colorAnimation.value,
                  child: Center(
                    child: Text(
                      widget.buttonText,
                      style: TextStyle(
                        color: _colorAnimation.value == _shadedColor
                            ? _shadedTextColor
                            : widget.textColor,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
