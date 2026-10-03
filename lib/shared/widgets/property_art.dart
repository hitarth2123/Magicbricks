import 'package:flutter/material.dart';

import '../../core/app_theme.dart';

class PropertyArt extends StatelessWidget {
  final Color accent;
  final IconData icon;
  final double width;
  final double height;
  final String? imageUrl;

  const PropertyArt({
    super.key,
    required this.accent,
    required this.icon,
    this.width = 150,
    this.height = 130,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: accent,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Stack(
      children: [
        if (imageUrl != null)
          Positioned.fill(
            child: Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
        if (imageUrl != null)
          Positioned.fill(child: ColoredBox(color: Colors.black26)),
        Positioned(
          right: -10,
          bottom: -14,
          child: Icon(
            icon,
            size: 105,
            color: Colors.white.withValues(alpha: .52),
          ),
        ),
        Positioned(
          left: 12,
          top: 12,
          child: Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .65),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 19, color: AppColors.ink),
          ),
        ),
        Positioned(
          left: 12,
          bottom: 12,
          child: Container(
            width: 58,
            height: 5,
            color: AppColors.ink.withValues(alpha: .75),
          ),
        ),
      ],
    ),
  );
}
