import 'package:flutter/material.dart';

import '../data/property_data.dart';
import '../models/property.dart';

class PricePlan {
  final String name;
  final String price;
  bool enabled;

  PricePlan({required this.name, required this.price, this.enabled = true});
}

class LocalUser {
  final String id;
  String name;
  String email;
  String role;
  bool active;

  LocalUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.active = true,
  });
}

class CustomerRequest {
  final String id;
  final String customer;
  final String type;
  final String subject;
  String status;
  final DateTime createdAt;

  CustomerRequest({
    required this.id,
    required this.customer,
    required this.type,
    required this.subject,
    this.status = 'New',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class AuditEntry {
  final String action;
  final String detail;
  final DateTime createdAt;

  AuditEntry(this.action, this.detail) : createdAt = DateTime.now();
}

class LocalAdminStore extends ChangeNotifier {
  LocalAdminStore._() {
    properties = List<Property>.from(commercialProperties);
    users = [
      LocalUser(
        id: 'USR-001',
        name: 'Rahul Mehta',
        email: 'rahul.mehta@northstar.co.in',
        role: 'Customer',
      ),
      LocalUser(
        id: 'USR-002',
        name: 'Anika Sharma',
        email: 'anika@urbanworks.in',
        role: 'Customer',
      ),
      LocalUser(
        id: 'USR-003',
        name: 'Vikram Rao',
        email: 'vikram@spacecraft.in',
        role: 'Broker',
      ),
    ];
    requests = [
      CustomerRequest(
        id: 'REQ-1042',
        customer: 'Rahul Mehta',
        type: 'Booking',
        subject: 'Site visit for The Hive, Indiranagar',
      ),
      CustomerRequest(
        id: 'REQ-1041',
        customer: 'Anika Sharma',
        type: 'Consultation',
        subject: 'Lease negotiation advisory',
        status: 'In progress',
      ),
    ];
    auditLog = [
      AuditEntry('System ready', 'Local admin workspace initialized'),
      AuditEntry('Request received', 'REQ-1042 booking request from Rahul Mehta'),
    ];
  }

  static final instance = LocalAdminStore._();

  late List<Property> properties;
  late List<PricePlan> plans = [
    PricePlan(name: 'Starter', price: '₹999 / month'),
    PricePlan(name: 'Growth', price: '₹2,499 / month'),
    PricePlan(name: 'Enterprise', price: 'Custom pricing', enabled: false),
  ];
  late List<LocalUser> users;
  late List<CustomerRequest> requests;
  late List<AuditEntry> auditLog;

  void updateProperty(String title, {required String price, required String location}) {
    final index = properties.indexWhere((item) => item.title == title);
    if (index == -1) return;
    properties[index] = properties[index].copyWith(price: price, location: location);
    _record('Property updated', '$title • $price • $location');
  }

  void addProperty(Property property) {
    properties.insert(0, property);
    _record('Property added', property.title);
  }

  void deleteProperty(String title) {
    properties.removeWhere((item) => item.title == title);
    _record('Property deleted', title);
  }

  void togglePlan(PricePlan plan) {
    plan.enabled = !plan.enabled;
    _record(plan.enabled ? 'Plan enabled' : 'Plan disabled', plan.name);
  }

  void updateUser(LocalUser user, {required String name, required String email}) {
    user.name = name;
    user.email = email;
    _record('User updated', '${user.name} • ${user.email}');
  }

  void deleteUser(LocalUser user) {
    users.remove(user);
    _record('User deleted', user.email);
  }

  String resetPassword(LocalUser user, {String? customPassword}) {
    final password = customPassword?.trim().isNotEmpty == true
        ? customPassword!.trim()
        : 'Mb${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}!';
    _record('Password reset', '${user.email} • temporary password generated');
    return password;
  }

  void addRequest({required String type, required String subject, String customer = 'Rahul Mehta'}) {
    final id = 'REQ-${1043 + requests.length}';
    requests.insert(0, CustomerRequest(id: id, customer: customer, type: type, subject: subject));
    _record('Request received', '$id $type request from $customer');
  }

  void updateRequest(CustomerRequest request, String status) {
    request.status = status;
    _record('Request updated', '${request.id} • $status');
  }

  void _record(String action, String detail) {
    auditLog.insert(0, AuditEntry(action, detail));
    notifyListeners();
  }
}