import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../data/property_data.dart';
import '../../shared/widgets/app_scaffold.dart';
import '../../shared/widgets/property_art.dart';
import '../property/property_details_page.dart';

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});
  @override
  Widget build(BuildContext context) => SectionPage(
    title: 'Saved spaces',
    subtitle: 'Your shortlist, ready when you are.',
    child: Column(
      children: [
        for (final property in commercialProperties.take(2))
          _card(context, property),
      ],
    ),
  );

  Widget _card(BuildContext context, dynamic property) => GestureDetector(
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PropertyDetailsPage(property: property),
      ),
    ),
    child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          PropertyArt(
            accent: property.accent,
            icon: property.icon,
            width: 92,
            height: 86,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  property.location,
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  property.price,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: AppColors.orange,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
        ],
      ),
    ),
  );
}
