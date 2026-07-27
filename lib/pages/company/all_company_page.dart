import '/component/screen_utils.dart';
import '../../controllers/all_company_controller.dart';
import '../../model/company_model.dart';
import 'package:get/get.dart';
import '/component/bohiba_appbar/market_appbar.dart';
import 'company_card.dart';
import 'package:flutter/material.dart';

class AllCompanyPage extends GetView<AllCompanyController> {
  const AllCompanyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MinesAppBar(title: 'Companies'),
      body: Obx(() {
        // Full-screen loader only on the very first open (local DB fetch).
        if (controller.isLoading.value && controller.arrMines.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value && controller.arrMines.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 40, color: Colors.grey),
                const SizedBox(height: 12),
                const Text('Failed to load companies'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => controller.getMinesList(refresh: true),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          // Pull-to-refresh restarts pagination from API page 1.
          onRefresh: () => controller.getMinesList(refresh: true),
          child: ListView.builder(
            controller: controller.scrollController,
            padding: EdgeInsets.only(
              left: ScreenUtils.height15,
              right: ScreenUtils.height15,
              top: ScreenUtils.height5,
            ),
            // +1 for the bottom loading indicator when fetching more pages.
            itemCount: controller.arrMines.length +
                (controller.isFetchingMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < controller.arrMines.length) {
                final CompanyModel minesModel = controller.arrMines[index];
                return CompanyHorizontalCard(minesInfo: minesModel);
              }
              // Bottom spinner shown while fetching the next API page.
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator()),
              );
            },
          ),
        );
      }),
    );
  }
}
