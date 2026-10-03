import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../data/property_data.dart';
import '../property/property_details_page.dart';

const officeImage =
    'https://images.unsplash.com/photo-1684152238410-b3f55b282da0?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&q=85&w=1400';

class ReferenceOverview extends StatelessWidget {
  final ValueChanged<String> onNavigate;
  const ReferenceOverview({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(32),
      children: [
        _hero(),
        const SizedBox(height: 18),
        const Row(
          children: [
            Expanded(
              child: MetricCard(
                icon: Icons.business_rounded,
                label: 'Live properties',
                value: '12,480',
                delta: '+632 this month',
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: MetricCard(
                icon: Icons.verified_user_outlined,
                label: 'Verified brokers',
                value: '2,140',
                delta: '98.7% response rate',
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: MetricCard(
                icon: Icons.trending_up_rounded,
                label: 'Avg. commercial yield',
                value: '8.4%',
                delta: '+1.2% YoY',
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: MetricCard(
                icon: Icons.groups_2_outlined,
                label: 'Businesses served',
                value: '36K+',
                delta: 'Across 18 cities',
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _featured(context)),
            const SizedBox(width: 18),
            Expanded(child: _leasePanel()),
          ],
        ),
      ],
    );
  }

  Widget _hero() => Container(
    height: 390,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: AppColors.ink,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Label(
                  text: "INDIA'S BUSINESS PROPERTY PLATFORM",
                  light: true,
                ),
                const SizedBox(height: 14),
                const Text(
                  'Space that works',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Text(
                  'as hard as you do.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Discover verified commercial spaces, model every lease, and make a confident business move.',
                  style: TextStyle(
                    color: Color(0xFFB7C4C9),
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 22),
                FilledButton.icon(
                  onPressed: () => onNavigate('search'),
                  icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                  label: const Text('Explore properties'),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                officeImage,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const ColoredBox(
                  color: Color(0xFF304852),
                  child: Center(
                    child: Icon(
                      Icons.business_rounded,
                      color: AppColors.lime,
                      size: 56,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.ink, Colors.transparent],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
              Positioned(
                top: 28,
                right: 28,
                child: _floatCard(
                  Icons.trending_up_rounded,
                  'Market signal',
                  'Rental yield up 8.4%',
                ),
              ),
              Positioned(
                bottom: 28,
                left: 28,
                child: _floatCard(
                  Icons.show_chart_rounded,
                  'Avg. savings found',
                  '₹4.8L / year',
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _floatCard(IconData icon, String title, String value) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .94),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.orange, size: 19),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: AppColors.muted, fontSize: 9),
            ),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ],
    ),
  );
  Widget _featured(BuildContext context) => Panel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Label(text: 'CURATED FOR GROWTH'),
        const SizedBox(height: 4),
        const Text(
          'Featured opportunities',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 14),
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  PropertyDetailsPage(property: commercialProperties.first),
            ),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Image.network(
                  officeImage,
                  width: 90,
                  height: 66,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const ColoredBox(
                    color: Color(0xFFEAF2F3),
                    child: Icon(
                      Icons.business_rounded,
                      color: AppColors.orange,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatusBadge(text: 'Verified'),
                    SizedBox(height: 4),
                    Text(
                      'One Horizon Center',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'Golf Course Road, Gurugram',
                      style: TextStyle(color: AppColors.muted, fontSize: 9),
                    ),
                  ],
                ),
              ),
              const Text(
                '₹2.8L',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
      ],
    ),
  );
  Widget _leasePanel() => Container(
    padding: const EdgeInsets.all(28),
    decoration: BoxDecoration(
      color: AppColors.ink,
      borderRadius: BorderRadius.circular(16),
    ),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(text: 'LEASE INTELLIGENCE', light: true),
        SizedBox(height: 10),
        Text(
          'Your next lease,\nwithout surprises.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            height: 1.05,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Model rent escalations, maintenance, deposits and total occupancy costs in minutes.',
          style: TextStyle(color: Color(0xFF92A5AD), fontSize: 11, height: 1.6),
        ),
        Divider(color: Color(0xFF2A3E47), height: 30),
        Text(
          'Potential negotiated savings',
          style: TextStyle(color: Color(0xFF8DA0A8), fontSize: 9),
        ),
        Text(
          '₹18.6 lakh',
          style: TextStyle(
            color: AppColors.lime,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    ),
  );
}

class Label extends StatelessWidget {
  final String text;
  final bool light;
  const Label({super.key, required this.text, this.light = false});
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      color: light ? AppColors.lime : AppColors.orange,
      fontSize: 9,
      fontWeight: FontWeight.w900,
      letterSpacing: 1.3,
    ),
  );
}

class StatusBadge extends StatelessWidget {
  final String text;
  const StatusBadge({super.key, required this.text});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xFFE7F6EE),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: AppColors.orange,
        fontSize: 8,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

class Panel extends StatelessWidget {
  final Widget child;
  const Panel({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: AppColors.line),
      borderRadius: BorderRadius.circular(15),
    ),
    child: child,
  );
}

class MetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String delta;
  const MetricCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.delta,
  });
  @override
  Widget build(BuildContext context) => Panel(
    child: Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF2F3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.orange, size: 19),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: AppColors.muted, fontSize: 9),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                delta,
                style: const TextStyle(color: AppColors.orange, fontSize: 8),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
