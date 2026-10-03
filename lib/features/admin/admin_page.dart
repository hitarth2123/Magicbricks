import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../data/local_admin_store.dart';
import '../../models/property.dart';
import '../../shared/widgets/app_scaffold.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: LocalAdminStore.instance,
    builder: (context, _) => SectionPage(
      eyebrow: 'ADMIN CONTROL CENTRE',
      title: 'Operations, in one live view.',
      subtitle: 'Manage listings, plans, users and every customer request from local workspace data.',
      action: FilledButton.icon(
        onPressed: () => _addProperty(context),
        icon: const Icon(Icons.add_business_rounded, size: 17),
        label: const Text('Add property'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _summary(),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) => constraints.maxWidth >= 900
                ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(child: _properties(context)),
                    const SizedBox(width: 16),
                    SizedBox(width: 330, child: _plans(context)),
                  ])
                : Column(children: [_properties(context), const SizedBox(height: 16), _plans(context)]),
          ),
          const SizedBox(height: 16),
          _requests(context),
          const SizedBox(height: 16),
          _users(context),
          const SizedBox(height: 16),
          _auditLog(),
        ],
      ),
    ),
  );

  Widget _summary() {
    final store = LocalAdminStore.instance;
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _metric(Icons.business_rounded, '${store.properties.length}', 'Live properties'),
        _metric(Icons.receipt_long_rounded, '${store.requests.where((item) => item.status == 'New').length}', 'New requests'),
        _metric(Icons.people_alt_outlined, '${store.users.length}', 'Workspace users'),
        _metric(Icons.history_rounded, '${store.auditLog.length}', 'Audit events'),
      ],
    );
  }

  Widget _metric(IconData icon, String value, String label) => SizedBox(
    width: 170,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: AppColors.line), borderRadius: BorderRadius.circular(14)),
      child: Row(children: [
        Icon(icon, color: AppColors.orange, size: 22),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
          Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 10)),
        ]),
      ]),
    ),
  );

  Widget _properties(BuildContext context) {
    final store = LocalAdminStore.instance;
    return _panel(
      title: 'Properties',
      action: Text('${store.properties.length} listings', style: const TextStyle(color: AppColors.muted, fontSize: 11)),
      child: Column(children: [
        for (final property in store.properties.take(6))
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(backgroundColor: property.accent, child: Icon(property.icon, color: AppColors.ink, size: 18)),
            title: Text(property.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
            subtitle: Text('${property.location} • ${property.price}', style: const TextStyle(color: AppColors.muted, fontSize: 10)),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') _editProperty(context, property);
                if (value == 'delete') _confirmDeleteProperty(context, property);
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit listing')),
                PopupMenuItem(value: 'delete', child: Text('Delete listing')),
              ],
            ),
          ),
      ]),
    );
  }

  Widget _plans(BuildContext context) {
    final store = LocalAdminStore.instance;
    return _panel(
      title: 'Price plans',
      action: const Icon(Icons.payments_outlined, color: AppColors.orange),
      child: Column(children: [
        for (final plan in store.plans)
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(plan.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
            subtitle: Text(plan.price, style: const TextStyle(color: AppColors.muted, fontSize: 11)),
            value: plan.enabled,
            activeThumbColor: AppColors.orange,
            onChanged: (_) => store.togglePlan(plan),
          ),
      ]),
    );
  }

  Widget _requests(BuildContext context) {
    final store = LocalAdminStore.instance;
    return _panel(
      title: 'Customer requests',
      action: Text('${store.requests.length} total', style: const TextStyle(color: AppColors.muted, fontSize: 11)),
      child: Column(children: [
        for (final request in store.requests)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(request.type == 'Booking' ? Icons.calendar_month_outlined : Icons.support_agent_outlined, color: AppColors.orange),
            title: Text(request.subject, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
            subtitle: Text('${request.id} • ${request.customer}', style: const TextStyle(color: AppColors.muted, fontSize: 10)),
            trailing: DropdownButton<String>(
              value: request.status,
              underline: const SizedBox.shrink(),
              items: const [
                DropdownMenuItem(value: 'New', child: Text('New')),
                DropdownMenuItem(value: 'In progress', child: Text('In progress')),
                DropdownMenuItem(value: 'Resolved', child: Text('Resolved')),
              ],
              onChanged: (value) { if (value != null) store.updateRequest(request, value); },
            ),
          ),
      ]),
    );
  }

  Widget _users(BuildContext context) {
    final store = LocalAdminStore.instance;
    return _panel(
      title: 'Users',
      action: Text('${store.users.length} accounts', style: const TextStyle(color: AppColors.muted, fontSize: 11)),
      child: Column(children: [
        for (final user in List<LocalUser>.from(store.users))
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(backgroundColor: const Color(0xFFE8F0D4), child: Text(user.name.substring(0, 1), style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w900))),
            title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
            subtitle: Text('${user.email} • ${user.role}', style: const TextStyle(color: AppColors.muted, fontSize: 10)),
            trailing: Wrap(spacing: 2, children: [
              IconButton(tooltip: 'Edit user', icon: const Icon(Icons.edit_outlined, size: 18), onPressed: () => _editUser(context, user)),
              IconButton(tooltip: 'Reset password', icon: const Icon(Icons.key_outlined, size: 18), onPressed: () => _resetPassword(context, user)),
              IconButton(tooltip: 'Delete user', icon: const Icon(Icons.delete_outline_rounded, size: 18), onPressed: () => _confirmDeleteUser(context, user)),
            ]),
          ),
      ]),
    );
  }

  Widget _auditLog() {
    final store = LocalAdminStore.instance;
    return _panel(
      title: 'Admin audit log',
      action: const Text('Newest first', style: TextStyle(color: AppColors.muted, fontSize: 11)),
      child: Column(children: [
        for (final entry in store.auditLog.take(8))
          ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            leading: const Icon(Icons.fiber_manual_record, color: AppColors.orange, size: 10),
            title: Text(entry.action, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11)),
            subtitle: Text(entry.detail, style: const TextStyle(color: AppColors.muted, fontSize: 10)),
            trailing: Text(_time(entry.createdAt), style: const TextStyle(color: AppColors.muted, fontSize: 9)),
          ),
      ]),
    );
  }

  Widget _panel({required String title, required Widget action, required Widget child}) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(color: Colors.white, border: Border.all(color: AppColors.line), borderRadius: BorderRadius.circular(16)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Expanded(child: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900))), action]),
      const Divider(height: 26),
      child,
    ]),
  );

  String _time(DateTime time) => '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  Future<void> _editProperty(BuildContext context, Property property) async {
    final price = TextEditingController(text: property.price);
    final location = TextEditingController(text: property.location);
    final save = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
      title: Text('Edit ${property.title}'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [TextField(controller: price, decoration: const InputDecoration(labelText: 'Monthly price')), TextField(controller: location, decoration: const InputDecoration(labelText: 'Location'))]),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save'))],
    ));
    price.dispose();
    location.dispose();
    if (save == true) LocalAdminStore.instance.updateProperty(property.title, price: price.text, location: location.text);
  }

  Future<void> _addProperty(BuildContext context) async {
    final title = TextEditingController();
    final price = TextEditingController(text: '₹1.00L / mo');
    final location = TextEditingController(text: 'Bengaluru');
    final save = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
      title: const Text('Add property'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [TextField(controller: title, decoration: const InputDecoration(labelText: 'Property name')), TextField(controller: price, decoration: const InputDecoration(labelText: 'Monthly price')), TextField(controller: location, decoration: const InputDecoration(labelText: 'Location'))]),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Add'))],
    ));
    if (save == true && title.text.trim().isNotEmpty) {
      LocalAdminStore.instance.addProperty(Property(title: title.text.trim(), type: 'OFFICE SPACE', location: location.text.trim(), price: price.text.trim(), area: 'New listing', accent: const Color(0xFFC7E1D5), icon: Icons.business_center_rounded));
    }
    title.dispose(); price.dispose(); location.dispose();
  }

  Future<void> _editUser(BuildContext context, LocalUser user) async {
    final name = TextEditingController(text: user.name);
    final email = TextEditingController(text: user.email);
    final save = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
      title: const Text('Edit user'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [TextField(controller: name, decoration: const InputDecoration(labelText: 'Name')), TextField(controller: email, decoration: const InputDecoration(labelText: 'Email'))]),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save'))],
    ));
    if (save == true) LocalAdminStore.instance.updateUser(user, name: name.text.trim(), email: email.text.trim());
    name.dispose(); email.dispose();
  }

  Future<void> _resetPassword(BuildContext context, LocalUser user) async {
    final password = TextEditingController();
    final reset = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
      title: Text('Reset ${user.name} password'),
      content: TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Custom password (optional)', hintText: 'Leave empty to generate one')),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Reset'))],
    ));
    if (reset == true && context.mounted) {
      final generated = LocalAdminStore.instance.resetPassword(user, customPassword: password.text);
      showAlertMessage(context, 'Password reset', 'Temporary password: $generated');
    }
    password.dispose();
  }

  void _confirmDeleteProperty(BuildContext context, Property property) => _confirm(context, 'Delete property?', 'Remove ${property.title} from the marketplace?', () => LocalAdminStore.instance.deleteProperty(property.title));

  void _confirmDeleteUser(BuildContext context, LocalUser user) => _confirm(context, 'Delete user?', 'Remove ${user.email} from this workspace?', () => LocalAdminStore.instance.deleteUser(user));

  void _confirm(BuildContext context, String title, String message, VoidCallback onConfirm) => showDialog<void>(context: context, builder: (context) => AlertDialog(
    title: Text(title), content: Text(message), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(onPressed: () { onConfirm(); Navigator.pop(context); }, child: const Text('Confirm'))],
  ));
}
