import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../data/property_data.dart';
import '../../shared/widgets/app_scaffold.dart';

class FloorPlanData {
  final String name;
  final String floor;
  final String area;
  final String carpet;
  final String common;
  final String service;
  final String workstations;
  final String cabins;
  final String meetingRooms;
  final String density;
  final String width;
  final String depth;

  const FloorPlanData({
    required this.name,
    required this.floor,
    required this.area,
    required this.carpet,
    required this.common,
    required this.service,
    required this.workstations,
    required this.cabins,
    required this.meetingRooms,
    required this.density,
    required this.width,
    required this.depth,
  });
}

const floorPlans = [
  FloorPlanData(
    name: 'North wing office',
    floor: '12th floor • North wing',
    area: '4,800 sq.ft',
    carpet: '3,744 sq.ft',
    common: '816 sq.ft',
    service: '240 sq.ft',
    workstations: '54',
    cabins: '2',
    meetingRooms: '3',
    density: '69 sq.ft',
    width: '72 ft',
    depth: '65 ft',
  ),
  FloorPlanData(
    name: 'Retail corner unit',
    floor: 'Ground floor • East arcade',
    area: '2,250 sq.ft',
    carpet: '1,980 sq.ft',
    common: '180 sq.ft',
    service: '90 sq.ft',
    workstations: '—',
    cabins: '1',
    meetingRooms: '1',
    density: 'Retail',
    width: '45 ft',
    depth: '50 ft',
  ),
  FloorPlanData(
    name: 'Warehouse dock bay',
    floor: 'Bay 04 • Loading zone',
    area: '18,500 sq.ft',
    carpet: '17,200 sq.ft',
    common: '800 sq.ft',
    service: '500 sq.ft',
    workstations: '12',
    cabins: '2',
    meetingRooms: '1',
    density: 'Storage',
    width: '148 ft',
    depth: '125 ft',
  ),
];

class FloorPlanPage extends StatefulWidget {
  const FloorPlanPage({super.key});

  @override
  State<FloorPlanPage> createState() => _FloorPlanPageState();
}

class _FloorPlanPageState extends State<FloorPlanPage> {
  String selectedRoom = 'Open office';
  String floorLayout = 'Fitted layout';
  int selectedPlan = 0;
  int selectedProperty = 0;
  bool showDimensions = true;
  double zoom = 1;
  final planController = TransformationController();

  FloorPlanData get plan => floorPlans[selectedPlan];

  @override
  void dispose() {
    planController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SectionPage(
    title: 'Floor plan viewer',
    subtitle: 'Inspect measured layouts before your site visit.',
    eyebrow: 'SPATIAL INTELLIGENCE',
    action: SegmentedButton<String>(
      segments: const [
        ButtonSegment(value: 'Fitted layout', label: Text('Fitted layout')),
        ButtonSegment(value: 'Bare shell', label: Text('Bare shell')),
      ],
      selected: {floorLayout},
      onSelectionChanged: (value) => setState(() => floorLayout = value.first),
    ),
    child: _floorWorkspace(),
  );

  Widget _floorWorkspace() => LayoutBuilder(
    builder: (context, constraints) {
      final wide = constraints.maxWidth >= 900;
      final canvas = _planCanvas();
      final info = _areaStatement();
      return Column(
        children: [
          wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: canvas),
                    const SizedBox(width: 16),
                    SizedBox(width: 260, child: info),
                  ],
                )
              : Column(children: [canvas, const SizedBox(height: 16), info]),
          const SizedBox(height: 16),
          primaryButton(
            'Request measured walkthrough',
            Icons.calendar_today_outlined,
            () => _showMessage(
              context,
              'Walkthrough request sent to the property manager.',
            ),
          ),
        ],
      );
    },
  );

  Widget _planCanvas() => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.line),
    ),
    child: Column(
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 12,
          runSpacing: 8,
          children: [
            DropdownButton<String>(
              value: commercialProperties[selectedProperty].title,
              underline: const SizedBox.shrink(),
              items: [
                for (
                  var index = 0;
                  index < commercialProperties.length;
                  index++
                )
                  DropdownMenuItem(
                    value: commercialProperties[index].title,
                    child: Text(commercialProperties[index].title),
                  ),
              ],
              onChanged: (value) => setState(() {
                selectedProperty = commercialProperties.indexWhere(
                  (item) => item.title == value,
                );
                selectedPlan = selectedProperty % floorPlans.length;
              }),
            ),
            DropdownButton<String>(
              value: plan.name,
              underline: const SizedBox.shrink(),
              items: [
                for (final item in floorPlans)
                  DropdownMenuItem(value: item.name, child: Text(item.name)),
              ],
              onChanged: (value) => setState(
                () => selectedPlan = floorPlans.indexWhere(
                  (item) => item.name == value,
                ),
              ),
            ),
            Text(
              '${zoom.toStringAsFixed(0)}00%',
              style: const TextStyle(color: AppColors.muted, fontSize: 11),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 390,
          child: InteractiveViewer(
            transformationController: planController,
            minScale: .8,
            maxScale: 2.5,
            child: CustomPaint(
              painter: FloorPlanPainter(
                showDimensions: showDimensions,
                selectedRoom: selectedRoom,
                fitted: floorLayout == 'Fitted layout',
                widthLabel: plan.width,
                depthLabel: plan.depth,
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: zoom,
                min: 1,
                max: 2.5,
                activeColor: AppColors.orange,
                onChanged: (value) {
                  setState(() => zoom = value);
                  planController.value = Matrix4.identity()
                    ..scaleByDouble(value, value, value, 1);
                },
              ),
            ),
            Switch.adaptive(
              value: showDimensions,
              activeThumbColor: AppColors.orange,
              onChanged: (value) => setState(() => showDimensions = value),
            ),
          ],
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Legend(color: Color(0xFFE9F4D1), label: 'Usable space'),
            SizedBox(width: 14),
            _Legend(color: Color(0xFFE8EEF0), label: 'Common area'),
            SizedBox(width: 14),
            _Legend(color: Color(0xFFFFE8BE), label: 'Service area'),
          ],
        ),
      ],
    ),
  );

  Widget _areaStatement() => Column(
    children: [
      _panel(
        title: 'AREA STATEMENT',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              plan.area,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 16),
            _info('Efficiency', '78%', Icons.donut_large_rounded),
            _info('Carpet area', plan.carpet, Icons.square_foot_rounded),
            _info('Common area', plan.common, Icons.grid_view_rounded),
            _info('Service area', plan.service, Icons.room_service_outlined),
          ],
        ),
      ),
      const SizedBox(height: 14),
      _panel(
        title: 'FIT-OUT CAPACITY',
        child: Column(
          children: [
            _capacity('Workstations', plan.workstations),
            _capacity('Cabins', plan.cabins),
            _capacity('Meeting rooms', plan.meetingRooms),
            _capacity('Seat density', plan.density),
          ],
        ),
      ),
    ],
  );

  Widget _capacity(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.muted, fontSize: 11),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
        ),
      ],
    ),
  );
}

class FootfallPage extends StatefulWidget {
  const FootfallPage({super.key});

  @override
  State<FootfallPage> createState() => _FootfallPageState();
}

class _FootfallPageState extends State<FootfallPage> {
  String selectedDay = 'Weekday average';
  bool comparing = false;

  @override
  Widget build(BuildContext context) => SectionPage(
    title: 'Footfall analytics',
    subtitle: 'Know when your customers arrive and what surrounds them.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _statusHeader(
          'LOCATION SIGNAL',
          'Updated 18 min ago',
          Icons.wifi_tethering,
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _bigMetric(
                '18,420',
                'estimated monthly visits',
                AppColors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _bigMetric('72%', 'repeat audience', AppColors.blue),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _panel(
          title: 'Hourly activity',
          trailing: DropdownButton<String>(
            value: selectedDay,
            underline: const SizedBox.shrink(),
            items: const [
              DropdownMenuItem(
                value: 'Weekday average',
                child: Text('Weekday average'),
              ),
              DropdownMenuItem(
                value: 'Weekend average',
                child: Text('Weekend average'),
              ),
            ],
            onChanged: (value) => setState(() => selectedDay = value!),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 150,
                child: CustomPaint(
                  painter: FootfallPainter(
                    weekend: selectedDay.startsWith('Weekend'),
                  ),
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '8 AM',
                    style: TextStyle(color: AppColors.muted, fontSize: 10),
                  ),
                  Text(
                    '12 PM',
                    style: TextStyle(color: AppColors.muted, fontSize: 10),
                  ),
                  Text(
                    '4 PM',
                    style: TextStyle(color: AppColors.muted, fontSize: 10),
                  ),
                  Text(
                    '8 PM',
                    style: TextStyle(color: AppColors.muted, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _panel(
          title: 'Retail catchment',
          trailing: TextButton(
            onPressed: () => setState(() => comparing = !comparing),
            child: Text(comparing ? 'Hide compare' : 'Compare'),
          ),
          child: Column(
            children: [
              _bar('Young professionals', 0.84, '84%'),
              _bar('Residents', .62, '62%'),
              _bar('Office commuters', .48, '48%'),
              if (comparing) ...[
                const Divider(height: 24),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Conversion scenarios',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _bar('Low conversion', .03, '3%'),
                _bar('Medium conversion', .06, '6%'),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        _infoGrid([
          _info('Peak window', '12–2 PM', Icons.schedule_rounded),
          _info('Nearby anchors', 'Third Wave + 6', Icons.storefront_rounded),
          _info('Parking search', 'High demand', Icons.local_parking_outlined),
          _info(
            'Conversion range',
            comparing ? '3% – 6%' : 'Tap Compare',
            Icons.insights_rounded,
          ),
        ]),
      ],
    ),
  );
}

class CompliancePage extends StatefulWidget {
  const CompliancePage({super.key});

  @override
  State<CompliancePage> createState() => _CompliancePageState();
}

class _CompliancePageState extends State<CompliancePage> {
  final checks = <String, bool>{
    'PAN or company identity proof': true,
    'Incorporation certificate': true,
    'Registered office address proof': false,
    'Board resolution for lease': false,
  };
  String entity = 'Private limited company';

  @override
  Widget build(BuildContext context) {
    final completed = checks.values.where((value) => value).length;
    return SectionPage(
      title: 'GST & compliance',
      subtitle: 'Prepare the paperwork for a clean commercial lease.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _statusHeader(
            '$completed OF ${checks.length} DOCUMENTS READY',
            completed == checks.length ? 'Ready to submit' : 'Action needed',
            completed == checks.length
                ? Icons.check_circle
                : Icons.warning_amber_rounded,
          ),
          const SizedBox(height: 14),
          LinearProgressIndicator(
            value: completed / checks.length,
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
            color: AppColors.orange,
            backgroundColor: AppColors.line,
          ),
          const SizedBox(height: 18),
          DropdownButtonFormField<String>(
            initialValue: entity,
            decoration: const InputDecoration(labelText: 'Business entity'),
            items: const [
              DropdownMenuItem(
                value: 'Private limited company',
                child: Text('Private limited company'),
              ),
              DropdownMenuItem(value: 'LLP', child: Text('LLP')),
              DropdownMenuItem(
                value: 'Sole proprietorship',
                child: Text('Sole proprietorship'),
              ),
            ],
            onChanged: (value) => setState(() => entity = value!),
          ),
          const SizedBox(height: 18),
          _panel(
            title: 'Registration checklist',
            child: Column(
              children: checks.keys
                  .map(
                    (document) => CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: checks[document],
                      activeColor: AppColors.orange,
                      title: Text(
                        document,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        checks[document]! ? 'Verified' : 'Upload required',
                        style: TextStyle(
                          color: checks[document]!
                              ? AppColors.orange
                              : AppColors.muted,
                          fontSize: 11,
                        ),
                      ),
                      onChanged: (value) =>
                          setState(() => checks[document] = value ?? false),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 14),
          _infoGrid([
            _info(
              'GST threshold',
              '₹20L turnover',
              Icons.currency_rupee_rounded,
            ),
            _info('Typical timeline', '3–7 days', Icons.timelapse_rounded),
            _info('Lease TDS', 'Check with CA', Icons.receipt_long_outlined),
            _info('Selected entity', entity, Icons.business_center_outlined),
          ]),
          const SizedBox(height: 14),
          primaryButton(
            'Talk to a compliance advisor',
            Icons.support_agent_rounded,
            () => _showAdvisorDialog(context),
          ),
        ],
      ),
    );
  }
}

class PlansPage extends StatefulWidget {
  const PlansPage({super.key});

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  int selectedPlan = 1;
  int listingCount = 3;
  bool featured = true;

  @override
  Widget build(BuildContext context) => SectionPage(
    title: 'Plans & pricing',
    subtitle: 'Choose the reach your commercial inventory needs.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _statusHeader(
          'BROKER WORKSPACE',
          '$listingCount active listings',
          Icons.auto_graph_rounded,
        ),
        const SizedBox(height: 14),
        _planCard(
          0,
          'Broker listing',
          '₹2,999 / property / month',
          'Verified badge, lead inbox and listing analytics',
          Icons.verified_outlined,
        ),
        const SizedBox(height: 12),
        _planCard(
          1,
          'Premium commercial',
          '₹9,999 / month',
          '10 listings, featured status and priority leads',
          Icons.workspace_premium_outlined,
        ),
        const SizedBox(height: 14),
        _panel(
          title: 'Listing controls',
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Active listings',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: listingCount > 1
                            ? () => setState(() => listingCount--)
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text(
                        '$listingCount',
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      IconButton(
                        onPressed: listingCount < 10
                            ? () => setState(() => listingCount++)
                            : null,
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ],
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Featured placement',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: const Text(
                  'Appear above standard broker listings',
                  style: TextStyle(color: AppColors.muted, fontSize: 11),
                ),
                value: featured,
                activeThumbColor: AppColors.orange,
                onChanged: (value) => setState(() => featured = value),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        primaryButton(
          'Continue with selected plan',
          Icons.arrow_forward_rounded,
          () => _showMessage(
            context,
            'Plan reserved. A Magicbricks advisor will contact you.',
          ),
        ),
      ],
    ),
  );

  Widget _planCard(
    int index,
    String title,
    String price,
    String description,
    IconData icon,
  ) => InkWell(
    onTap: () => setState(() => selectedPlan = index),
    borderRadius: BorderRadius.circular(16),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: selectedPlan == index ? const Color(0xFFE9F4D1) : Colors.white,
        border: Border.all(
          color: selectedPlan == index ? AppColors.orange : AppColors.line,
          width: selectedPlan == index ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.orange, size: 25),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 3),
                Text(
                  price,
                  style: const TextStyle(
                    color: AppColors.orange,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(color: AppColors.muted, fontSize: 11),
                ),
              ],
            ),
          ),
          Icon(
            selectedPlan == index
                ? Icons.radio_button_checked
                : Icons.radio_button_off,
            color: selectedPlan == index ? AppColors.orange : AppColors.muted,
          ),
        ],
      ),
    ),
  );
}

Widget _statusHeader(String label, String status, IconData icon) => Container(
  width: double.infinity,
  padding: const EdgeInsets.all(14),
  decoration: BoxDecoration(
    color: const Color(0xFFE9F4D1),
    borderRadius: BorderRadius.circular(14),
  ),
  child: Row(
    children: [
      Icon(icon, color: AppColors.orange),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: .7,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              status,
              style: const TextStyle(
                color: AppColors.ink,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    ],
  ),
);

Widget _bigMetric(String value, String label, Color color) => Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    border: Border.all(color: AppColors.line),
    borderRadius: BorderRadius.circular(15),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        value,
        style: TextStyle(
          color: color,
          fontSize: 25,
          fontWeight: FontWeight.w900,
        ),
      ),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 11)),
    ],
  ),
);

Widget _panel({
  required String title,
  Widget? trailing,
  required Widget child,
}) => Container(
  width: double.infinity,
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    border: Border.all(color: AppColors.line),
    borderRadius: BorderRadius.circular(16),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
            ),
          ),
          ?trailing,
        ],
      ),
      const SizedBox(height: 12),
      child,
    ],
  ),
);

Widget _bar(String label, double value, String amount) => Padding(
  padding: const EdgeInsets.only(bottom: 13),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              color: AppColors.orange,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
      const SizedBox(height: 6),
      LinearProgressIndicator(
        value: value,
        minHeight: 8,
        borderRadius: BorderRadius.circular(8),
        color: AppColors.blue,
        backgroundColor: const Color(0xFFEAF0F2),
      ),
    ],
  ),
);

Widget _infoGrid(List<Widget> items) =>
    Wrap(spacing: 10, runSpacing: 10, children: items);

Widget _info(String label, String value, IconData icon) => SizedBox(
  width: 150,
  child: Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFF7F9F8),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.orange, size: 18),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: AppColors.muted, fontSize: 10),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  ),
);

void _showMessage(BuildContext context, String message) =>
    showAlertMessage(context, 'Request created', message);

void _showAdvisorDialog(BuildContext context) => showDialog<void>(
  context: context,
  builder: (dialogContext) => AlertDialog(
    icon: const Icon(
      Icons.check_circle_rounded,
      color: AppColors.orange,
      size: 42,
    ),
    title: const Text('Request created'),
    content: const Text(
      'Your compliance advisor request has been created. Our team will contact you within one business day.',
      textAlign: TextAlign.center,
    ),
    actions: [
      FilledButton(
        onPressed: () => Navigator.pop(dialogContext),
        child: const Text('Done'),
      ),
    ],
  ),
);

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 9,
        height: 9,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 9)),
    ],
  );
}

class FloorPlanPainter extends CustomPainter {
  final bool showDimensions;
  final String selectedRoom;
  final bool fitted;
  final String widthLabel;
  final String depthLabel;
  FloorPlanPainter({
    required this.showDimensions,
    required this.selectedRoom,
    this.fitted = true,
    this.widthLabel = '48 ft',
    this.depthLabel = '50 ft',
  });

  @override
  void paint(Canvas canvas, Size size) {
    final wall = Paint()
      ..color = AppColors.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    final line = Paint()
      ..color = AppColors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final fill = Paint()..color = const Color(0xFFE9F4D1);
    final plan = Rect.fromLTWH(
      size.width * .08,
      size.height * .12,
      size.width * .84,
      size.height * .72,
    );
    canvas.drawRect(plan, fill);
    canvas.drawRect(plan, wall);
    final vertical = size.width * .58;
    final selectedFill = Paint()
      ..color = AppColors.orange.withValues(alpha: .24);
    final selectedRect = switch (selectedRoom) {
      'Open office' => Rect.fromLTRB(
        plan.left,
        size.height * .5,
        vertical,
        plan.bottom,
      ),
      'Meeting rooms' => Rect.fromLTRB(
        vertical,
        plan.top,
        plan.right,
        size.height * .38,
      ),
      'Reception' => Rect.fromLTRB(
        plan.left,
        plan.top,
        vertical,
        size.height * .5,
      ),
      _ => Rect.fromLTRB(vertical, size.height * .38, plan.right, plan.bottom),
    };
    canvas.drawRect(selectedRect, selectedFill);
    canvas.drawLine(
      Offset(vertical, plan.top),
      Offset(vertical, plan.bottom),
      wall,
    );
    canvas.drawLine(
      Offset(plan.left, size.height * .5),
      Offset(vertical, size.height * .5),
      wall,
    );
    canvas.drawLine(
      Offset(vertical, size.height * .38),
      Offset(plan.right, size.height * .38),
      wall,
    );
    canvas.drawLine(
      Offset(plan.left, size.height * .68),
      Offset(vertical, size.height * .68),
      wall,
    );
    for (var index = 1; index < 5; index++) {
      final x = plan.left + (vertical - plan.left) * index / 5;
      canvas.drawLine(
        Offset(x, size.height * .2),
        Offset(x, size.height * .42),
        line,
      );
    }
    if (fitted) {
      final desk = Paint()..color = AppColors.blue.withValues(alpha: .22);
      for (var index = 0; index < 12; index++) {
        final x = plan.left + 18 + (index % 3) * 34;
        final y = size.height * .54 + (index ~/ 3) * 22;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x, y, 22, 12),
            const Radius.circular(2),
          ),
          desk,
        );
      }
    }
    if (showDimensions) {
      _label(canvas, widthLabel, Offset(size.width * .44, size.height * .04));
      _label(
        canvas,
        depthLabel,
        Offset(plan.right + 8, size.height * .48),
        vertical: true,
      );
      _label(canvas, 'Open office', Offset(size.width * .25, size.height * .6));
      _label(canvas, 'Meeting', Offset(size.width * .68, size.height * .23));
      _label(canvas, 'Reception', Offset(size.width * .2, size.height * .3));
    }
  }

  void _label(
    Canvas canvas,
    String text,
    Offset offset, {
    bool vertical = false,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: AppColors.ink,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    if (vertical) {
      canvas
        ..save()
        ..translate(offset.dx, offset.dy)
        ..rotate(-math.pi / 2);
      painter.paint(
        canvas,
        Offset(-painter.width / 2, -painter.height / 2),
      );
      canvas.restore();
      return;
    }
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant FloorPlanPainter oldDelegate) =>
      oldDelegate.showDimensions != showDimensions ||
      oldDelegate.selectedRoom != selectedRoom ||
      oldDelegate.widthLabel != widthLabel ||
      oldDelegate.depthLabel != depthLabel ||
      oldDelegate.fitted != fitted;
}

class FootfallPainter extends CustomPainter {
  final bool weekend;
  FootfallPainter({required this.weekend});

  @override
  void paint(Canvas canvas, Size size) {
    final values = weekend
        ? [18, 32, 55, 88, 76, 49, 28]
        : [12, 42, 78, 66, 54, 38, 20];
    final bar = Paint()..color = AppColors.orange;
    final width = size.width / values.length;
    for (var index = 0; index < values.length; index++) {
      final height = size.height * values[index] / 100;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            index * width + 8,
            size.height - height,
            width - 16,
            height,
          ),
          const Radius.circular(5),
        ),
        bar,
      );
    }
  }

  @override
  bool shouldRepaint(covariant FootfallPainter oldDelegate) =>
      oldDelegate.weekend != weekend;
}
