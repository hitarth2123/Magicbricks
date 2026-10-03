import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../shared/widgets/app_scaffold.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool alerts = true;
  bool advisory = true;

  @override
  Widget build(BuildContext context) => SectionPage(
    eyebrow: 'ACCOUNT & WORKSPACE',
    title: 'Rahul Mehta',
    subtitle: 'Corporate account for commercial property decisions.',
    action: FilledButton.icon(
      onPressed: () => showAlertMessage(
        context,
        'Profile updated',
        'Your workspace preferences are saved for this device.',
      ),
      icon: const Icon(Icons.edit_outlined, size: 16),
      label: const Text('Edit profile'),
    ),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final overview = _card(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFFDCE7C2),
                    child: Text(
                      'RM',
                      style: TextStyle(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rahul Mehta',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Corporate account • Bengaluru',
                          style: TextStyle(
                            color: AppColors.muted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.verified_rounded, color: AppColors.orange),
                ],
              ),
              const Divider(height: 30),
              _profileLine(
                Icons.mail_outline_rounded,
                'Email',
                'rahul.mehta@northstar.co.in',
              ),
              _profileLine(Icons.phone_outlined, 'Phone', '+91 98765 43210'),
              _profileLine(
                Icons.business_center_outlined,
                'Business need',
                'Office expansion • 50–100 seats',
              ),
            ],
          ),
        );
        final settings = _card(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Workspace preferences',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Property alerts',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: const Text(
                  'New spaces matching your saved search',
                  style: TextStyle(color: AppColors.muted, fontSize: 11),
                ),
                value: alerts,
                activeThumbColor: AppColors.orange,
                onChanged: (value) => setState(() => alerts = value),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Lease advisory updates',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: const Text(
                  'Negotiation signals and compliance reminders',
                  style: TextStyle(color: AppColors.muted, fontSize: 11),
                ),
                value: advisory,
                activeThumbColor: AppColors.orange,
                onChanged: (value) => setState(() => advisory = value),
              ),
            ],
          ),
        );
        return Column(
          children: [
            constraints.maxWidth >= 760
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: overview),
                      const SizedBox(width: 16),
                      Expanded(child: settings),
                    ],
                  )
                : Column(
                    children: [overview, const SizedBox(height: 14), settings],
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
                          'ACCOUNT STATUS',
                          style: TextStyle(
                            color: AppColors.orange,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.1,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Corporate benefits are active',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          'Free lease consultation and priority responses from verified brokers.',
                          style: TextStyle(
                            color: AppColors.muted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.orange,
                    size: 28,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );

  Widget _profileLine(IconData icon, String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Row(
      children: [
        Icon(icon, color: AppColors.orange, size: 19),
        const SizedBox(width: 10),
        Text(
          '$label  ',
          style: const TextStyle(color: AppColors.muted, fontSize: 11),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
          ),
        ),
      ],
    ),
  );

  Widget _card(Widget child) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: AppColors.line),
      borderRadius: BorderRadius.circular(16),
    ),
    child: child,
  );
}
