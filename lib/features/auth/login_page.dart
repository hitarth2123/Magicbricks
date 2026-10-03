import 'package:flutter/material.dart';

import '../../core/app_theme.dart';

class LoginPage extends StatefulWidget {
  final ValueChanged<bool> onLogin;

  const LoginPage({super.key, required this.onLogin});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool adminLogin = false;
  bool obscurePassword = true;
  bool loading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? error;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final email = emailController.text.trim().toLowerCase();
    final password = passwordController.text;
    final validCustomer = email == 'customer@magicbricks.com' && password == 'customer123';
    final validAdmin = email == 'admin@magicbricks.com' && password == 'admin123';
    final valid = adminLogin ? validAdmin : validCustomer;

    setState(() {
      error = valid ? null : 'The email or password does not match this login.';
      loading = valid;
    });
    if (valid) {
      Future<void>.delayed(const Duration(milliseconds: 250), () {
        if (mounted) widget.onLogin(adminLogin);
      });
    }
  }

  void _switchRole(bool admin) {
    setState(() {
      adminLogin = admin;
      error = null;
      emailController.clear();
      passwordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.paper,
    body: LayoutBuilder(
      builder: (context, constraints) => Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 980),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.line),
                boxShadow: const [BoxShadow(color: Color(0x120B272F), blurRadius: 30, offset: Offset(0, 16))],
              ),
              child: constraints.maxWidth >= 720
                  ? Row(children: [_brandPanel(), Expanded(child: _formPanel())])
                  : Column(children: [_brandPanel(compact: true), _formPanel()]),
            ),
          ),
        ),
      ),
    ),
  );

  Widget _brandPanel({bool compact = false}) => Container(
    width: compact ? null : 400,
    padding: const EdgeInsets.all(34),
    decoration: BoxDecoration(
      color: AppColors.ink,
      borderRadius: compact ? const BorderRadius.vertical(top: Radius.circular(22)) : const BorderRadius.horizontal(left: Radius.circular(22)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Container(width: 38, height: 38, decoration: BoxDecoration(color: AppColors.lime, borderRadius: BorderRadius.circular(11)), child: const Center(child: Text('mb', style: TextStyle(color: AppColors.ink, fontSize: 18, fontWeight: FontWeight.w900)))),
          const SizedBox(width: 11),
          const Text('magicbricks', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 58),
        const Text('COMMERCIAL WORKSPACE', style: TextStyle(color: AppColors.lime, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
        const SizedBox(height: 14),
        const Text('Space that works\nas hard as you do.', style: TextStyle(color: Colors.white, fontSize: 32, height: 1.05, fontWeight: FontWeight.w900)),
        const SizedBox(height: 16),
        const Text('Explore verified commercial spaces, model leases, and manage every property decision in one place.', style: TextStyle(color: Color(0xFFB7C4C9), fontSize: 12, height: 1.6)),
        const SizedBox(height: 30),
        Wrap(spacing: 8, runSpacing: 8, children: const [
          _Feature(icon: Icons.business_rounded, text: 'Verified listings'),
          _Feature(icon: Icons.calculate_outlined, text: 'Lease planning'),
          _Feature(icon: Icons.support_agent_outlined, text: 'Expert advisory'),
        ]),
      ],
    ),
  );

  Widget _formPanel() => Padding(
    padding: const EdgeInsets.all(34),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(adminLogin ? 'Admin sign in' : 'Customer sign in', style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: AppColors.ink)),
        const SizedBox(height: 6),
        Text(adminLogin ? 'Manage listings, users, plans and requests.' : 'Continue to your commercial property workspace.', style: const TextStyle(color: AppColors.muted, fontSize: 12)),
        const SizedBox(height: 26),
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(value: false, label: Text('Customer'), icon: Icon(Icons.person_outline_rounded)),
            ButtonSegment(value: true, label: Text('Admin'), icon: Icon(Icons.admin_panel_settings_outlined)),
          ],
          selected: {adminLogin},
          onSelectionChanged: (selection) => _switchRole(selection.first),
        ),
        const SizedBox(height: 24),
        TextField(controller: emailController, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email address', prefixIcon: Icon(Icons.mail_outline_rounded))),
        const SizedBox(height: 14),
        TextField(
          controller: passwordController,
          obscureText: obscurePassword,
          onSubmitted: (_) => _login(),
          decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline_rounded), suffixIcon: IconButton(tooltip: 'Show password', onPressed: () => setState(() => obscurePassword = !obscurePassword), icon: Icon(obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined))),
        ),
        if (error != null) ...[
          const SizedBox(height: 12),
          Text(error!, style: const TextStyle(color: Color(0xFFB42318), fontSize: 11, fontWeight: FontWeight.w700)),
        ],
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, height: 48, child: FilledButton.icon(onPressed: loading ? null : _login, icon: loading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.ink)) : const Icon(Icons.arrow_forward_rounded, size: 17), label: Text(loading ? 'Opening workspace...' : 'Sign in'))),
        const SizedBox(height: 18),
        Text(adminLogin ? 'Use the admin credentials from README.md.' : 'Use the customer credentials from README.md.', style: const TextStyle(color: AppColors.muted, fontSize: 10)),
      ],
    ),
  );
}

class _Feature extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Feature({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(color: const Color(0xFF203944), borderRadius: BorderRadius.circular(9)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: AppColors.lime, size: 15), const SizedBox(width: 6), Text(text, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700))]),
  );
}
