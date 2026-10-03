import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../data/property_data.dart';
import '../../shared/widgets/app_scaffold.dart';

class FootfallLocation {
  final String name;
  final String monthly;
  final String peak;
  final String conversion;
  final String repeat;
  final List<int> bars;

  const FootfallLocation({
    required this.name,
    required this.monthly,
    required this.peak,
    required this.conversion,
    required this.repeat,
    required this.bars,
  });
}

const footfallLocations = [
  FootfallLocation(
    name: 'Indiranagar High Street',
    monthly: '86.4K',
    peak: '6–8 PM',
    conversion: 'High',
    repeat: '72%',
    bars: [58, 68, 86, 72, 94, 100, 88],
  ),
  FootfallLocation(
    name: 'Koramangala 5th Block',
    monthly: '64.8K',
    peak: '1–3 PM',
    conversion: 'Medium',
    repeat: '61%',
    bars: [44, 58, 82, 90, 76, 68, 54],
  ),
  FootfallLocation(
    name: 'Phoenix Market Lane',
    monthly: '112.2K',
    peak: '5–8 PM',
    conversion: 'High',
    repeat: '79%',
    bars: [38, 50, 68, 84, 96, 100, 94],
  ),
];

class FootfallDashboardPage extends StatefulWidget {
  const FootfallDashboardPage({super.key});

  @override
  State<FootfallDashboardPage> createState() => _FootfallDashboardPageState();
}

class _FootfallDashboardPageState extends State<FootfallDashboardPage> {
  String period = 'Last 30 days';
  bool compare = false;
  int selectedLocation = 0;
  int selectedProperty = 0;

  FootfallLocation get location => footfallLocations[selectedLocation];

  @override
  Widget build(BuildContext context) => SectionPage(
    eyebrow: 'RETAIL LOCATION INTELLIGENCE',
    title: 'See where business walks in.',
    subtitle: 'Real movement data to validate your next retail location.',
    action: DropdownButton<String>(
      value: period,
      underline: const SizedBox.shrink(),
      items: const [
        DropdownMenuItem(value: 'Last 30 days', child: Text('Last 30 days')),
        DropdownMenuItem(value: 'Last 90 days', child: Text('Last 90 days')),
      ],
      onChanged: (value) => setState(() => period = value!),
    ),
    child: Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: DropdownButton<String>(
            value: commercialProperties[selectedProperty].title,
            items: [
              for (var index = 0; index < commercialProperties.length; index++)
                DropdownMenuItem(
                  value: commercialProperties[index].title,
                  child: Text(commercialProperties[index].title),
                ),
            ],
            onChanged: (value) => setState(() {
              selectedProperty = commercialProperties.indexWhere(
                (item) => item.title == value,
              );
              selectedLocation = selectedProperty % footfallLocations.length;
            }),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: constraints.maxWidth >= 700
                    ? (constraints.maxWidth - 24) / 3
                    : constraints.maxWidth,
                child: _metric(
                  location.monthly,
                  'Monthly footfall',
                  '+12.8% vs last month',
                  Icons.groups_2_outlined,
                ),
              ),
              SizedBox(
                width: constraints.maxWidth >= 700
                    ? (constraints.maxWidth - 24) / 3
                    : constraints.maxWidth,
                child: _metric(
                  location.peak,
                  'Peak window',
                  '${location.repeat} repeat audience',
                  Icons.schedule_rounded,
                ),
              ),
              SizedBox(
                width: constraints.maxWidth >= 700
                    ? (constraints.maxWidth - 24) / 3
                    : constraints.maxWidth,
                child: _metric(
                  compare ? '3–6%' : location.conversion,
                  'Conversion potential',
                  compare
                      ? 'Low to medium scenarios'
                      : 'Top 8% of micro-market',
                  Icons.trending_up_rounded,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final chart = _panel(
              'WEEKLY PATTERN',
              'Average daily visitors',
              SizedBox(
                height: 250,
                child: Column(
                  children: [
                    Expanded(
                      child: CustomPaint(
                        painter: VisitorChartPainter(values: location.bars),
                      ),
                    ),
                    _insight(
                      'Saturday is your strongest opportunity',
                      'Footfall is 84% higher than the weekday average.',
                    ),
                  ],
                ),
              ),
            );
            final map = _panel(
              'MOVEMENT DENSITY',
              'Area heatmap',
              SizedBox(
                height: 250,
                child: Column(
                  children: [
                    Expanded(child: CustomPaint(painter: HeatmapPainter())),
                    const Text(
                      'Low   ▪ ▪ ▪ ▪   High traffic',
                      style: TextStyle(color: AppColors.muted, fontSize: 10),
                    ),
                  ],
                ),
              ),
            );
            return constraints.maxWidth >= 760
                ? Row(
                    children: [
                      Expanded(flex: 3, child: chart),
                      const SizedBox(width: 16),
                      Expanded(flex: 2, child: map),
                    ],
                  )
                : Column(children: [chart, const SizedBox(height: 16), map]);
          },
        ),
        const SizedBox(height: 16),
        _panel(
          'TRADE AREA PROFILE',
          'Who visits this location?',
          Wrap(
            spacing: 24,
            runSpacing: 18,
            children: [
              _audience('62%', 'Working professionals', 'Primary audience'),
              _audience('24–38', 'Core age group', 'High spending power'),
              _audience(
                '₹18L+',
                'Median household income',
                'Top urban quartile',
              ),
              _audience('3.2 km', 'Primary catchment', '12-minute drive'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => setState(() => compare = !compare),
          icon: const Icon(Icons.compare_arrows_rounded),
          label: Text(
            compare
                ? 'Hide conversion comparison'
                : 'Compare low and medium conversion',
          ),
        ),
      ],
    ),
  );
}

class ComplianceDashboardPage extends StatefulWidget {
  const ComplianceDashboardPage({super.key});

  @override
  State<ComplianceDashboardPage> createState() =>
      _ComplianceDashboardPageState();
}

class _ComplianceDashboardPageState extends State<ComplianceDashboardPage> {
  final complete = [true, true, false, false];
  final labels = [
    'Business registration',
    'GST verification',
    'Authorized signatory',
    'Lease documentation',
  ];

  @override
  Widget build(BuildContext context) {
    final ready = complete.where((item) => item).length;
    return SectionPage(
      eyebrow: 'BUSINESS ONBOARDING',
      title: 'Lease-ready, without the paperwork maze.',
      subtitle:
          'Track registration, GST and lease compliance in one secure place.',
      action: FilledButton.icon(
        onPressed: () => _advisor(context),
        icon: const Icon(Icons.arrow_forward_rounded, size: 16),
        label: const Text('Talk to an advisor'),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final checklist = _card(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'YOUR READINESS SCORE',
                            style: TextStyle(
                              color: AppColors.orange,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${(ready / complete.length * 100).round()}%',
                            style: const TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const Text(
                            'Two items left before documentation.',
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: CircularProgressIndicator(
                        value: ready / complete.length,
                        strokeWidth: 8,
                        color: AppColors.orange,
                        backgroundColor: AppColors.line,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 30),
                for (var index = 0; index < labels.length; index++)
                  _checkRow(index),
              ],
            ),
          );
          final side = Column(
            children: [
              _card(
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      color: AppColors.orange,
                      size: 24,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'GST on commercial rent',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Commercial property rent attracts 18% GST when the landlord is GST-registered. Your business may claim input tax credit subject to eligibility.',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 11,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _card(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'FREE FOR CORPORATE CLIENTS',
                      style: TextStyle(
                        color: AppColors.orange,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Need a second opinion?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Get a no-cost lease and compliance review from our commercial advisory desk.',
                      style: TextStyle(color: AppColors.muted, fontSize: 11),
                    ),
                    const SizedBox(height: 12),
                    primaryButton(
                      'Book free consultation',
                      Icons.support_agent_rounded,
                      () => _advisor(context),
                    ),
                  ],
                ),
              ),
            ],
          );
          return Column(
            children: [
              constraints.maxWidth >= 800
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: checklist),
                        const SizedBox(width: 16),
                        Expanded(flex: 2, child: side),
                      ],
                    )
                  : Column(
                      children: [checklist, const SizedBox(height: 14), side],
                    ),
              const SizedBox(height: 16),
              _card(
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'COMPLIANCE LIBRARY',
                            style: TextStyle(
                              color: AppColors.orange,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.1,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Documents you’ll need',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    for (final item in [
                      'GST Certificate',
                      'Business PAN',
                      'Board Resolution',
                      'Registered Lease',
                    ])
                      Expanded(
                        child: ListTile(
                          dense: true,
                          leading: const Icon(
                            Icons.description_outlined,
                            color: AppColors.orange,
                            size: 18,
                          ),
                          title: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          subtitle: const Text(
                            'Template available',
                            style: TextStyle(fontSize: 9),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _checkRow(int index) => InkWell(
    onTap: () => setState(() => complete[index] = !complete[index]),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: complete[index]
                ? const Color(0xFFE7F6EE)
                : const Color(0xFFF0F3F3),
            child: complete[index]
                ? const Icon(Icons.check, color: AppColors.orange, size: 16)
                : Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  labels[index],
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
                Text(
                  complete[index] ? 'Verified' : 'PAN and board resolution',
                  style: const TextStyle(color: AppColors.muted, fontSize: 10),
                ),
              ],
            ),
          ),
          Text(
            complete[index] ? 'Verified' : 'Add details',
            style: TextStyle(
              color: complete[index] ? AppColors.muted : AppColors.orange,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _card(Widget child) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: AppColors.line),
      borderRadius: BorderRadius.circular(16),
    ),
    child: child,
  );

  void _advisor(BuildContext context) => showAlertMessage(
    context,
    'Request created',
    'Your compliance advisor request has been created. Our team will contact you within one business day.',
  );
}

class PlansDashboardPage extends StatefulWidget {
  const PlansDashboardPage({super.key});

  @override
  State<PlansDashboardPage> createState() => _PlansDashboardPageState();
}

class _PlansDashboardPageState extends State<PlansDashboardPage> {
  bool quarterly = false;
  int selected = 2;

  @override
  Widget build(BuildContext context) => SectionPage(
    eyebrow: 'SIMPLE COMMERCIAL PRICING',
    title: 'List smarter. Close faster.',
    subtitle:
        'High-intent business buyers, verified leads, and no hidden fees.',
    child: Column(
      children: [
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(value: false, label: Text('Monthly')),
            ButtonSegment(value: true, label: Text('Quarterly  Save 15%')),
          ],
          selected: {quarterly},
          onSelectionChanged: (value) =>
              setState(() => quarterly = value.first),
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final cards = [
              _plan(
                0,
                'Property search',
                'Free',
                'For businesses',
                'Find, compare and calculate your ideal commercial space.',
                [
                  'Unlimited property search',
                  'Lease rental calculator',
                  'Floor plans & footfall insights',
                ],
                Icons.search_rounded,
              ),
              _plan(
                1,
                'Single listing',
                quarterly ? '₹2,549' : '₹2,999',
                'For independent brokers',
                'Professional visibility for one high-quality listing.',
                [
                  'Verified broker badge',
                  'Qualified business enquiries',
                  'Performance dashboard',
                ],
                Icons.business_outlined,
              ),
              _plan(
                2,
                'Premium commercial',
                quarterly ? '₹8,499' : '₹9,999',
                'For commercial teams',
                'Priority exposure and intelligence across your portfolio.',
                [
                  '10 active listings',
                  'Featured status & search boost',
                  'Advanced lead analytics',
                  'Dedicated account manager',
                ],
                Icons.workspace_premium_outlined,
              ),
            ];
            return constraints.maxWidth >= 850
                ? IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: cards
                          .map(
                            (card) => Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: card,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  )
                : Column(
                    children: cards
                        .map(
                          (card) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: card,
                          ),
                        )
                        .toList(),
                  );
          },
        ),
        const SizedBox(height: 18),
        _card(
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CORPORATE LEASE ADVISORY',
                      style: TextStyle(
                        color: AppColors.orange,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.1,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Planning a move for 50+ employees?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'Our experts will shortlist, negotiate and close your next office.',
                      style: TextStyle(color: AppColors.muted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                onPressed: () => showAlertMessage(
                  context,
                  'Strategy call requested',
                  'Our advisory desk will contact you to schedule a free strategy call.',
                ),
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                label: const Text('Book a strategy call'),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _plan(
    int index,
    String title,
    String price,
    String audience,
    String description,
    List<String> features,
    IconData icon,
  ) => InkWell(
    onTap: () => setState(() => selected = index),
    borderRadius: BorderRadius.circular(16),
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: selected == index ? AppColors.lime : AppColors.line,
          width: selected == index ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF3F0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.orange),
          ),
          const SizedBox(height: 18),
          Text(
            audience.toUpperCase(),
            style: const TextStyle(
              color: AppColors.orange,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          Text(
            price,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 11,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              switch (title) {
                'Property search' => '12,480 live spaces • 18 cities',
                'Single listing' => '98.7% average broker response rate',
                _ => '10 listings • Featured search status',
              },
              style: const TextStyle(
                color: AppColors.orange,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const Divider(height: 26),
          for (final feature in features)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_rounded,
                    color: AppColors.orange,
                    size: 16,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(feature, style: const TextStyle(fontSize: 11)),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => showAlertMessage(
                context,
                'Plan selected',
                '$title is ready for checkout.',
              ),
              child: const Text('Choose plan'),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _card(Widget child) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: AppColors.line),
      borderRadius: BorderRadius.circular(16),
    ),
    child: child,
  );
}

Widget _metric(String value, String label, String delta, IconData icon) =>
    Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: AppColors.muted, fontSize: 10),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  delta,
                  style: const TextStyle(color: AppColors.orange, fontSize: 9),
                ),
              ],
            ),
          ),
        ],
      ),
    );

Widget _panel(String eyebrow, String title, Widget child) => Container(
  padding: const EdgeInsets.all(18),
  decoration: BoxDecoration(
    color: Colors.white,
    border: Border.all(color: AppColors.line),
    borderRadius: BorderRadius.circular(16),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        eyebrow,
        style: const TextStyle(
          color: AppColors.orange,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.1,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
      ),
      const SizedBox(height: 12),
      child,
    ],
  ),
);

Widget _insight(String title, String body) => Container(
  margin: const EdgeInsets.only(top: 12),
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: const Color(0xFFE7F6EE),
    borderRadius: BorderRadius.circular(10),
  ),
  child: Row(
    children: [
      const Icon(Icons.trending_up_rounded, color: AppColors.orange, size: 18),
      const SizedBox(width: 8),
      Expanded(
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '$title\n',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                ),
              ),
              TextSpan(
                text: body,
                style: const TextStyle(color: AppColors.muted, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
);

Widget _audience(String value, String label, String note) => SizedBox(
  width: 150,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        value,
        style: const TextStyle(
          color: AppColors.orange,
          fontSize: 21,
          fontWeight: FontWeight.w900,
        ),
      ),
      Text(
        label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
      ),
      Text(note, style: const TextStyle(color: AppColors.muted, fontSize: 9)),
    ],
  ),
);

class VisitorChartPainter extends CustomPainter {
  final List<int> values;
  VisitorChartPainter({required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width / values.length;
    for (var index = 0; index < values.length; index++) {
      final height = size.height * values[index] / 125;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            index * width + 10,
            size.height - height - 20,
            width - 20,
            height,
          ),
          const Radius.circular(5),
        ),
        Paint()..color = index > 4 ? AppColors.lime : const Color(0xFFB9D9D1),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HeatmapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final block = Paint()..color = const Color(0xFFE7EEE9);
    canvas.drawRect(
      Rect.fromLTWH(10, 20, size.width - 20, size.height * .35),
      block,
    );
    canvas.drawRect(
      Rect.fromLTWH(10, size.height * .58, size.width - 20, size.height * .32),
      block,
    );
    for (final point in [
      (size.width * .54, size.height * .48, 42.0, const Color(0xFFFFA927)),
      (size.width * .72, size.height * .68, 32.0, const Color(0xFFF4E05B)),
      (size.width * .38, size.height * .72, 25.0, const Color(0xFFE85D45)),
    ]) {
      canvas.drawCircle(
        Offset(point.$1, point.$2),
        point.$3,
        Paint()..color = point.$4.withValues(alpha: .75),
      );
    }
    canvas.drawCircle(
      Offset(size.width * .54, size.height * .48),
      11,
      Paint()..color = AppColors.ink,
    );
    canvas.drawCircle(
      Offset(size.width * .54, size.height * .48),
      4,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
