import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../shared/widgets/app_scaffold.dart';

class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});
  @override
  Widget build(BuildContext context) => SectionPage(
    title: 'Business toolkit',
    subtitle: 'Everything beyond the four walls.',
    child: Column(
      children: [
        _tile(
          context,
          Icons.architecture_rounded,
          'Floor plan viewer',
          'Check usable area and exact measurements',
          AppColors.blue,
          showFloorPlan,
        ),
        _tile(
          context,
          Icons.groups_2_outlined,
          'Footfall analysis',
          'Understand the people around your storefront',
          const Color(0xFFB88CF5),
          showFootfall,
        ),
        _tile(
          context,
          Icons.verified_user_outlined,
          'GST & compliance',
          'Registration, documents and timelines',
          const Color(0xFF50BFA3),
          showCompliance,
        ),
        _tile(
          context,
          Icons.workspace_premium_outlined,
          'List your property',
          'Reach serious commercial tenants',
          AppColors.orange,
          showPackage,
        ),
      ],
    ),
  );

  Widget _tile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color color,
    void Function(BuildContext) action,
  ) => ListTile(
    onTap: () => action(context),
    contentPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
    leading: Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .16),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: color),
    ),
    title: Text(
      title,
      style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w900),
    ),
    subtitle: Text(
      subtitle,
      style: const TextStyle(color: AppColors.muted, fontSize: 12),
    ),
    trailing: const Icon(
      Icons.arrow_forward_ios_rounded,
      size: 15,
      color: AppColors.muted,
    ),
  );
}

void showFloorPlan(BuildContext context) => showToolSheet(
  context,
  'Floor plan viewer',
  const Text(
    '2,400 sq.ft\n\n48 ft frontage  ·  50 ft depth  ·  9 ft ceiling',
    style: TextStyle(
      color: AppColors.ink,
      fontSize: 18,
      fontWeight: FontWeight.w800,
      height: 1.6,
    ),
  ),
);
void showFootfall(BuildContext context) => showToolSheet(
  context,
  'Footfall analysis',
  const Text(
    '18,420 estimated monthly footfall\n\nPeak window: 12:00 PM – 2:00 PM\nAudience: Young professionals\nNearby anchor: Third Wave Coffee',
    style: TextStyle(
      color: AppColors.ink,
      fontSize: 16,
      fontWeight: FontWeight.w800,
      height: 1.7,
    ),
  ),
);
void showCompliance(BuildContext context) => showToolSheet(
  context,
  'GST & compliance',
  const Text(
    'GST registration\nMandatory for commercial lease invoices above ₹20L annual turnover.\n\nDocuments checklist\nPAN, incorporation certificate, address proof and board resolution.\n\nTypical timeline\n3–7 working days after document verification.',
    style: TextStyle(
      color: AppColors.ink,
      fontSize: 15,
      fontWeight: FontWeight.w700,
      height: 1.7,
    ),
  ),
);
void showPackage(BuildContext context) => showToolSheet(
  context,
  'Reach better tenants',
  const Text(
    'Broker listing  ·  ₹2,999 / month\nVerified badge and lead dashboard\n\nPremium commercial  ·  ₹9,999 / month\n10 listings, featured status and priority leads',
    style: TextStyle(
      color: AppColors.ink,
      fontSize: 15,
      fontWeight: FontWeight.w700,
      height: 1.7,
    ),
  ),
);

void showToolSheet(BuildContext context, String title, Widget content) =>
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.paper,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 30),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 18),
              content,
            ],
          ),
        ),
      ),
    );
