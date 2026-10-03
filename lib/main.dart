import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'data/property_data.dart';
import 'features/admin/admin_page.dart';
import 'features/auth/login_page.dart';
import 'features/calculator/calculator_page.dart';
import 'features/home/home_page.dart';
import 'features/property/property_details_page.dart';
import 'features/profile/profile_page.dart';
import 'features/reference/reference_pages.dart';
import 'features/reference/reference_dashboard_pages.dart';
import 'features/tools/tool_detail_pages.dart';

void main() => runApp(const MagicbricksApp());

class MagicbricksApp extends StatefulWidget {
  const MagicbricksApp({super.key});

  @override
  State<MagicbricksApp> createState() => _MagicbricksAppState();
}

class _MagicbricksAppState extends State<MagicbricksApp> {
  bool? isAdmin;

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Magicbricks Commercial',
    theme: AppTheme.data,
    home: isAdmin == null
        ? LoginPage(onLogin: (role) => setState(() => isAdmin = role))
        : AppShell(
            isAdmin: isAdmin!,
            onSignOut: () => setState(() => isAdmin = null),
          ),
  );
}

class AppShell extends StatefulWidget {
  final bool isAdmin;
  final VoidCallback onSignOut;

  const AppShell({super.key, required this.isAdmin, required this.onSignOut});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int selected = 0;
  static const labels = [
    'Overview',
    'Find properties',
    'Property detail',
    'Lease calculator',
    'Floor plans',
    'Footfall analytics',
    'GST & compliance',
    'Plans & pricing',
    'Profile',
    'Admin',
  ];
  static const icons = [
    Icons.grid_view_rounded,
    Icons.search_rounded,
    Icons.business_outlined,
    Icons.calculate_outlined,
    Icons.architecture_rounded,
    Icons.bar_chart_rounded,
    Icons.verified_user_outlined,
    Icons.workspace_premium_outlined,
    Icons.person_outline_rounded,
    Icons.admin_panel_settings_outlined,
  ];

  Widget page() {
    switch (selected) {
      case 1:
        return const HomePage();
      case 2:
        return PropertyDetailsPage(property: commercialProperties.first);
      case 3:
        return const CalculatorPage();
      case 4:
        return const FloorPlanPage();
      case 5:
        return const FootfallDashboardPage();
      case 6:
        return const ComplianceDashboardPage();
      case 7:
        return const PlansDashboardPage();
      case 8:
        return const ProfilePage();
      case 9:
        return widget.isAdmin ? const AdminPage() : const HomePage();
      default:
        return ReferenceOverview(
          onNavigate: (name) => setState(
            () => selected = name == 'search'
                ? 1
                : name == 'calculator'
                ? 3
                : 0,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final compact = constraints.maxWidth < 860;
      return Scaffold(
        body: compact
            ? Column(
                children: [
                  header(),
                  Expanded(
                    child: ColoredBox(color: AppColors.paper, child: page()),
                  ),
                  compactNav(),
                ],
              )
            : Row(
                children: [
                  sidebar(),
                  Expanded(
                    child: Column(
                      children: [
                        header(),
                        Expanded(
                          child: ColoredBox(
                            color: AppColors.paper,
                            child: page(),
                          ),
                        ),
                        footer(),
                      ],
                    ),
                  ),
                ],
              ),
      );
    },
  );

  Widget sidebar() => Container(
    width: 246,
    color: AppColors.ink,
    padding: const EdgeInsets.fromLTRB(18, 28, 18, 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => selected = 0),
          child: Row(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: AppColors.lime,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Center(
                  child: Text(
                    'mb',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'magicbricks',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'COMMERCIAL',
                      style: TextStyle(
                        color: Color(0xFF8FA0A8),
                        fontSize: 8,
                        letterSpacing: 2.4,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Expanded(
          child: ListView(
            children: [
              for (var i = 0; i < labels.length; i++)
                if (i != 9 || widget.isAdmin) navItem(i),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color(0xFF203944),
            border: Border.all(color: const Color(0xFF2D4752)),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.lime,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.trending_up_rounded,
                  color: AppColors.ink,
                  size: 18,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Free lease advisory',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Get expert help with your next business move.',
                style: TextStyle(
                  color: Color(0xFF94A7AF),
                  fontSize: 10,
                  height: 1.5,
                ),
              ),
              TextButton(
                onPressed: () => setState(() => selected = 6),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  foregroundColor: AppColors.lime,
                ),
                child: const Text(
                  'Book a consultation →',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 17),
        const Divider(color: Color(0xFF273A43)),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => setState(() => selected = 8),
          borderRadius: BorderRadius.circular(10),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFF31505C),
                  child: Text(
                    'RM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rahul Mehta',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Corporate account',
                        style: TextStyle(color: Color(0xFF78909A), fontSize: 8),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.more_horiz, color: Color(0xFF82959D), size: 18),
              ],
            ),
          ),
        ),
        TextButton.icon(
          onPressed: widget.onSignOut,
          icon: const Icon(Icons.logout_rounded, size: 16),
          label: const Text('Sign out'),
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFFB7C4C9),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          ),
        ),
      ],
    ),
  );

  Widget navItem(int index) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: InkWell(
      onTap: () => setState(() => selected = index),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: selected == index
              ? const Color(0xFF20343D)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icons[index],
              color: selected == index
                  ? AppColors.lime
                  : const Color(0xFF9EB0B7),
              size: 18,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                labels[index],
                style: TextStyle(
                  color: selected == index
                      ? Colors.white
                      : const Color(0xFF9EB0B7),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (selected == index)
              Container(
                width: 3,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.lime,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),
      ),
    ),
  );

  Widget compactNav() => Container(
    height: 68,
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(top: BorderSide(color: AppColors.line)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        for (final index in [0, 1, 3, 4, 6, if (widget.isAdmin) 9])
          IconButton(
            tooltip: labels[index],
            onPressed: () => setState(() => selected = index),
            icon: Icon(
              icons[index],
              color: selected == index ? AppColors.orange : AppColors.muted,
            ),
          ),
      ],
    ),
  );
  Widget header() => Container(
    height: 70,
    padding: const EdgeInsets.symmetric(horizontal: 32),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .95),
      border: const Border(bottom: BorderSide(color: AppColors.line)),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selected == 0 ? 'Workspace overview' : labels[selected],
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Text(
                'Funding showcase • Live prototype',
                style: TextStyle(color: AppColors.muted, fontSize: 9),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Notifications',
          onPressed: () => showDialog<void>(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: const Text('Notifications'),
              content: const Text(
                'You have 2 new responses from verified property managers.',
              ),
              actions: [
                FilledButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Done'),
                ),
              ],
            ),
          ),
          icon: const Icon(Icons.notifications_none_rounded),
        ),
        const SizedBox(width: 8),
        FilledButton(
          onPressed: () => setState(() => selected = 1),
          child: const Text('Find a property'),
        ),
      ],
    ),
  );
  Widget footer() => Container(
    height: 55,
    padding: const EdgeInsets.symmetric(horizontal: 32),
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(top: BorderSide(color: AppColors.line)),
    ),
    child: const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '© 2025 Magicbricks Commercial',
          style: TextStyle(color: AppColors.muted, fontSize: 9),
        ),
        Text(
          'Built for India\'s next business move.',
          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700),
        ),
        Text(
          'Privacy     Terms     Support',
          style: TextStyle(color: AppColors.muted, fontSize: 9),
        ),
      ],
    ),
  );
}
