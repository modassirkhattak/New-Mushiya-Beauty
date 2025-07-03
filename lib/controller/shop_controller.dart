import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/model/teeth_service_model.dart';
import 'package:mushiya_beauty/utills/services.dart';

class ShopController extends GetxController {
  var currentIndex = 0.obs;
  RxString selecctSize = 'Small'.obs;
  RxString selecctColor = 'Blue'.obs;
  RxString selecctFullness = ''.obs;
  RxString searchQuery = ''.obs;
  RxString selectedSortOption = 'All'.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  var errorMessage = ''.obs;
  var products = <TeethServiceProductModel>[].obs;
  var filteredProducts = <TeethServiceProductModel>[].obs;
  RxString? lastCursor = ''.obs;
  RxBool hasNextPage = true.obs;
  final ScrollController scrollController = ScrollController();

  final List<String> sortOptions = [
    'All',
    'Featured',
    'Best Selling',
    'Alphabetically A-Z',
    'Alphabetically Z-A',
    'Price, Low To High',
    'Price, High To Low',
    'Date, Old To New',
    'Date, New To Old',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent * 0.9 &&
          !isLoadingMore.value &&
          hasNextPage.value) {
        fetchProducts(isLoadMore: true);
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> fetchProducts({bool isLoadMore = false}) async {
    if (isLoadMore && !hasNextPage.value) return;

    try {
      if (!isLoadMore) {
        isLoading.value = true;
        products.clear();
        filteredProducts.clear();
        lastCursor!.value = '';
      } else {
        isLoadingMore.value = true;
      }

      final result = await ApiServices.fetchTeethServiceProducts(
        cursor: lastCursor!.value,
      );
      products.addAll(result.products);
      filteredProducts.value = products.toList();
      lastCursor!.value = result.endCursor!;
      hasNextPage.value = result.hasNextPage;

      applyFiltersAndSort();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  void retryFetchProduct() {
    lastCursor!.value = '';
    hasNextPage.value = true;
    fetchProducts();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    applyFiltersAndSort();
  }

  void updateSortOption(String sortOption) {
    selectedSortOption.value = sortOption;
    applyFiltersAndSort();
  }

  void applyFiltersAndSort() {
    var tempProducts = products.toList();

    if (searchQuery.value.isNotEmpty) {
      tempProducts =
          tempProducts.where((product) {
            return product.title.toLowerCase().contains(
              searchQuery.value.toLowerCase(),
            );
          }).toList();
    }

    if (selectedSortOption.value != 'All') {
      switch (selectedSortOption.value) {
        case 'Alphabetically A-Z':
          tempProducts.sort((a, b) => a.title.compareTo(b.title));
          break;
        case 'Alphabetically Z-A':
          tempProducts.sort((a, b) => b.title.compareTo(a.title));
          break;
        case 'Price, Low To High':
          tempProducts.sort(
            (a, b) => double.parse(
              a.variants.first.price,
            ).compareTo(double.parse(b.variants.first.price)),
          );
          break;
        case 'Price, High To Low':
          tempProducts.sort(
            (a, b) => double.parse(
              b.variants.first.price,
            ).compareTo(double.parse(a.variants.first.price)),
          );
          break;
        case 'Date, New To Old':
          tempProducts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          break;
        case 'Date, Old To New':
          tempProducts.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          break;
        case 'Best Selling':
          break;
        case 'Featured':
          break;
      }
    }

    filteredProducts.value = tempProducts;
  }

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}
