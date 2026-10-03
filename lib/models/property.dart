import 'package:flutter/material.dart';

class Property {
  final String title;
  final String type;
  final String location;
  final String price;
  final String area;
  final Color accent;
  final IconData icon;
  final String? imageUrl;

  const Property({
    required this.title,
    required this.type,
    required this.location,
    required this.price,
    required this.area,
    required this.accent,
    required this.icon,
    this.imageUrl,
  });

  Property copyWith({
    String? title,
    String? type,
    String? location,
    String? price,
    String? area,
  }) => Property(
    title: title ?? this.title,
    type: type ?? this.type,
    location: location ?? this.location,
    price: price ?? this.price,
    area: area ?? this.area,
    accent: accent,
    icon: icon,
    imageUrl: imageUrl,
  );
}
