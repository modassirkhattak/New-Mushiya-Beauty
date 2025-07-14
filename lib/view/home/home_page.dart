import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:mushiya_beauty/controller/home_controller.dart';
import 'package:mushiya_beauty/utills/api_controller.dart';

// import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/view/faq/faq_page.dart';
import 'package:mushiya_beauty/view/home/all_products_page.dart'
    show AllProductsPage;
import 'package:mushiya_beauty/view/home/collection_all_products_page.dart';
import 'package:mushiya_beauty/view/language/utils/constant.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart' show MyAppBarWidget;
import 'package:mushiya_beauty/widget/custom_button.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';
import 'package:mushiya_beauty/widget/custom_textfield.dart';
import 'package:mushiya_beauty/widget/drawer_widget.dart';
import 'package:svg_flutter/svg_flutter.dart';

import '../../controller/home_specific_collect_controller.dart';
import '../../controller/product_details_controller.dart';
import '../../model/home_banner_item_model.dart';
import '../../new_app/screens/home_tab.dart';
import '../../new_app/screens/product_detail_screen.dart';
import '../../new_app/screens/search_tab.dart';
import '../product_details/best_seller_details.dart';

import 'best_seller_page.dart';

class HomePage2 extends StatelessWidget {
  HomePage2({super.key});

  final controller = Get.put(HomeController());
  // final controller = ;
  @override
  Widget build(BuildContext context) {
    Get.put(ShopifyProductController()).fetchAllProductsFromBestSellingCollection(BEST_SELLER);
    return Scaffold(
      drawer: DrawerWidget(),
      // backgroundColor: primaryBlackColor,
      persistentFooterAlignment: AlignmentDirectional.centerEnd,

      floatingActionButton: CircleAvatar(
        backgroundColor: whiteColor,
        foregroundColor: whiteColor,
        radius: 30,
        child: FloatingActionButton(
          backgroundColor: whiteColor,
          elevation: 0,
          onPressed: () {
            Get.to(() => FaqPage());
          },
          mini: true,
          child: SvgPicture.asset(
            'assets/icons_svg/message_icon2.svg',

            // color: Colors.white,
            // height: 10,
          ),
        ),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: MyAppBarWidget(leadingButton: false),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 24,
            children: [
              StreamBuilder<DocumentSnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection("HomePageData")
                        .doc("StartBanners")
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data?.data() == null) {
                    return const Center(child: Text("No Banners Found"));
                  }

                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  final List bannersList = data['banners'] ?? [];

                  List<BannerItemModel> banners =
                      bannersList.map((e) {
                        return BannerItemModel.fromJson(e);
                      }).toList();

                  return CarouselSlider(
                    options: CarouselOptions(
                      height: 200.0,
                      aspectRatio: 1.0,
                      autoPlay: false,
                      reverse: false,
                      animateToClosest: false,
                      disableCenter: true,
                      viewportFraction: 1.0,
                      autoPlayInterval: const Duration(seconds: 3),
                      initialPage: 0,
                    ),
                    items:
                        banners.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return _buildBanner(
                                showButton: true,
                                context,
                                i.title,

                                title: i.title,
                                i.image,
                                showChat: true,
                                isNetworkImage: true,
                                shoppAllButton: () {
                                  // print(
                                  //   i.id
                                  //       .toString(),
                                  // );
                                  Get.put(
                                    HomeSpecificCollectController(),
                                  ).fetchCollectionProducts(
                                    "gid://shopify/Collection/"+i.collectionID.toString(),
                                    isLoadMore: false,

                                  );Get.put(
                                    ShopifyProductController(),
                                  ).fetchAllProductsFromCollection(
                                    'gid://shopify/Collection/'+i.collectionID.toString(),
                                    // isLoadMore: false,
                                  );
                                  Get.to(
                                    HomeTab(
                                      whichPage: i.title,
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        }).toList(),
                  );
                },
              ),

              GestureDetector(
                onTap: () {
                  Get.to(() => SearchTab());
                },
                child: CustomTextField(
                  hintText: "Search",
                  textEditingController: TextEditingController(),
                  fillColor: whiteColor,
                  height: 40,
                  enabled: false,
                  readOnly: true,
                  textColor: primaryBlackColor,
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
              SizedBox(
                height: 16,
                width: double.infinity,
                child: Obx(
                  () =>
                      controller.isLoading.value
                          ? Center(
                            child: CircularProgressIndicator(color: whiteColor),
                          )
                          : controller.errorMessage.value.isNotEmpty
                          ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  controller.errorMessage.value,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                  ),

                                  textAlign: TextAlign.center,
                                ),
                                // SizedBox(height: 16),
                                // ElevatedButton(
                                //   onPressed:
                                //       () => controller.fetchCollections(),
                                //   child: Text('Retry'),
                                // ),
                              ],
                            ),
                          )
                          : ListView.builder(
                            scrollDirection: Axis.horizontal,

                            shrinkWrap: true,

                            itemCount: controller.collections.length,
                            itemBuilder:
                                (context, index) => Padding(
                                  padding: EdgeInsets.only(right: 12),
                                  child: GestureDetector(
                                    onTap: () {
                                      print(
                                        controller.collections[index].id
                                            .toString(),
                                      );
                                      // Get.put(
                                      //   HomeSpecificCollectController(),
                                      // ).fetchCollectionProducts(
                                      //   "gid://shopify/Collection/"+controller.collections[index].id.toString(),
                                      //   isLoadMore: false,
                                      //
                                      // );
                                      Get.put(
                                        ShopifyProductController(),
                                      ).fetchAllProductsFromCollection(
                                        'gid://shopify/Collection/'+controller.collections[index].id.toString(),
                                        // isLoadMore: false,
                                      );
                                      Get.to(
                                        HomeTab(
                                          whichPage:  controller.collections[index].title,
                                        ),
                                      );
                                      // Get.put(
                                      //   HomeSpecificCollectController(),
                                      // ).fetchCollectionProducts(
                                      //   controller.collections[index].id
                                      //       .toString(),
                                      //   isLoadMore: false,
                                      // );
                                      // Get.to(
                                      //   CollectionAllProductsPage(
                                      //     whichPage:
                                      //         controller
                                      //             .collections[index]
                                      //             .title,
                                      //   ),
                                      // );
                                    },
                                    child: CustomText(
                                      text: controller.collections[index].title,
                                      color: whiteColor,

                                      // style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.w500,
                                      // ),
                                    ),
                                  ),
                                ),
                          ),
                ),
              ),

              Obx(
                () =>
                    controller.isLoading.value
                        ? Center(
                          child: CircularProgressIndicator(color: whiteColor),
                        )
                        : controller.errorMessage.value.isNotEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                controller.errorMessage.value,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => controller.fetchCollections(),
                                child: Text('Retry'),
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.collectionsFilter.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: _buildBanner(
                                showButton: false,
                                context,
                                '',
                                title:
                                    controller.collectionsFilter[index].title
                                        .toUpperCase(),
                                controller.collectionsFilter[index].image ==
                                        null
                                    ? 'assets/extra_images/home_3.png'
                                    : controller
                                        .collectionsFilter[index]
                                        .image!
                                        .src
                                        .toString(),
                                showChat: false,
                                isNetworkImage:
                                    controller.collectionsFilter[index].image ==
                                            null
                                        ? false
                                        : true,
                                height: 101,
                                OnTapped: () {
                                  Get.put(
                                    HomeSpecificCollectController(),
                                  ).fetchCollectionProducts(
                                    "gid://shopify/Collection/"+controller.collections[index].id.toString(),
                                    isLoadMore: false,

                                  );Get.put(
                                    ShopifyProductController(),
                                  ).fetchAllProductsFromCollection(
                                    'gid://shopify/Collection/'+controller.collections[index].id.toString(),
                                    // isLoadMore: false,
                                  );
                                  Get.to(
                                    HomeTab(
                                      whichPage:  controller.collections[index].title,
                                    ),
                                  );
                                  //
                                  // Get.put(
                                  //   HomeSpecificCollectController(),
                                  // ).fetchCollectionProducts(
                                  //   controller.collectionsFilter[index].id
                                  //       .toString(),
                                  //   isLoadMore: false,
                                  // );
                                  // Get.to(
                                  //   CollectionAllProductsPage(
                                  //     whichPage:
                                  //         controller
                                  //             .collectionsFilter[index]
                                  //             .title,
                                  //   ),
                                  // );
                                },
                              ),
                            );
                          },
                        ),
              ),
              // _buildBanner(
              //   context,
              //   '',
              //   title: 'Sale'.toUpperCase(),
              //   'assets/extra_images/home_2.png',
              //   showChat: false,
              //   height: 101,
              //   OnTapped:
              //       () => Get.to(() => AllProductsPage(whichPage: "Sale")),
              // ),
              // _buildBanner(
              //   context,
              //   '',
              //   title: 'Clearance'.toUpperCase(),
              //   'assets/extra_images/home_3.png',
              //   showChat: false,
              //   height: 101,
              //   OnTapped:
              //       () => Get.to(() => AllProductsPage(whichPage: "Clearance")),
              // ),
              // _buildBanner(
              //   context,
              //   '',
              //   title: 'Trending'.toUpperCase(),
              //   'assets/extra_images/home_2.png',
              //   showChat: false,
              //   height: 101,
              //   OnTapped:
              //       () => Get.to(() => AllProductsPage(whichPage: "Trending")),
              // ),
              Row(
                children: [
                  CustomText(
                    text: "Best Sellers",
                    // style: const TextStyle(
                    color: whiteColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Archivo',
                    // ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      String gid = BEST_SELLER;
                      // Get.put(
                      //   HomeSpecificCollectController(),
                      // ).fetchCollectionProducts(gid,
                      //   isLoadMore: false,
                      //
                      // );
                      Get.put(
                        ShopifyProductController(),
                      ).fetchAllProductsFromCollection(gid,
                        // isLoadMore: false,
                      );
                      Get.to(
                        HomeTab(
                          whichPage: "Best Sellers Products",
                        ),
                      );
                      // Get.to(() => BestSellerPage(whichPage: "Best Sellers"));
                    },
                    child: CustomText(
                      text: "View All",
                      // style: const TextStyle(
                      color: whiteColor,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.solid,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Archivo',
                      // ),
                    ),
                  ),
                ],
              ),
    Obx(() {
    if (Get.put(ShopifyProductController()).isBestSellingLoading.value) {
    return const Center(child: CircularProgressIndicator(color: whiteColor,));
    }

    if (Get.put(ShopifyProductController()).filteredBestSellingProducts.isEmpty) {
    return const Center(child: Text("No products found."));
    }

    return GridView.builder(
                          itemCount:
                          Get.put(ShopifyProductController()).filteredBestSellingProducts.length > 4
                                  ? 4
                                  : Get.put(ShopifyProductController()).filteredBestSellingProducts.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          // reverse: false,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 0.7,
                              ),
                          semanticChildCount: 2,
                          itemBuilder:
                              (context, index) {
                            final product =
                                Get.put(ShopifyProductController()).filteredBestSellingProducts[index];
                                return GestureDetector(
                                onTap: () {
                                  // final productID= product.id.split();
                                  // String gid =
                                  //     product
                                  //         .id;
                                  // String numericId = gid.split('/').last;
                                  // Get.put(
                                  //   ProductDetailsController(),
                                  // ).fetchProduct(int.parse(numericId));
                                  // Get.put(HomeController())
                                  //     .selectedVariant
                                  //     .value = null;
                                  // Get.to(ProductDetailScreen(product: product))
                                  final controller = Get.put(ProductDetailScreen(title: product.title,product: product));
                                  controller;
                                  Get.to(ProductDetailScreen(product: product,title: product.title.toString()));
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
                                       if(product.hasComparablePrice ==true)
                                         CustomText(
                                           text:
                                           "\$${product.price.toString()}",
                                           fontSize: 12,

                                           maxLines: 1,
                                           fontFamily: "Roboto",

                                           color: redColor,
                                           decoration:  TextDecoration.lineThrough,
                                           fontWeight: FontWeight.w400,
                                         ),
                                     ],
                                   )
                                  ],
                                ),
                              );
                              },
                        );
                      }
              ),
              CustomText(
                text: "Shop The Look",
                // style: const TextStyle(
                color: whiteColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Archivo',
                // ),
              ),
              StreamBuilder<DocumentSnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection("HomePageData")
                        .doc("HomeBelowBanner")
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data?.data() == null) {
                    return const Center(child: Text("No Banners Found"));
                  }

                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  final List bannersList = data['banners'] ?? [];

                  List<BellowBannerItemModel> banners =
                      bannersList.map((e) {
                        return BellowBannerItemModel.fromJson(e);
                      }).toList();

                  return Column(
                    spacing: 16,
                    children: List.generate(banners.length, (index) {
                      final e = banners[index];
                      final isEven = index % 2 == 0;

                      return SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: isEven
                              ? [ // Image Right
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                ),
                                height: 152,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    e.title==""? Container():Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 30),
                                      child: CustomText(
                                        maxLines: 6,
                                        text: e.title,
                                        color: primaryBlackColor,
                                        fontSize: 12,
                                        textAlign: TextAlign.center,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Archivo',
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 30),
                                      child: CustomText(
                                        maxLines: 6,
                                        text: e.description,
                                        color: primaryBlackColor,
                                        fontSize: 12,
                                        textAlign: TextAlign.center,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Archivo',
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    CustomButton(
                                      elevation: 0,
                                      fontSize: 14,
                                      text: e.button_text.toUpperCase(),
                                      onPressed: () {
                                        Get.put(
                                          HomeSpecificCollectController(),
                                        ).fetchCollectionProducts(
                                          "gid://shopify/Collection/"+e.collectionID.toString(),
                                          isLoadMore: false,

                                        );Get.put(
                                          ShopifyProductController(),
                                        ).fetchAllProductsFromCollection(
                                          'gid://shopify/Collection/'+e.collectionID.toString(),
                                          // isLoadMore: false,
                                        );
                                        Get.to(
                                          HomeTab(
                                            whichPage: e.title,
                                          ),
                                        );
                                        // Get.put(HomeSpecificCollectController())
                                        //     .fetchCollectionProducts(
                                        //     e.collectionID.toString(),
                                        //     isLoadMore: false);
                                        // Get.to(CollectionAllProductsPage(
                                        //     whichPage: e.title));
                                      },
                                      backgroundColor: primaryBlackColor,
                                      textColor: whiteColor,
                                      height: 30,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              child: Image.network(
                                e.image,
                                height: 152,
                                width: 124,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ]
                              : [ // Image Left
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                              child: Image.network(
                                e.image,
                                height: 152,
                                width: 124,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                height: 152,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 30),
                                      child: CustomText(
                                        maxLines: 6,
                                        text: e.description,
                                        color: primaryBlackColor,
                                        fontSize: 12,
                                        textAlign: TextAlign.center,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Archivo',
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    e.title==""? Container():Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 30),
                                      child: CustomText(
                                        maxLines: 6,
                                        text: e.title,
                                        color: primaryBlackColor,
                                        fontSize: 12,
                                        textAlign: TextAlign.center,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Archivo',
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    CustomButton(
                                      elevation: 0,
                                      fontSize: 14,
                                      text: e.button_text.toUpperCase(),
                                      onPressed: () {
                                        Get.put(
                                          HomeSpecificCollectController(),
                                        ).fetchCollectionProducts(
                                          "gid://shopify/Collection/"+e.collectionID.toString(),
                                          isLoadMore: false,

                                        );Get.put(
                                          ShopifyProductController(),
                                        ).fetchAllProductsFromCollection(
                                          'gid://shopify/Collection/'+e.collectionID.toString(),
                                          // isLoadMore: false,
                                        );
                                        Get.to(
                                          HomeTab(
                                            whichPage: e.title,
                                          ),
                                        );
                                        // Get.put(HomeSpecificCollectController())
                                        //     .fetchCollectionProducts(
                                        //     e.collectionID.toString(),
                                        //     isLoadMore: false);
                                        // Get.to(CollectionAllProductsPage(
                                        //     whichPage: e.title==""? e.button_text :e.title));
                                      },
                                      backgroundColor: primaryBlackColor,
                                      textColor: whiteColor,
                                      height: 30,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  );

                },
              ),



            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBanner(
    BuildContext context,
    String buttonText,
    String imagePath, {
    bool showChat = false,
    required bool showButton,
    required bool isNetworkImage,
    double? height,
    String? title,
    VoidCallback? OnTapped,
    VoidCallback? shoppAllButton,
  }) {
    return GestureDetector(
      onTap: OnTapped,
      child: Container(
        height: height ?? 152,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image:
                isNetworkImage == true
                    ? NetworkImage(imagePath)
                    : AssetImage(imagePath), // Replace with actual image
            fit: BoxFit.cover,
            // opacity: 1
            // colorFilter: ColorFilter.linearToSrgbGamma()
            // colorFilter: ColorFilter.linearToSrgbGamma
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CustomText(
                text: title.toString(),
                textAlign: TextAlign.center,
                // style: const TextStyle(
                color: whiteColor,
                fontSize: 24,
                maxLines: 2,
                fontWeight: FontWeight.w600,
                fontFamily: 'Archivo',
                // ),
              ),
            ),
            showButton == false
                ? Container()
                : CustomButton(
                  backgroundColor: whiteColor,
                  textColor: primaryBlackColor,
                  minWidth: 100,
                  text: "Shop All",
                  onPressed:
                      shoppAllButton ??
                      () => Get.to(
                        () => AllProductsPage(whichPage: "All Produccts"),
                      ),
                ),
          ],
        ),
      ),
    );
  }
}
