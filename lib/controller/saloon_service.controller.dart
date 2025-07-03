import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/model/salon_service_firebase_model.dart';
import 'package:mushiya_beauty/model/teeth_service_model.dart';
import 'package:mushiya_beauty/utills/services.dart';
import '../view/saloon/saloon_page.dart';

class SaloonServiceController extends GetxController
    implements SaloonControllerInterface {
  var currentIndex = 0.obs;
  RxString selectedSize = 'Small'.obs;
  RxString selectedColor = 'Blue'.obs;
  RxString selectedFullness = ''.obs;
  @override
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

  @override
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    applyFiltersAndSort();
  }

  @override
  void updateSortOption(String sortOption) {
    selectedSortOption.value = sortOption;
    applyFiltersAndSort();
  }

  void applyFiltersAndSort() {
    var tempProducts = products.toList();

    if (searchQuery.value.isNotEmpty) {
      tempProducts =
          tempProducts
              .where(
                (product) => product.title.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ),
              )
              .toList();
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
          tempProducts.sort((a, b) {
            final aSales = a.variants.fold<double>(
              0,
              (sum, v) => sum + (v.inventoryQuantity),
            );
            final bSales = b.variants.fold<double>(
              0,
              (sum, v) => sum + (v.inventoryQuantity),
            );
            return bSales.compareTo(aSales);
          });
          break;
        case 'Featured':
          tempProducts.sort((a, b) {
            final aHasFeatured = a.title.contains('featured') ? 1 : 0;
            final bHasFeatured = b.title.contains('featured') ? 1 : 0;
            if (aHasFeatured == bHasFeatured) {
              return double.parse(
                b.variants.first.price,
              ).compareTo(double.parse(a.variants.first.price));
            }
            return bHasFeatured.compareTo(aHasFeatured);
          });
          break;
      }
    }

    filteredProducts.value = tempProducts;
  }

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  Stream<List<SalonService>> getSalonServices() {
    return FirebaseFirestore.instance
        .collection('SaloonServices') // 🔁 Your collection name here
        .where('status', isEqualTo: 'Active') // Optional: filter
        .where('type', isEqualTo: 'Saloons') // Optional: filter
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => SalonService.fromMap(doc.data(), doc.id))
                  .toList(),
        );
  }
}
