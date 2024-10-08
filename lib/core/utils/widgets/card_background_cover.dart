import 'package:flutter/material.dart';

import '../../../config/theme.dart';

class CardBackgroundImageFilter extends StatelessWidget {
  final Widget child;

  /// Bu widget HabitCard ve StreakCard gibi resim üzerine yazı bulunan
  /// widget'lara siyah filtre uygulamak için kullanılıyor.
  ///
  /// Bu sayade image'ın rengi ne olursa olsun Card'ın üstündeki yazı okunabilecek.
  const CardBackgroundImageFilter({
    super.key,
    required this.child,
    this.opacity = 0.5,
    this.color = AppColors.darkTextColor,
  });
  final double opacity;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color.withOpacity(opacity),
      child: child,
    );
  }
}
