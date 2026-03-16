import 'package:flutter/material.dart';

class SubscriptionPlanModel {
  final String id;
  final String name;
  final String priceMonthly;
  final String priceYearly;
  final String audienceDescription;
  final bool isFree;
  final bool isPopular;
  final String ctaText;
  final List<PlanLimit> limits;
  final Map<String, List<PlanFeature>> features;

  SubscriptionPlanModel({
    required this.id,
    required this.name,
    required this.priceMonthly,
    this.priceYearly = '',
    required this.audienceDescription,
    this.isFree = false,
    this.isPopular = false,
    required this.ctaText,
    required this.limits,
    required this.features,
  });
}

class PlanLimit {
  final IconData icon;
  final String text;

  PlanLimit({required this.icon, required this.text});
}

class PlanFeature {
  final String text;
  final bool isIncluded;
  final String? tooltip;

  PlanFeature({required this.text, this.isIncluded = true, this.tooltip});
}
