import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../data/local_admin_store.dart';
import '../../models/property.dart';
import '../../shared/widgets/app_scaffold.dart';
import '../../shared/widgets/property_art.dart';
import '../property/property_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String propertyType = 'All';
  String budget = '₹1L – ₹5L';
  String area = 'Any area';
  String locationQuery = '';
  final locationController = TextEditingController(text: 'Gurugram, Haryana');

  @override
  void dispose() {
    locationController.dispose();
    super.dispose();
  }

  List<Property> get visibleProperties {
    final type = switch (propertyType) {
      'Office' => 'OFFICE SPACE',
      'Retail' => 'RETAIL OUTLET',
      'Warehouse' => 'WAREHOUSE',
      'Industrial land' => 'INDUSTRIAL LAND',
      _ => null,
    };
    return LocalAdminStore.instance.properties
        .where(
          (property) =>
              (type == null || property.type == type) &&
              _matchesLocation(property) &&
              _matchesArea(property) &&
              _matchesBudget(property),
        )
        .toList();
  }

  bool _matchesLocation(Property property) {
    if (locationQuery.isEmpty) return true;
    final query = locationQuery.toLowerCase();
    return property.title.toLowerCase().contains(query) ||
        property.location.toLowerCase().contains(query);
  }

  void _runSearch() {
    setState(() => locationQuery = locationController.text.trim());
    showAlertMessage(
      context,
      'Search updated',
      locationQuery.isEmpty
          ? 'Showing all commercial spaces.'
          : 'Showing spaces matching "$locationQuery".',
    );
  }

  bool _matchesArea(Property property) {
    final squareFeet = int.parse(
      property.area.replaceAll(RegExp(r'[^0-9]'), ''),
    );
    return switch (area) {
      'Under 2,000 sq.ft' => squareFeet < 2000,
      '2,000 – 5,000 sq.ft' => squareFeet >= 2000 && squareFeet <= 5000,
      'Above 5,000 sq.ft' => squareFeet > 5000,
      _ => true,
    };
  }

  bool _matchesBudget(Property property) {
    final rent = switch (property.title) {
      'The Hive, Indiranagar' => 1.85,
      'Avenue 7 Retail' => 2.4,
      _ => 3.2,
    };
    return switch (budget) {
      'Any budget' => true,
      '₹1L – ₹2L' => rent >= 1 && rent < 2,
      '₹2L – ₹3L' => rent >= 2 && rent <= 3,
      '₹3L – ₹5L' => rent > 3 && rent <= 5,
      '₹1L – ₹5L' => rent >= 1 && rent <= 5,
      _ => rent > 5,
    };
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: LocalAdminStore.instance,
    builder: (context, _) => CustomScrollView(
    slivers: [
      SliverToBoxAdapter(child: _pageHeader()),
      SliverToBoxAdapter(child: _searchBar()),
      SliverToBoxAdapter(child: _chips()),
      SliverToBoxAdapter(child: _resultsHeader()),
      SliverLayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.crossAxisExtent >= 1000
              ? 3
              : constraints.crossAxisExtent >= 620
              ? 2
              : 1;
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _propertyCard(visibleProperties[index]),
                childCount: visibleProperties.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: columns == 1 ? 1.25 : 1.05,
              ),
            ),
          );
        },
      ),
      if (visibleProperties.isEmpty)
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(22, 4, 22, 24),
            child: Text(
              'No spaces match these filters yet. Try a wider budget or area.',
              style: TextStyle(color: AppColors.muted, height: 1.5),
            ),
          ),
        ),
      const SliverToBoxAdapter(child: SizedBox(height: 24)),
    ],
    ),
  );

  Widget _pageHeader() => Padding(
    padding: const EdgeInsets.fromLTRB(22, 26, 22, 18),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'COMMERCIAL MARKETPLACE',
                style: TextStyle(
                  color: AppColors.orange,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.4,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Find a space built for business.',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Verified listings with the operational details that matter.',
                style: TextStyle(color: AppColors.muted, fontSize: 12),
              ),
            ],
          ),
        ),
        OutlinedButton.icon(
          onPressed: () => showAlertMessage(
            context,
            'Search saved',
            'We will notify you when a matching commercial space is listed.',
          ),
          icon: const Icon(Icons.bookmark_border_rounded, size: 16),
          label: const Text('Save this search'),
        ),
      ],
    ),
  );

  Widget _searchBar() => Container(
    margin: const EdgeInsets.symmetric(horizontal: 22),
    padding: const EdgeInsets.all(7),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.line),
    ),
    child: Row(
      children: [
        const Icon(Icons.location_on_outlined, color: AppColors.orange),
        Expanded(
          child: TextField(
            controller: locationController,
            onSubmitted: (_) => _runSearch(),
            decoration: const InputDecoration(
              labelText: 'Location',
              hintText: 'City, locality or landmark',
              border: InputBorder.none,
            ),
          ),
        ),
        const VerticalDivider(width: 20),
        Expanded(
          child: Text(
            'Property type\n${propertyType == 'All' ? 'All commercial' : propertyType}',
            style: const TextStyle(fontSize: 12, height: 1.35),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: _chooseBudget,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Monthly budget\n$budget',
                style: const TextStyle(fontSize: 12, height: 1.35),
              ),
            ),
          ),
        ),
        FilledButton.icon(
          onPressed: _runSearch,
          icon: const Icon(Icons.search_rounded, size: 16),
          label: const Text('Search'),
        ),
      ],
    ),
  );

  Widget _chips() => Padding(
    padding: const EdgeInsets.fromLTRB(22, 14, 22, 8),
    child: Wrap(
      spacing: 8,
      children: ['All', 'Office', 'Retail', 'Warehouse', 'Industrial land']
          .map(
            (type) => ChoiceChip(
              label: Text(type),
              selected: propertyType == type,
              onSelected: (_) => setState(() => propertyType = type),
              selectedColor: AppColors.ink,
              labelStyle: TextStyle(
                color: propertyType == type ? Colors.white : AppColors.ink,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
          .toList(),
    ),
  );

  Future<void> _chooseBudget() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(title: Text('Monthly budget')),
            for (final option in [
              'Any budget',
              '₹1L – ₹2L',
              '₹2L – ₹3L',
              '₹3L – ₹5L',
              'Above ₹5L',
            ])
              ListTile(
                title: Text(option),
                onTap: () => Navigator.pop(context, option),
              ),
          ],
        ),
      ),
    );
    if (!mounted || selected == null) return;
    setState(() => budget = selected);
  }

  Widget _resultsHeader() => Padding(
    padding: const EdgeInsets.fromLTRB(22, 14, 22, 12),
    child: Row(
      children: [
        Expanded(
          child: Text(
            '${visibleProperties.length} spaces match your business needs',
            style: const TextStyle(color: AppColors.muted, fontSize: 12),
          ),
        ),
        DropdownButton<String>(
          value: 'Recommended',
          underline: const SizedBox.shrink(),
          items: const [
            DropdownMenuItem(value: 'Recommended', child: Text('Recommended')),
            DropdownMenuItem(value: 'Price', child: Text('Price: low to high')),
          ],
          onChanged: (_) {},
        ),
      ],
    ),
  );

  Widget _propertyCard(Property property) => InkWell(
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PropertyDetailsPage(property: property),
      ),
    ),
    borderRadius: BorderRadius.circular(16),
    child: Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              PropertyArt(
                accent: property.accent,
                icon: property.icon,
                width: double.infinity,
                height: 132,
                imageUrl: property.imageUrl,
              ),
              Positioned(top: 10, left: 10, child: _badge('Verified')),
              const Positioned(
                bottom: 10,
                right: 10,
                child: Text(
                  '12 photos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.type,
                    style: const TextStyle(
                      color: AppColors.orange,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    property.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    property.location,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _propertyStats(property).map(_specChip).toList(),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        property.price,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'View space →',
                        style: TextStyle(
                          color: AppColors.orange,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );

  List<String> _propertyStats(Property property) => switch (property.type) {
    'OFFICE SPACE' => ['2,400 sq.ft', '72 seats', '50 KVA backup'],
    'RETAIL OUTLET' => ['1,180 sq.ft', 'High footfall', 'Power backup'],
    _ => ['8,500 sq.ft', '4 loading docks', '50 KVA backup'],
  };

  Widget _specChip(String value) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
    decoration: BoxDecoration(
      color: const Color(0xFFF1F5F3),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      value,
      style: const TextStyle(
        color: AppColors.muted,
        fontSize: 9,
        fontWeight: FontWeight.w700,
      ),
    ),
  );

  Widget _badge(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
      color: const Color(0xFFE7F6EE),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: AppColors.orange,
        fontSize: 9,
        fontWeight: FontWeight.w900,
      ),
    ),
  );
}
