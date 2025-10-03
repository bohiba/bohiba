import '/component/screen_utils.dart';

import '/component/bohiba_appbar/title_appbar.dart';
import 'package:flutter/material.dart';

class SubscriptionPlansPage extends StatelessWidget {
  const SubscriptionPlansPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111A22),
      appBar: TitleAppbar(title: "Subscription Plans"),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.count(
          crossAxisCount: ScreenUtils.width > 900
              ? 4
              : ScreenUtils.width > 600
                  ? 2
                  : 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: const [
            PlanCard(
              title: "Basic",
              price: "229",
              features: ["Up to 5 trucks", "Basic reporting", "Email support"],
            ),
            PlanCard(
              title: "Standard",
              price: "529",
              tag: "Best Choice",
              features: [
                "Up to 15 trucks",
                "Advanced reporting",
                "Priority email support"
              ],
            ),
            PlanCard(
              title: "Premium",
              price: "729",
              features: [
                "Unlimited trucks",
                "Custom reporting",
                "Dedicated support"
              ],
            ),
            PlanCard(
              title: "Custom",
              price: "Contact",
              buttonText: "Contact Sales",
              features: [],
            ),
          ],
        ),
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String? tag;
  final String buttonText;
  final List<String> features;

  const PlanCard({
    super.key,
    required this.title,
    required this.price,
    this.tag,
    this.buttonText = "Choose Plan",
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF192633),
        border: Border.all(color: const Color(0xFF324D67)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (tag != null)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1172D4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tag!,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            price == "Contact" ? price : "$price /month",
            style: const TextStyle(
                color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF233648),
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {},
            child: Text(buttonText),
          ),
          const SizedBox(height: 12),
          ...features.map(
            (f) => Row(
              children: [
                const Icon(Icons.check, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    f,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
