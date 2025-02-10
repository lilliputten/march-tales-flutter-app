import 'package:flutter/material.dart';

class HomePageData {
  final Widget Function() widget;
  final String label;
  final Icon icon;
  const HomePageData({
    required this.widget,
    required this.label,
    required this.icon,
  });
}
