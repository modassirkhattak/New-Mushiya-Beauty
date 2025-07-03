import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:mushiya_beauty/controller/home_controller.dart';

// import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/view/faq/faq_page.dart';
import 'package:mushiya_beauty/view/home/all_products_page.dart'
    show AllProductsPage;
import 'package:mushiya_beauty/view/home/collection_all_products_page.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart' show MyAppBarWidget;
import 'package:mushiya_beauty/widget/custom_button.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';
import 'package:mushiya_beauty/widget/custom_textfield.dart';
import 'package:mushiya_beauty/widget/drawer_widget.dart';
import 'package:svg_flutter/svg_flutter.dart';

import '../../controller/home_specific_collect_controller.dart';
import '../../controller/product_details_controller.dart';
import '../../model/home_banner_item_model.dart';
import '../../new_app/screens/search_tab.dart';
import '../product_details/best_seller_details.dart';

import 'best_seller_page.dart';

class HomePage2 extends StatelessWidget {
  HomePage2({super.key});

  final controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
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
                  stream: FirebaseFirestore.instance.collection("HomePageData").doc("StartBanners").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Colors.orange));
                    }
                    if (!snapshot.hasData || snapshot.data?.data() == null) {
                      return const Center(child: Text("No Banners Found"));
                    }

                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    final List bannersList = data['banners'] ?? [];

                    List<BannerItemModel> banners = bannersList.map((e) {
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
                                // OnTapped:
                                //     // () => Get.to(() => CartTab()),
                                //     () => Get.to(
                                //       () => AllProductsPage(
                                //         whichPage: "All Produccts",
                                //       ),
                                //     ),
                              );
                            },
                          );
                        }).toList(),
                  );
                }
              ),

              GestureDetector(
                onTap: (){
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
                                      Get.put(
                                        HomeSpecificCollectController(),
                                      ).fetchCollectionProducts(
                                        controller.collections[index].id
                                            .toString(),
                                        isLoadMore: false,
                                      );
                                      Get.to(
                                        CollectionAllProductsPage(
                                          whichPage:
                                              controller
                                                  .collections[index]
                                                  .title,
                                        ),
                                      );
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
                                    controller.collectionsFilter[index].id
                                        .toString(),
                                    isLoadMore: false,
                                  );
                                  Get.to(
                                    CollectionAllProductsPage(
                                      whichPage:
                                          controller
                                              .collectionsFilter[index]
                                              .title,
                                    ),
                                  );
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
                      Get.to(() => BestSellerPage(whichPage: "Best Sellers"));
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
              Obx(
                () =>
                    controller.isBestProductLoadingMore.value &&
                            controller.collectionsBestProduct.isEmpty
                        ? Center(
                          child: CircularProgressIndicator(color: whiteColor),
                        )
                        : controller.bestProductErrorMessage.value.isNotEmpty &&
                            controller.collectionsBestProduct.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                controller.bestProductErrorMessage.value,
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
                        : GridView.builder(
                          itemCount:
                              controller.collectionsBestProduct.length > 4
                                  ? 4
                                  : controller.collectionsBestProduct.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 0.7,
                              ),
                          semanticChildCount: 2,
                          itemBuilder:
                              (context, index) => GestureDetector(
                                onTap: () {
                                  // final productID= product.id.split();
                                  String gid =
                                      controller
                                          .collectionsBestProduct[index]
                                          .id;
                                  String numericId = gid.split('/').last;
                                  Get.put(
                                    ProductDetailsController(),
                                  ).fetchProduct(int.parse(numericId));
                                  Get.put(HomeController())
                                      .selectedVariant
                                      .value = null;
                                  Get.to(
                                    BestSellerDetails(
                                      id:
                                          controller
                                              .collectionsBestProduct[index].id,
                                      title:
                                          controller
                                              .collectionsBestProduct[index]
                                              .title,
                                    ),
                                  );
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
                                              controller
                                                  .collectionsBestProduct[index]
                                                  .imageSrc
                                                  .toString(),
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
                                          controller
                                              .collectionsBestProduct[index]
                                              .title
                                              .toString(),
                                      fontSize: 14,
                                      maxLines: 2,
                                      fontFamily: "Roboto",
                                      color: whiteColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    CustomText(
                                      text:
                                          "\$${controller.collectionsBestProduct[index].variantPrice.toString()}",
                                      fontSize: 12,
                                      maxLines: 1,
                                      fontFamily: "Roboto",

                                      color: whiteColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ],
                                ),
                              ),
                        ),
              ),

              StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance.collection("HomePageData").doc("HomeBelowBanner").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Colors.orange));
                    }
                    if (!snapshot.hasData || snapshot.data?.data() == null) {
                      return const Center(child: Text("No Banners Found"));
                    }

                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    // final List bannersList = data['banners'] ?? [];

                    // List<BannerItemModel> banners = bannersList.map((e) {
                    //   return BannerItemModel.fromJson(e);
                    // }).toList();

                    return SizedBox(
                    // height: 1,
                    width: double.infinity,

                    // color: whiteColor.withOpacity(0.2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: whiteColor,
                              // color: whiteColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),

                            width: double.infinity,
                            height: 152,
                            // padding: EdgeInsets.all(30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 30,
                                    left: 30,
                                    right: 30,
                                    bottom: 10,
                                  ),
                                  child: CustomText(
                                    maxLines: 6,
                                    text: data['title'],
                                        // "fashion should be stylish, affordable and accessible to everyone.",
                                    // style: const TextStyle(
                                    color: primaryBlackColor,
                                    fontSize: 12,
                                    textAlign: TextAlign.center,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Archivo',
                                    // ),
                                  ),
                                ),
                                CustomButton(
                                  elevation: 0,
                                  text: "Shop All".toUpperCase(),
                                  onPressed: () {
                                    Get.to(
                                      () => AllProductsPage(
                                        whichPage: "All Produccts",
                                      ),
                                    );
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
                          // : BoxDecoration(
                          // color: whiteColor,
                          // color: whiteColor,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            // ),
                          ),
                          child: Image(
                            image: NetworkImage(
                              data['image'],
                              // 'assets/extra_images/home_page_extra_1.png',
                              // 'assets/extra_images/home_page_extra.png',
                            ),
                            height: 152,
                            width: 124,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              ),
              StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance.collection("HomePageData").doc("HomeBelowBanner").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Colors.orange));
                    }
                    if (!snapshot.hasData || snapshot.data?.data() == null) {
                      return const Center(child: Text("No Banners Found"));
                    }

                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    // final List bannersList = data['banners'] ?? [];

                    // List<BannerItemModel> banners = bannersList.map((e) {
                    //   return BannerItemModel.fromJson(e);
                    // }).toList();

                    return SizedBox(
                    // height: 1,
                    width: double.infinity,

                    // color: whiteColor.withOpacity(0.2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          // : BoxDecoration(
                          // color: whiteColor,
                          // color: whiteColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            // ),
                          ),
                          child: Image(
                            image: NetworkImage(
                              data["banner_2_image"],
                              // 'assets/extra_images/home_page_extra.png',
                            ),
                            height: 152,
                            width: 124,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: whiteColor,
                              // color: whiteColor,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),

                            width: double.infinity,
                            height: 152,
                            // padding: EdgeInsets.all(30),
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 10,
                                left: 30,
                                right: 30,
                                bottom: 10,
                              ),
                              child: Column(
                                spacing: 5,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    maxLines: 6,
                                    text:data["banner_2_title"],
                                    // style: const TextStyle(
                                    color: primaryBlackColor,
                                    fontSize: 14,
                                    textAlign: TextAlign.center,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Archivo',
                                    // ),
                                  ),
                                  CustomText(
                                    maxLines: 6,
                                    text: data["banner_2_description"],
                                        // "Our latest lookbook has dropped and is ready to shop. Elevate your style now!.",
                                    // style: const TextStyle(
                                    color: primaryBlackColor,
                                    fontSize: 12,
                                    textAlign: TextAlign.center,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Archivo',
                                    // ),
                                  ),
                                  CustomButton(
                                    elevation: 0,
                                    text: "Shop All".toUpperCase(),
                                    onPressed: () {
                                      Get.to(
                                        () => AllProductsPage(
                                          whichPage: "All Produccts",
                                        ),
                                      );
                                    },
                                    backgroundColor: primaryBlackColor,
                                    textColor: whiteColor,
                                    height: 30,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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

              // GridView.builder(
              //   itemCount:
              //       controller.homeListModel.length > 4
              //           ? 4
              //           : controller.homeListModel.length,
              //   physics: const NeverScrollableScrollPhysics(),
              //   shrinkWrap: true,
              //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //     crossAxisCount: 2,
              //     mainAxisSpacing: 16,
              //     crossAxisSpacing: 16,
              //     childAspectRatio: 0.7,
              //   ),
              //   semanticChildCount: 2,
              //   itemBuilder:
              //       (context, index) => GestureDetector(
              //         // onTap:
              //         //     () => Get.to(
              //         //       ProducctDetailsPage(
              //         //         title: controller.homeListModel[index].name,
              //         //         homeModel: controller.homeListModel[index],
              //         //       ),
              //         //     ),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           spacing: 8,
              //           children: [
              //             Stack(
              //               children: [
              //                 Image(
              //                   image: AssetImage(
              //                     controller.homeListModel[index].image,
              //                   ),
              //                 ),

              //                 Positioned(
              //                   bottom: 10,
              //                   right: 10,
              //                   child: Container(
              //                     padding: EdgeInsets.all(8),
              //                     decoration: BoxDecoration(
              //                       color: whiteColor.withOpacity(0.5),
              //                       borderRadius: BorderRadius.circular(8),
              //                     ),
              //                     child: SvgPicture.asset(
              //                       'assets/icons_svg/cart_add_icon.svg',
              //                     ),
              //                   ),
              //                 ),
              //               ],
              //             ),
              //             CustomText(
              //               text: controller.homeListModel[index].name,
              //               fontSize: 14,
              //               maxLines: 2,
              //               fontFamily: "Roboto",
              //               color: whiteColor,
              //               fontWeight: FontWeight.w500,
              //             ),
              //             CustomText(
              //               text: "\$${controller.homeListModel[index].price}",
              //               fontSize: 12,
              //               maxLines: 1,
              //               fontFamily: "Roboto",

              //               color: whiteColor,
              //               fontWeight: FontWeight.w400,
              //             ),
              //           ],
              //         ),
              //       ),
              // ),
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
            showButton == false? Container() :CustomButton(
              backgroundColor: whiteColor,
                textColor: primaryBlackColor,
                minWidth: 100,
                text: "Shop All", onPressed:
                  () => Get.to(
                    () => AllProductsPage(
                  whichPage: "All Produccts",
                ),
              ),

            )
          ],
        ),
      ),
    );
  }
}
