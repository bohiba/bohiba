import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/company_model.dart';
import '/services/company_service.dart';

class AllCompanyController extends GetxController {
  final ScrollController scrollController = ScrollController();

  final RxList<CompanyModel> arrMines = <CompanyModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isFetchingMore = false.obs;
  final RxBool hasMore = true.obs;
  final RxBool hasError = false.obs;

  static const int _perPage = 10;

  // Tracks the next API page to fetch.
  // Starts at 2 on first open because page 1 is already in local SQLite
  // (seeded by api/main at login). Resets to 1 only on pull-to-refresh.
  int _nextPage = 2;

  @override
  void onInit() {
    super.onInit();
    _loadFromLocalDb();
    scrollController.addListener(_onScroll);
  }

  // ── Initial load from local SQLite (page 1, already synced by api/main) ──

  Future<void> _loadFromLocalDb() async {
    isLoading.value = true;
    hasError.value = false;
    final local = await CompanyService.getMinesList();
    isLoading.value = false;
    if (local == null) {
      hasError.value = true;
      return;
    }
    arrMines.assignAll(local);
    // Local DB has page 1. API pagination starts at page 2 on scroll.
    _nextPage = 2;
    // Assume there may be more pages until the first scroll-fetch proves otherwise.
    hasMore.value = true;
  }

  // ── Pull-to-refresh: restart from API page 1 ─────────────────────────────

  Future<void> getMinesList({bool refresh = false}) async {
    if (isLoading.value || isFetchingMore.value) return;
    isLoading.value = true;
    hasError.value = false;

    final result = await CompanyService.getCompaniesPaginated(
      page: 1,
      perPage: _perPage,
    );

    isLoading.value = false;

    if (result == null) {
      hasError.value = true;
      return;
    }

    arrMines.assignAll(result.items);
    hasMore.value = result.hasMore;
    // Page 1 just came from the API; next scroll fetches page 2.
    _nextPage = 2;
  }

  // ── Scroll-triggered: fetch next API page and append ─────────────────────

  void _onScroll() {
    final pos = scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 300 &&
        !isFetchingMore.value &&
        !isLoading.value &&
        hasMore.value) {
      _fetchNextPage();
    }
  }

  Future<void> _fetchNextPage() async {
    isFetchingMore.value = true;

    final result = await CompanyService.getCompaniesPaginated(
      page: _nextPage,
      perPage: _perPage,
    );

    isFetchingMore.value = false;

    if (result == null) {
      // Network error on a scroll-page: keep what we have, let user retry by
      // scrolling again. Don't blow away the list — silent degradation.
      return;
    }

    arrMines.addAll(result.items);
    hasMore.value = result.hasMore;
    _nextPage++;
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }
}
