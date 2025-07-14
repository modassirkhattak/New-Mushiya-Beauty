import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../model/collection_sub_product_model.dart';
import '../utills/services.dart';

class HomeSpecificCollectController extends GetxController {
  RxBool isCollProdLoading = false.obs;
  var isCollProderrorMessage = ''.obs;
  var collectionProducts = <CollectionSubProductModel>[].obs;
  RxBool isCollProdLoadingMore = false.obs;
  RxString? lastCursor = ''.obs;
  RxBool hasNextPage = true.obs;
  RxString selectedCollectionId = ''.obs;
  final ScrollController scrollController = ScrollController();
  final TextEditingController textController = TextEditingController();
  RxString searchQuery = ''.obs;
  RxString selectedSortOption = 'All'.obs;

  final List<String> sortOptions = [
    'All',
    'Featured',
    'Best Selling',
    'Alphabetically A-Z',
    'Alphabetically Z-A',
    'Price, Low To High',
    'Price, High To Low',
  ];

  @override
  void onInit() {
    super.onInit();
    textController.addListener(() {
      searchQuery.value = textController.text;
      applyFiltersAndSort();
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent * 0.7 &&
          !isCollProdLoadingMore.value &&
          hasNextPage.value) {
        if (selectedCollectionId.value.isNotEmpty) {
          fetchCollectionProducts(selectedCollectionId.value, isLoadMore: true);
        }
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    textController.dispose();
    super.onClose();
  }

  void applyFiltersAndSort() {
    var tempProducts = collectionProducts.toList();

    // Search filter
    if (searchQuery.value.isNotEmpty) {
      tempProducts = tempProducts.where((product) {
        return product.title.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();
    } // Else, keep all products (no filtering)

    // Sort filter
// Sort filter
    if (selectedSortOption.value != 'All') {
      switch (selectedSortOption.value) {
        case 'Alphabetically A-Z':
          tempProducts.sort((a, b) => a.title.compareTo(b.title));
          break;
        case 'Alphabetically Z-A':
          tempProducts.sort((a, b) => b.title.compareTo(a.title));
          break;
        case 'Price, Low To High':
          tempProducts.sort((a, b) {
            double priceA = double.tryParse(a.variantPrice) ?? 0;
            double priceB = double.tryParse(b.variantPrice) ?? 0;
            return priceA.compareTo(priceB);
          });
          break;
        case 'Price, High To Low':
          tempProducts.sort((a, b) {
            double priceA = double.tryParse(a.variantPrice) ?? 0;
            double priceB = double.tryParse(b.variantPrice) ?? 0;
            return priceB.compareTo(priceA);
          });
          break;
        case 'Date, Old To New':
          tempProducts.sort((a, b) => a.created_at.compareTo(b.created_at));
          break;
        case 'Date, New To Old':
          tempProducts.sort((a, b) => b.created_at.compareTo(a.created_at));
          break;
        // case 'Best Selling':
        //   tempProducts.sort((a, b) {
        //     final aSales = a.variants.fold<double>(
        //         0, (sum, v) => sum + (v.inventoryQuantity ?? 0));
        //     final bSales = b.variants.fold<double>(
        //         0, (sum, v) => sum + (v.inventoryQuantity ?? 0));
        //     return bSales.compareTo(aSales);
        //   });
        //   break;
        case 'Featured':
          tempProducts.sort((a, b) {
            final aHasFeatured = a.tags.contains('featured') ? 1 : 0;
            final bHasFeatured = b.tags.contains('featured') ? 1 : 0;
            if (aHasFeatured == bHasFeatured) {
              double priceA = double.tryParse(a.variantPrice) ?? 0;
              double priceB = double.tryParse(b.variantPrice) ?? 0;
              return priceB.compareTo(priceA);
            }
            return bHasFeatured.compareTo(aHasFeatured);
          });
          break;
      }

    collectionProducts.value = tempProducts;
  }
    }

  Future<void> fetchCollectionProducts(String collectionId, {bool isLoadMore = false}) async {
    if (isLoadMore && !hasNextPage.value) return;

    selectedCollectionId.value = collectionId;
    try {
      if (!isLoadMore) {
        isCollProdLoading.value = true;
        collectionProducts.clear();
        lastCursor!.value = '';
      } else {
        isCollProdLoadingMore.value = true;
      }
      isCollProderrorMessage.value = '';

      var result = await ApiServices().fetchCollectionProducts(
        collectionId: collectionId,
        cursor: lastCursor!.value,
        first: 6,
      );
      collectionProducts.addAll(result['products']);
      hasNextPage.value = result['hasNextPage'];
      lastCursor!.value = result['endCursor'];

      applyFiltersAndSort();
    } catch (e) {
      isCollProderrorMessage.value = e.toString();
      // Get.snackbar('Error', isCollProderrorMessage.value);
    } finally {
      isCollProdLoading.value = false;
      isCollProdLoadingMore.value = false;
    }
  }

  void clearFilters() {
    textController.clear();
    selectedSortOption.value = 'All';
    applyFiltersAndSort();
  }

  void clearSearch() {
    textController.clear();
    searchQuery.value = '';
    applyFiltersAndSort();
  }

  void updateSortOption(String sortOption) {
    selectedSortOption.value = sortOption;
    applyFiltersAndSort();
  }

  void retryFetchCollectionProducts() {
    if (selectedCollectionId.value.isNotEmpty) {
      fetchCollectionProducts(selectedCollectionId.value);
    }
  }
}
/*
class HomeSpecificCollectController extends GetxController {
  // Existing variables
  RxBool isCollProdLoading = false.obs;
  var isCollProderrorMessage = ''.obs;
  var collectionProducts = <CollectionSubProductModel>[].obs;
  RxBool isCollProdLoadingMore = false.obs;
  RxString? lastCursor = ''.obs;
  RxBool hasNextPage = true.obs;
  RxString selectedCollectionId = ''.obs;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent * 0.7 &&
          !isCollProdLoadingMore.value &&
          hasNextPage.value) {
        if (selectedCollectionId.value.isNotEmpty) {
          fetchCollectionProducts(selectedCollectionId.value, isLoadMore: true);
        }
      }
    });
    // Other onInit logic
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> fetchCollectionProducts(String collectionId, {bool isLoadMore = false}) async {
    if (isLoadMore && !hasNextPage.value) return;

    selectedCollectionId.value = collectionId;
    try {
      if (!isLoadMore) {
        isCollProdLoading.value = true;
        collectionProducts.clear();
        lastCursor!.value = '';
      } else {
        isCollProdLoadingMore.value = true;
      }
      isCollProderrorMessage.value = '';

      var result = await ApiServices().fetchCollectionProducts(
        collectionId: collectionId,
        cursor: lastCursor!.value,
        first: 6
      );
      collectionProducts.addAll(result['products']);
      hasNextPage.value = result['hasNextPage'];
      lastCursor!.value = result['endCursor'];
    } catch (e) {
      isCollProderrorMessage.value = e.toString();
      Get.snackbar('Error', isCollProderrorMessage.value);
    } finally {
      isCollProdLoading.value = false;
      isCollProdLoadingMore.value = false;
    }
  }

  void retryFetchCollectionProducts() {
    if (selectedCollectionId.value.isNotEmpty) {
      fetchCollectionProducts(selectedCollectionId.value);
    }
  }

// Other methods unchanged
}*/
