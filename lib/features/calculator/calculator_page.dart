import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../data/local_admin_store.dart';
import '../../shared/widgets/app_scaffold.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _LeaseRow {
  final int year;
  final double monthly;
  final double annual;
  final double total;
  const _LeaseRow(this.year, this.monthly, this.annual, this.total);
}

class _CalculatorPageState extends State<CalculatorPage> {
  double rent = 280000;
  double years = 5;
  double escalation = 5;
  final double maintenance = 52800;
  int depositMonths = 6;

  double annualRent(int year) =>
      rent * 12 * math.pow(1 + escalation / 100, year - 1).toDouble();

  List<_LeaseRow> get projection => [
    for (var year = 1; year <= years.round(); year++)
      _LeaseRow(
        year,
        annualRent(year) / 12,
        annualRent(year),
        annualRent(year) + maintenance * 12,
      ),
  ];

  String rupees(double value) =>
      '₹${value.round().toString().replaceAllMapped(RegExp(r'(?<=\d)(?=(\d{3})+$)'), (_) => ',')}';
  String lakhs(double value) => '₹${(value / 100000).toStringAsFixed(1)}L';

  @override
  Widget build(BuildContext context) => SectionPage(
    eyebrow: 'LEASE INTELLIGENCE',
    title: 'Know the true cost of every lease.',
    subtitle: 'Project escalation, maintenance and deposits before you sign.',
    action: OutlinedButton.icon(
      onPressed: () => showAlertMessage(
        context,
        'Report ready',
        'Your lease projection report is ready to export.',
      ),
      icon: const Icon(Icons.download_outlined, size: 16),
      label: const Text('Export report'),
    ),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final form = _formPanel();
        final result = _resultPanel();
        return Column(
          children: [
            constraints.maxWidth >= 900
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: form),
                      const SizedBox(width: 16),
                      Expanded(child: result),
                    ],
                  )
                : Column(children: [form, const SizedBox(height: 16), result]),
            const SizedBox(height: 18),
            _projectionTable(),
            const SizedBox(height: 18),
            primaryButton(
              'Get a lease advisory',
              Icons.arrow_forward_rounded,
              () {
                LocalAdminStore.instance.addRequest(
                  type: 'Consultation',
                  subject: 'Lease negotiation advisory from calculator',
                );
                showAlertMessage(
                  context,
                  'Lease advisory requested',
                  'An advisor will reach out within one business day with a negotiation plan.',
                );
              },
            ),
          ],
        );
      },
    ),
  );

  Widget _formPanel() => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: AppColors.line),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Build your lease',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 4),
        const Text(
          'Adjust the terms to see your projection update.',
          style: TextStyle(color: AppColors.muted, fontSize: 11),
        ),
        const SizedBox(height: 24),
        _slider(
          'Monthly base rent',
          rupees(rent),
          rent,
          100000,
          1000000,
          (value) => setState(() => rent = value),
        ),
        _slider(
          'Lease duration',
          '${years.round()} years',
          years,
          1,
          10,
          (value) => setState(() => years = value),
        ),
        _slider(
          'Annual escalation',
          '${escalation.round()}%',
          escalation,
          0,
          12,
          (value) => setState(() => escalation = value),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F9F8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(child: _smallValue('Monthly CAM', rupees(maintenance))),
              Expanded(
                child: _smallValue('Security deposit', '$depositMonths months'),
              ),
              IconButton(
                tooltip: 'Change deposit period',
                onPressed: () =>
                    setState(() => depositMonths = depositMonths == 6 ? 3 : 6),
                icon: const Icon(Icons.edit_outlined, color: AppColors.orange),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _smallValue(String label, String value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 10)),
      const SizedBox(height: 4),
      Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
      ),
    ],
  );

  Widget _slider(
    String label,
    String value,
    double current,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
          ),
        ],
      ),
      Slider(
        value: current,
        min: min,
        max: max,
        divisions: max.round() - min.round(),
        activeColor: AppColors.orange,
        onChanged: onChanged,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            min == 0
                ? '0%'
                : min == 1
                ? '1 year'
                : '₹1L',
            style: const TextStyle(color: AppColors.muted, fontSize: 9),
          ),
          Text(
            max == 12
                ? '12%'
                : max == 10
                ? '10 years'
                : '₹10L',
            style: const TextStyle(color: AppColors.muted, fontSize: 9),
          ),
        ],
      ),
      const SizedBox(height: 12),
    ],
  );

  Widget _resultPanel() {
    final total = projection.fold<double>(0, (sum, row) => sum + row.total);
    final base = projection.fold<double>(0, (sum, row) => sum + row.annual);
    final maxTotal = projection.map((row) => row.total).reduce(math.max);
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TOTAL LEASE COMMITMENT',
            style: TextStyle(
              color: AppColors.orange,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '₹${(total / 100000).toStringAsFixed(1)}L',
            style: const TextStyle(
              color: AppColors.lime,
              fontSize: 34,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            'including estimated maintenance over ${years.round()} years',
            style: const TextStyle(color: Color(0xFF9CB0B7), fontSize: 11),
          ),
          const Divider(color: Color(0xFF2A3E47), height: 32),
          Row(
            children: [
              _darkStat('Avg. monthly cost', lakhs(total / years / 12)),
              _darkStat('Escalation impact', '+${lakhs(total - base)}'),
            ],
          ),
          const SizedBox(height: 22),
          SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (final row in projection)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        lakhs(row.total),
                        style: const TextStyle(
                          color: Color(0xFF9CB0B7),
                          fontSize: 9,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 34,
                        height: 82 * row.total / maxTotal,
                        decoration: BoxDecoration(
                          color: AppColors.lime,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Y${row.year}',
                        style: const TextStyle(
                          color: Color(0xFF9CB0B7),
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1D3B44),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.trending_up_rounded,
                  color: AppColors.lime,
                  size: 18,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Negotiation insight: cap escalation at 4% to save on the total commitment.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _darkStat(String label, String value) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF9CB0B7), fontSize: 10),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 14,
          ),
        ),
      ],
    ),
  );

  Widget _projectionTable() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: AppColors.line),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Escalation projection',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: const WidgetStatePropertyAll(Color(0xFFF7F9F8)),
            columns: const [
              DataColumn(label: Text('Lease year')),
              DataColumn(label: Text('Monthly rent')),
              DataColumn(label: Text('Annual rent')),
              DataColumn(label: Text('Maintenance')),
              DataColumn(label: Text('Total occupancy')),
            ],
            rows: [
              for (final row in projection)
                DataRow(
                  cells: [
                    DataCell(Text('Year ${row.year}')),
                    DataCell(Text(rupees(row.monthly))),
                    DataCell(Text(lakhs(row.annual))),
                    DataCell(Text(lakhs(maintenance * 12))),
                    DataCell(Text(lakhs(row.total))),
                  ],
                ),
            ],
          ),
        ),
      ],
    ),
  );
}
