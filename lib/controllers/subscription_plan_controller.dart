import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/model/subscription_plan_model.dart';

class SubscriptionPlanController extends GetxController {
  RxInt selectedPlanIndex = 0.obs;
  late List<SubscriptionPlanModel> plans;

  @override
  void onInit() {
    super.onInit();
    _loadPlans();
  }

  void _loadPlans() {
    plans = [
      SubscriptionPlanModel(
        id: 'free',
        name: 'Single / Micro Truck Owner',
        priceMonthly: '₹0 / month',
        audienceDescription: 'Best for single truck owners starting digital',
        isFree: true,
        ctaText: 'Continue with Free',
        limits: [
          PlanLimit(icon: Icons.local_shipping_outlined, text: '1 Truck allowed'),
          PlanLimit(icon: Icons.map_outlined, text: '5 Trips per month'),
          PlanLimit(icon: Icons.person_outline, text: '1 Driver allowed'),
          PlanLimit(icon: Icons.receipt_long_outlined, text: 'Limited Expenses'),
        ],
        features: {
          'Operations': [
            PlanFeature(text: 'Basic Trip management'),
            PlanFeature(text: 'Simple Expense tracking'),
          ],
          'Reports': [
            PlanFeature(text: 'Watermarked reports', tooltip: 'Reports include Bohiba branding'),
            PlanFeature(text: 'Advanced analytics', isIncluded: false),
          ],
        },
      ),
      SubscriptionPlanModel(
        id: 'growing',
        name: 'Growing Truck Owner',
        priceMonthly: '₹299 / month',
        priceYearly: 'or ₹2999 / year',
        audienceDescription: 'Best for owners managing 5–10 trucks',
        isPopular: true,
        ctaText: 'Upgrade Now',
        limits: [
          PlanLimit(icon: Icons.local_shipping_outlined, text: 'Up to 10 Trucks'),
          PlanLimit(icon: Icons.map_outlined, text: 'Unlimited Trips'),
          PlanLimit(icon: Icons.person_outline, text: 'Up to 15 Drivers'),
          PlanLimit(icon: Icons.receipt_long_outlined, text: 'Unlimited Expenses'),
        ],
        features: {
          'Operations': [
            PlanFeature(text: 'Full Trip management'),
            PlanFeature(text: 'Advanced Expense tracking'),
            PlanFeature(text: 'Driver management'),
          ],
          'Reports': [
            PlanFeature(text: 'White-label reports'),
            PlanFeature(text: 'Financial analytics'),
          ],
          'Marketplace': [
            PlanFeature(text: 'Job posting'),
            PlanFeature(text: 'Driver search'),
          ],
        },
      ),
      SubscriptionPlanModel(
        id: 'fleet',
        name: 'Established Fleet Owner',
        priceMonthly: '₹999 / month',
        priceYearly: 'or ₹9999 / year',
        audienceDescription: 'Built for professional fleet operations',
        ctaText: 'Upgrade Now',
        limits: [
          PlanLimit(icon: Icons.local_shipping_outlined, text: 'Up to 50 Trucks'),
          PlanLimit(icon: Icons.map_outlined, text: 'Unlimited Trips'),
          PlanLimit(icon: Icons.group_outlined, text: 'Unlimited Drivers'),
          PlanLimit(icon: Icons.receipt_long_outlined, text: 'Unlimited Expenses'),
        ],
        features: {
          'Operations': [
            PlanFeature(text: 'Everything in Growing'),
            PlanFeature(text: 'Fleet Maintenance tracking'),
          ],
          'Reports': [
            PlanFeature(text: 'Advanced Custom Reports'),
            PlanFeature(text: 'Export to Excel/PDF'),
          ],
          'Marketplace': [
            PlanFeature(text: 'Priority Job posting'),
            PlanFeature(text: 'Advanced Driver search'),
            PlanFeature(text: 'FASTag recharge'),
          ],
        },
      ),
      SubscriptionPlanModel(
        id: 'large',
        name: 'Large / Custom',
        priceMonthly: '₹4999+ / month',
        audienceDescription: 'For large logistics companies',
        ctaText: 'Talk to Sales',
        limits: [
          PlanLimit(icon: Icons.local_shipping_outlined, text: 'Unlimited Trucks'),
          PlanLimit(icon: Icons.map_outlined, text: 'Unlimited Trips'),
          PlanLimit(icon: Icons.group_outlined, text: 'Unlimited Users & Drivers'),
        ],
        features: {
          'Operations': [
            PlanFeature(text: 'Custom Integrations'),
            PlanFeature(text: 'Dedicated Account Manager'),
          ],
          'Features': [
            PlanFeature(text: 'All Premium Features'),
            PlanFeature(text: 'Custom Development'),
          ],
        },
      ),
    ];
  }

  void onPlanSelected(int index) {
    selectedPlanIndex.value = index;
  }
}
