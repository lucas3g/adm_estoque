import 'package:flutter/material.dart';

class CardMenuButtonEntity {
  final String label;
  final Widget icon;
  final String route;
  final Map<String, dynamic>? args;

  CardMenuButtonEntity({
    required this.label,
    required this.icon,
    required this.route,
    this.args,
  });
}
