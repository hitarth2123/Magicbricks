import 'package:flutter/material.dart';

import '../../core/app_theme.dart';

class SectionPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? eyebrow;
  final Widget? action;
  final Widget child;
  const SectionPage({
    super.key,
    required this.title,
    required this.subtitle,
    this.eyebrow,
    this.action,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => CustomScrollView(
    slivers: [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 25, 22, 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (eyebrow != null)
                      Text(
                        eyebrow!,
                        style: const TextStyle(
                          color: AppColors.orange,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                    if (eyebrow != null) const SizedBox(height: 8),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              if (action != null) ...[const SizedBox(width: 18), action!],
            ],
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        sliver: SliverToBoxAdapter(child: child),
      ),
    ],
  );
}

Widget primaryButton(String label, IconData icon, VoidCallback onTap) =>
    SizedBox(
      height: 52,
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.ink,
          foregroundColor: AppColors.lime,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );

Future<void> showAlertMessage(
  BuildContext context,
  String title,
  String message,
) => showDialog<void>(
  context: context,
  builder: (dialogContext) => AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      FilledButton(
        onPressed: () => Navigator.pop(dialogContext),
        child: const Text('Done'),
      ),
    ],
  ),
);
