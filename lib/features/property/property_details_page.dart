import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../data/local_admin_store.dart';
import '../../data/property_data.dart';
import '../../models/property.dart';
import '../../shared/widgets/app_scaffold.dart';
import '../../shared/widgets/property_art.dart';

const _conferenceImage =
    'https://images.unsplash.com/photo-1684151498268-c7ff7e7b702b?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&q=85&w=1200';
const _hallImage =
    'https://images.unsplash.com/photo-1786062841848-18177898b3a7?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&q=85&w=1200';

class PropertyDetailsPage extends StatefulWidget {
  final Property property;
  final List<Property> properties;

  const PropertyDetailsPage({
    super.key,
    required this.property,
    this.properties = commercialProperties,
  });

  @override
  State<PropertyDetailsPage> createState() => _PropertyDetailsPageState();
}

class _PropertyDetailsPageState extends State<PropertyDetailsPage> {
  bool saved = false;
  late int selectedProperty;

  Property get property => widget.properties[selectedProperty];

  @override
  void initState() {
    super.initState();
    selectedProperty = widget.properties.indexOf(widget.property);
    if (selectedProperty < 0) selectedProperty = 0;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.paper,
    appBar: AppBar(
      backgroundColor: AppColors.paper,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      actions: [
        IconButton(
          tooltip: 'Share listing',
          onPressed: () => _shareListing(context),
          icon: const Icon(Icons.share_outlined),
        ),
        IconButton(
          tooltip: 'Save listing',
          onPressed: () => setState(() => saved = !saved),
          icon: Icon(
            saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
          ),
        ),
      ],
    ),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1080),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
          children: [
            DropdownButtonFormField<String>(
              initialValue: property.title,
              decoration: const InputDecoration(
                labelText: 'Selected commercial property',
                prefixIcon: Icon(Icons.business_outlined),
              ),
              items: [
                for (final item in widget.properties)
                  DropdownMenuItem(value: item.title, child: Text(item.title)),
              ],
              onChanged: (value) => setState(
                () => selectedProperty = widget.properties.indexWhere(
                  (item) => item.title == value,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _gallery(),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Text(
                    property.type,
                    style: const TextStyle(
                      color: AppColors.orange,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: .5,
                    ),
                  ),
                ),
                const Icon(
                  Icons.verified_rounded,
                  color: AppColors.blue,
                  size: 17,
                ),
                const SizedBox(width: 4),
                const Text(
                  'Verified listing',
                  style: TextStyle(
                    color: AppColors.blue,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              property.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 6),
            Text(
              property.location,
              style: const TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                _metric(property.price, 'Lease rent'),
                _metric(property.area, 'Carpet area'),
                _metric('3+3 yrs', 'Lock-in / term'),
              ],
            ),
            _section(
              'Lease terms at a glance',
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _tag(Icons.schedule_rounded, '5 year term'),
                  _tag(Icons.lock_outline_rounded, '3 year lock-in'),
                  _tag(Icons.trending_up_rounded, '5% annual escalation'),
                  _tag(
                    Icons.account_balance_wallet_outlined,
                    '6 month deposit',
                  ),
                ],
              ),
            ),
            _section(
              'Space essentials',
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _tag(Icons.bolt_rounded, '50 kVA backup'),
                  if (property.type == 'WAREHOUSE')
                    _tag(Icons.local_shipping_outlined, 'Loading dock access'),
                  _tag(Icons.local_parking_outlined, '24 parking'),
                  _tag(Icons.wifi_rounded, 'Fiber ready'),
                ],
              ),
            ),
            _section(
              'Maintenance breakup',
              Column(
                children: [
                  _breakdown('Common area maintenance', '₹18 / sq.ft', true),
                  _breakdown('Power backup', '₹12 / unit', false),
                  _breakdown('Property tax', 'Included', false),
                ],
              ),
            ),
            _section('All-inclusive monthly estimate', _costCard()),
            _section(
              'Nearby ecosystem',
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _nearby(Icons.account_balance_rounded, 'Banks', '4 nearby'),
                  _nearby(Icons.local_cafe_outlined, 'Cafes', '12 nearby'),
                  _nearby(
                    Icons.business_center_outlined,
                    'Offices',
                    '80+ nearby',
                  ),
                ],
              ),
            ),
            primaryButton(
              'Schedule a site visit',
              Icons.calendar_today_outlined,
              () => _scheduleVisit(context),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _gallery() => SizedBox(
    height: 260,
    child: Row(
      children: [
        Expanded(
          flex: 3,
          child: _imageTile(
            property.imageUrl,
            '${property.type}  •  ${property.area}',
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 230,
          child: Column(
            children: [
              Expanded(child: _imageTile(_conferenceImage, 'Conference room')),
              const SizedBox(height: 8),
              Expanded(child: _imageTile(_hallImage, '+18 photos')),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _imageTile(String? url, String label) => ClipRRect(
    borderRadius: BorderRadius.circular(14),
    child: Stack(
      fit: StackFit.expand,
      children: [
        if (url != null)
          Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) =>
                PropertyArt(accent: property.accent, icon: property.icon),
          )
        else
          PropertyArt(accent: property.accent, icon: property.icon),
        Positioned(
          left: 10,
          bottom: 10,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.ink.withValues(alpha: .82),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _costCard() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.ink,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        _costLine('Base rent', property.price),
        _costLine('Maintenance / CAM', '₹43,200'),
        _costLine('Power backup & parking', '₹9,000'),
        const Divider(color: Color(0xFF2A3E47), height: 24),
        _costLine(
          'Estimated monthly occupancy',
          '₹${property.title == 'The Hive, Indiranagar' ? '2.37L' : '2.92L'}',
          bold: true,
        ),
      ],
    ),
  );

  Widget _costLine(String label, String value, {bool bold = false}) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: bold ? AppColors.lime : const Color(0xFF9CB0B7),
              fontSize: 12,
              fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: bold ? AppColors.lime : Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    ),
  );

  void _shareListing(BuildContext context) => showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Share listing'),
      content: Text(
        '${property.title} is ready to share with your team. Listing link copied for your workspace.',
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Done'),
        ),
      ],
    ),
  );

  void _scheduleVisit(BuildContext context) => showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      icon: const Icon(
        Icons.calendar_month_rounded,
        color: AppColors.orange,
        size: 38,
      ),
      title: const Text('Site visit requested'),
      content: Text(
        'We will coordinate a visit for ${property.title}. A property manager will contact you within one business day.',
        textAlign: TextAlign.center,
      ),
      actions: [
        FilledButton(
          onPressed: () {
            LocalAdminStore.instance.addRequest(
              type: 'Booking',
              subject: 'Site visit for ${property.title}',
            );
            Navigator.pop(dialogContext);
          },
          child: const Text('Done'),
        ),
      ],
    ),
  );

  Widget _metric(String value, String label) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.ink,
            fontWeight: FontWeight.w900,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: AppColors.muted, fontSize: 11),
        ),
      ],
    ),
  );
  Widget _section(String title, Widget child) => Padding(
    padding: const EdgeInsets.only(top: 22),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    ),
  );
  Widget _tag(IconData icon, String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: AppColors.line),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.orange),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
  Widget _breakdown(String label, String value, bool bold) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: AppColors.muted, fontSize: 13),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: AppColors.ink,
            fontSize: 13,
            fontWeight: bold ? FontWeight.w900 : FontWeight.w700,
          ),
        ),
      ],
    ),
  );
  Widget _nearby(IconData icon, String title, String sub) => Column(
    children: [
      Icon(icon, color: AppColors.orange, size: 23),
      const SizedBox(height: 7),
      Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          color: AppColors.ink,
          fontSize: 12,
        ),
      ),
      Text(sub, style: const TextStyle(color: AppColors.muted, fontSize: 11)),
    ],
  );
}
