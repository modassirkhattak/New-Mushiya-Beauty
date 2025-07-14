import 'package:flutter/material.dart';
import 'package:shopify_flutter/shopify_flutter.dart';
import 'package:svg_flutter/svg.dart';
import '../../controller/home_controller.dart';
import '../../controller/product_details_controller.dart';
import '../../utills/app_colors.dart';
import '../../view/product_details/best_seller_details.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/custom_filter.dart';
import '../../widget/custom_text.dart';
import '../../widget/custom_textfield.dart';
import 'product_detail_screen.dart';
import 'package:get/get.dart';
import 'package:shopify_flutter/shopify_flutter.dart';

import 'package:get/get.dart';
import 'package:shopify_flutter/shopify_flutter.dart';

class ShopifyProductController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isBestSellingLoading = false.obs;
  final RxList<Product> products = <Product>[].obs;
  final RxList<Product> filteredProducts = <Product>[].obs;
  final RxList<Product> filteredBestSellingProducts = <Product>[].obs;

  final RxString searchQuery = ''.obs;
  final RxString selectedSortOption = ''.obs;
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 1000.0.obs;
  final RxString stockFilter = ''.obs; // '', 'in', or 'out'

  final List<String> sortOptions = [
    'All',
    'Best Selling',
    'Date: Old to New',
    'Date: New to Old',
    'Price: Low to High',
    'Price: High to Low',
    'Alphabetical: A-Z',
    'Alphabetical: Z-A',
  ];

  Future<void> fetchAllProductsFromCollection(String collectionId) async {
    try {
      isLoading.value = true;
      products.clear();
      filteredProducts.clear();

      final shopifyStore = ShopifyStore.instance;
      final result = await shopifyStore.getAllProductsFromCollectionById(collectionId,sortKeyProductCollection: SortKeyProductCollection.COLLECTION_DEFAULT);

      if (result != null) {
        products.assignAll(result);
        filteredProducts.assignAll(result);
        // filteredBestSellingProducts.assignAll(result);
        updatePriceRangeLimits(result);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAllProductsFromBestSellingCollection(String collectionId) async {
    try {
      isBestSellingLoading.value = true;
      products.clear();
      // filteredProducts.clear();

      final shopifyStore = ShopifyStore.instance;
      final result = await shopifyStore.getAllProductsFromCollectionById(collectionId,sortKeyProductCollection: SortKeyProductCollection.COLLECTION_DEFAULT);

      products.assignAll(result);
      // filteredProducts.assignAll(result);
      filteredBestSellingProducts.assignAll(result);
      updatePriceRangeLimits(result);
    }
    catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isBestSellingLoading.value = false;
    }
  }

  void updatePriceRangeLimits(List<Product> list) {
    final prices = list.map((p) => double.tryParse(p.price.toString() ?? '0') ?? 0).toList();
    if (prices.isNotEmpty) {
      minPrice.value = prices.reduce((a, b) => a < b ? a : b);
      maxPrice.value = prices.reduce((a, b) => a > b ? a : b);
    }
  }

  void filterProducts(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void updateStockFilter(String value) {
    stockFilter.value = value;
    applyFilters();
  }

  void sortProducts(String sortBy) {
    selectedSortOption.value = sortBy;
    applyFilters();
  }

  void applyFilters() {
    List<Product> result = [...products];

    // Search
    if (searchQuery.value.isNotEmpty) {
      result = result.where((product) =>
          product.title.toLowerCase().contains(searchQuery.value.toLowerCase())).toList();
    }

    // Stock Filter
    if (stockFilter.value == 'in') {
      result = result.where((product) => product.availableForSale == true).toList();
    } else if (stockFilter.value == 'out') {
      result = result.where((product) => product.availableForSale == false).toList();
    }

    // Price filter
    result = result.where((product) {
      final price = double.tryParse(product.price.toString() ?? '0') ?? 0;
      return price >= minPrice.value && price <= maxPrice.value;
    }).toList();

    // Sorting
    switch (selectedSortOption.value) {
      case 'Price: Low to High':
        result.sort((a, b) => double.parse(a.price!.toString()).compareTo(double.parse(b.price!.toString())));
        break;
      case 'Price: High to Low':
        result.sort((a, b) => double.parse(b.price!.toString()).compareTo(double.parse(a.price!.toString())));
        break;
      case 'Alphabetical: A-Z':
        result.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Alphabetical: Z-A':
        result.sort((a, b) => b.title.compareTo(a.title));
        break;
      case 'Date: Old to New':
        result.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
        break;
      case 'Date: New to Old':
        result.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
        break;
      case 'Best Selling':
        result.sort((a, b) {
          int aQty = a.productVariants.fold(0, (sum, v) => sum + (v.quantityAvailable ?? 0));
          int bQty = b.productVariants.fold(0, (sum, v) => sum + (v.quantityAvailable ?? 0));
          return bQty.compareTo(aQty);
        });
        break;
    }

    filteredProducts.assignAll(result);
  }

  void clearAllFilters() {
    selectedSortOption.value = '';
    searchQuery.value = '';
    stockFilter.value = '';
    filteredProducts.assignAll(products);
  }
}




class HomeTab extends StatelessWidget {
   HomeTab({Key? key, required this.whichPage}) : super(key: key);

  final String whichPage;

  final ShopifyProductController controller = Get.put(ShopifyProductController());

  // final String collectionId = 'gid://shopify/Collection/214387143';

  @override
  Widget build(BuildContext context) {
    // controller.fetchAllProductsFromCollection(collectionId);

    return Scaffold(
      persistentFooterAlignment: AlignmentDirectional.centerEnd,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: MyAppBarWidget(
          title: whichPage.toUpperCase(),
          titleImage: true,
          actions: true,
          actionsWidget: null,
          leadingButton: true,
        ),
      ),
      body: Column(
        children: [
          Row(
            spacing: 0,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CustomTextField(
                    hintText: "Search",
                    onChanged: (value) => controller.filterProducts(value!),
                    fillColor: whiteColor,
                    height: 40,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(
                        'assets/icons_svg/search_icon.svg',
                        height: 16,
                        width: 16,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Get.to(() => const CartInfo());
                  _showSortByFilter(context);
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons_svg/sorting_icon.svg',
                    height: 16,
                    width: 16,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: whiteColor,));
              }

              if (controller.filteredProducts.isEmpty) {
                return const Center(child: Text("No products found."));
              }

              return GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.7

                ),
                itemCount: controller.filteredProducts.length,
                itemBuilder: (_, index) {
                  final product = controller.filteredProducts[index];
                  return buildProductThumbnail(product);
                },
              );
            }),
          ),
        ],
      ),
    );
  }


  void _showSortByFilter(BuildContext context) async {
    await Get.dialog(SortByFilter(), barrierDismissible: true);
  }


}
Widget buildProductThumbnail(Product product) {
  return GestureDetector(
    onTap: () {
      // final productID= product.id.split();
      print("......${product.id}");
      String gid =
          product
              .id;
      String numericId = gid.split('/').last;
      Get.put(
        ProductDetailsController(),
      ).fetchProduct(int.parse(numericId));
      Get.put(HomeController())
          .selectedVariant
          .value = null;
     // Get.to(ProductDetailScreen(product: product))
      final controller = Get.put(ProductDetailScreen(title: product.title,product: product));
      controller;
      Get.to(ProductDetailScreen(product: product,title: product.title.toString()));
      // Get.to(
      //   BestSellerDetails(
      //     id:
      //     product
      //         .id,
      //     title:
      //     product
      //         .title,
      //   ),
      // );
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 8,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                10,
              ),
              child: Image(

                image: NetworkImage(
                  product
                      .image
                      .toString(),
                ),
                errorBuilder:
                    (context, error, stackTrace) =>
                    Image.asset(
                      'assets/extra_images/girl_1.png',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                loadingBuilder:
                    (context, child, loadingProgress) =>
                loadingProgress == null
                    ? child
                    : Image.asset(
                  'assets/extra_images/girl_1.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // SizedBox(height: 5),
            if (product.availableForSale==false)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: greyColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomText(
                    text:
                    product.availableForSale == true
                        ? "Sold Out"
                        : "Sold Out",
                    leftPadding: 8,
                    topPadding: 4,
                    rightPadding: 8,
                    bottomPadding: 4,
                    fontSize: 12,
                    maxLines: 1,
                    fontFamily: "Roboto",
                    color: whiteColor,
                  ),
                ),
              ),
            if (product.isAvailableForSale==false)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: greyColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomText(
                    text:
                    product.isAvailableForSale==false?"Sold Out":"",
                    leftPadding: 8,
                    topPadding: 4,
                    rightPadding: 8,
                    bottomPadding: 4,
                    fontSize: 12,
                    maxLines: 1,
                    fontFamily: "Roboto",
                    color: whiteColor,
                  ),
                ),
              ),
            if (product.hasComparablePrice==true)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: primaryBlackColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomText(
                    text:
                    product.hasComparablePrice == true
                        ?"Sale"
                        : "",
                    leftPadding: 8,
                    topPadding: 4,
                    rightPadding: 8,
                    bottomPadding: 4,
                    fontSize: 12,
                    maxLines: 1,
                    fontFamily: "Roboto",
                    color: whiteColor,
                  ),
                ),
              ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: whiteColor.withOpacity(
                    0.5,
                  ),
                  borderRadius:
                  BorderRadius.circular(8),
                ),
                child: SvgPicture.asset(
                  'assets/icons_svg/cart_add_icon.svg',
                ),
              ),
            ),
          ],
        ),
        // SizedBox(height: 5),
        CustomText(
          text:
          product
              .title
              .toString(),
          fontSize: 14,
          maxLines: 2,
          fontFamily: "Roboto",
          color: whiteColor,
          fontWeight: FontWeight.w500,
        ),
        // SizedBox(height: 5),
        Row(
          children: [
            CustomText(
              text:
              "\$${product.price.toString()}",
              fontSize: 12,
              maxLines: 1,
              fontFamily: "Roboto",

              color: whiteColor,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(width: 8),
            if (product.hasComparablePrice==true)
              CustomText(
                text:
                "\$${product.compareAtPrice.toString()}",
                fontSize: 12,
                maxLines: 1,
                decoration:  TextDecoration.lineThrough,
                decorationStyle:  TextDecorationStyle.solid,

                fontFamily: "Roboto",

                color: redColor,
                fontWeight: FontWeight.w400,
              ),
          ],
        )
      ],
    ),
  );
}

