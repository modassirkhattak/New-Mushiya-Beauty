import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/model/best_selling_product_model.dart';

import 'package:mushiya_beauty/model/custom_collection_model.dart';

import 'package:mushiya_beauty/model/product_model.dart';
import 'package:mushiya_beauty/utills/services.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;
  // RxString selecctSize = 'Small'.obs;
  // RxString selecctColor = 'Blue'.obs;
  // RxString selecctFullness = ''.obs;

  // RxString searchQuery = ''.obs; // Store search query
  // RxString selectedSortOption = 'All'.obs; // Store selected sort option
  var filteredProducts = <ProductModel>[].obs; // Filtered/sorted product list
  RxString selecctSize = 'Small'.obs;
  RxString selecctColor = 'Blue'.obs;
  RxString selecctFullness = ''.obs;
  RxString searchQuery = ''.obs; // Store search query
  RxString selectedSortOption = 'All'.obs; // Default to 'All'
  RxBool isLoading = false.obs;
  var errorMessage = ''.obs;
  var products = <ProductModel>[].obs; // Original product list
  // var filteredProducts = <ProductModel>[].obs; // Filtered/sorted product list

  final List<String> sortOptions = [
    'All', // Default option: no sorting
    'Featured',
    'Best Selling',
    'Alphabetically A-Z',
    'Alphabetically Z-A',
    'Price, Low To High',
    'Price, High To Low',
    'Date, Old To New',
    'Date, New To Old',
  ];

  var quantity = 1.obs; // Observable for quantity
  var selectSize = ''.obs; // Observable for selected variant title
  var selectedVariant = Rx<VariantModel?>(
    null,
  ); // Rx<VariantModel?> for single variant
  void incrementQuantity() {
    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 1) quantity.value--;
  }

  void resetQuantity() {
    quantity.value = 1;
  }

  // void setSelectedVariant(ProductModel product, String? variantTitle) {
  //   if (variantTitle == null || product.variants.isEmpty) {
  //     selectSize.value = '';
  //     selectedVariant.value = [];
  //     return;
  //   }
  //   selectSize.value = variantTitle;
  //   final variant = product.variants.firstWhereOrNull((v) => v.title == variantTitle);
  //   selectedVariant.value = variant as List<ProductVariant>;
  //   resetQuantity();
  // }

  // Update search query and filter products
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    applyFiltersAndSort();
  }

  // Update sort option and sort products

  void updateSortOption(String sortOption) {
    selectedSortOption.value = sortOption;
    applyFiltersAndSort();
  }

  // Apply search and sort filters
  void applyFiltersAndSort() {
    var tempProducts = products.toList();

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      tempProducts =
          tempProducts.where((product) {
            return product.title.toLowerCase().contains(
              searchQuery.value.toLowerCase(),
            );
          }).toList();
    }

    // Apply sorting (skip for 'All')
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
          // Implement logic for best-selling (e.g., based on sales data)
          break;
        case 'Featured':
          // Implement logic for featured (e.g., based on a featured flag)
          break;
      }
    }

    filteredProducts.value = tempProducts;
  }

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  // filter and seearching
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  @override
  void onInit() {
    // applyFiltersAndSort();
    fetchProducts();
    textController.addListener(() {
      updateSearchQuery(textController.text);
    });
    fetchCollections();

    scrollController.addListener(_scrollListener);
    fetchBestProducts(loadMore: false);
    super.onInit();
  }

  // Filter work details page
  final RxInt _selectedOption = RxInt(-1);

  int get selectedOption => _selectedOption.value;

  void setSelectedOption(int index) {
    _selectedOption.value = index;
  }

  void clearSelection() {
    _selectedOption.value = -1;
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await ApiServices().fetchProducts();
      products.value = result.products;
      applyFiltersAndSort();
    } catch (e) {
      errorMessage.value = 'Failed to fetch products: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void retryFetchProduct() {
    fetchProducts();
  }

  // var quantity = 1.obs;

  // void incrementQuantity() {
  //   quantity.value++;
  // }
  //
  // void decrementQuantity() {
  //   if (quantity.value > 1) {
  //     quantity.value--;
  //   }
  // }

  var collections = <CollectionModel>[].obs;
  var collectionsFilter = <CollectionModel>[].obs;
  // var isLoading = false.obs;
  // var errorMessage = ''.obs;
  Future<void> fetchCollections() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      var fetchedCollections = await ApiServices().fetchCollections();
      collections.value = fetchedCollections;
      collectionsFilter.value =
          fetchedCollections
              .where(
                (collection) => [
                  'new',
                  'sale',
                  'clearance',
                  'trending',
                  'motherfanner',
                ].contains(collection.handle),
              )
              .toList();
      // Get.snackbar('Success', 'Collections fetched successfully');
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  void retryFetchCollections() {
    fetchCollections();
    fetchBestProducts();
  }

  // best product
  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  var collectionsBestProduct = <BestSellingProductModel>[].obs;
  var isisBestProductLoadingMoreLoading = false.obs;
  var isBestProductLoadingMore = false.obs;
  var bestProductErrorMessage = ''.obs;
  String? cursor;
  var hasNextPage = false.obs;
  void _scrollListener() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !isBestProductLoadingMore.value &&
        hasNextPage.value) {
      fetchBestProducts(loadMore: true);
    }
  }

  Future<void> fetchBestProducts({bool loadMore = false}) async {
    print("loadMore $loadMore");
    if (loadMore && !hasNextPage.value) return;

    if (loadMore) {
      isBestProductLoadingMore.value = true;
    } else {
      isLoading.value = true;
      cursor = null; // Reset cursor for first page
      collectionsBestProduct.clear();
    }
    bestProductErrorMessage.value = '';

    try {
      var result = await ApiServices().fetchCollectionBestProducts(
        cursor: cursor,
      );
      var newProducts = result['products'] as List<BestSellingProductModel>;
      hasNextPage.value = result['hasNextPage'] as bool;
      cursor = result['endCursor'] as String?;

      if (!loadMore) {
        collectionsBestProduct.value = newProducts; // Reset for first page
      } else {
        collectionsBestProduct.addAll(
          newProducts,
        ); // Append for subsequent pages
      }
      // Get.snackbar('Success', 'Products fetched successfully');
    } catch (e) {
      bestProductErrorMessage.value = e.toString();
      Get.snackbar('Error', bestProductErrorMessage.value);
    } finally {
      if (loadMore) {
        isBestProductLoadingMore.value = false;
      } else {
        isLoading.value = false;
      }
    }
  }


  // shopify products
}
