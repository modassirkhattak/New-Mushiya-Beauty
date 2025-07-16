// ignore_for_file: unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:get/utils.dart';
import 'package:mushiya_beauty/controller/home_controller.dart'
    show HomeController;
import 'package:mushiya_beauty/controller/shop_controller.dart';
import 'package:mushiya_beauty/model/home_model.dart' show HomeModel;
import 'package:mushiya_beauty/new_app/screens/home_tab.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/view/auth/stated_page.dart';
import 'package:mushiya_beauty/view/cart/cart_page.dart';
import 'package:mushiya_beauty/view/faq/faq_page.dart';

import 'package:mushiya_beauty/view/request_access/request_access_page.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart' show MyAppBarWidget;
import 'package:mushiya_beauty/widget/custom_button.dart';
import 'package:mushiya_beauty/widget/custom_tabbar.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';
import 'package:mushiya_beauty/widget/custom_textfield.dart';
import 'package:mushiya_beauty/widget/drawer_widget.dart';
import 'package:shopify_flutter/shopify_flutter.dart';
import 'package:svg_flutter/svg_flutter.dart';

import '../../controller/home_specific_collect_controller.dart';
import '../../controller/product_details_controller.dart';

import '../product_details/product_detail_screen.dart';
import '../product_details/best_seller_details.dart';
import '../product_details/custom_collect_details.dart';

class ShopPage extends StatelessWidget {
  ShopPage({super.key, this.whichPage});

  final String? whichPage;

  final controller = Get.put(ShopController());
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: DrawerWidget(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(() => FaqPage());
          },
          materialTapTargetSize: MaterialTapTargetSize.padded,
          // mini: true,
          shape: const CircleBorder(),
          backgroundColor: whiteColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              'assets/icons_svg/message_icon2.svg',
              height: 24,
              width: 24,
            ),
          ),
        ),
        // backgroundColor: greyColor,
        persistentFooterAlignment: AlignmentDirectional.centerEnd,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: MyAppBarWidget(
            // title: ''.toUpperCase() ?? 'All products'.toUpperCase(),
            titleImage: false,
            actions: true,
            actionsWidget: GestureDetector(
              onTap: () {
                Get.to(() => CartInfo());
              },
              child: SvgPicture.asset('assets/icons_svg/cart_icon.svg'),
            ),
            leadingButton: false,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            spacing: 24,
            children: [
              CustomTabWidget(
                children: [Tab(text: 'Shop'), Tab(text: 'Wholesale')],
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    tabbarView(title: 'Shop'),
                    FirebaseAuth.instance.currentUser == null
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: "Please login to access wholesale",
                                fontSize: 16,
                                color: whiteColor,
                              ),
                              SizedBox(height: 16),
                              CustomButton(
                                text: "Login",
                                onPressed: () {
                                  Get.to(() => StatedPage());
                                },
                                backgroundColor: whiteColor,
                                textColor: primaryBlackColor,
                                fontSize: 14,
                                minWidth: double.infinity,
                                fontWeight: FontWeight.w600,
                                height: 48,
                              ),
                            ],
                          ),
                        )
                        : tabbarViewWholesale(title: 'Wholesale'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget buildProductThumbnail(Product product, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // final productID= product.id.split();
        print("......${product.id}");
        final controller = Get.put(ProductDetailScreen(title: product.title,product: product));
        controller;
        Get.to(ProductDetailScreen(product: product,title: product.title.toString()));
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
                ),
              ),
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
          CustomText(
            text:
            "\$${product.price.toString()}",
            fontSize: 12,
            maxLines: 1,
            fontFamily: "Roboto",

            color: whiteColor,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }

}

Widget tabbarView({required String title}) {
  final controller = Get.put(HomeController());
  final controllerShopify = Get.put(ShopifyProductController());
  ;Get.put(
    ShopifyProductController(),
  ).fetchAllProductsFromCollection(
    'gid://shopify/Collection/'+controller.collections.first.id.toString(),
    // isLoadMore: false,
  );
  // Get.put(HomeSpecificCollectController()).fetchCollectionProducts(
  //   controller.collections.first.id.toString(),
  //   isLoadMore: false,
  // );

  final HomeModel homeModel;

  return Column(
    children: [
      CustomTextField(
        hintText: "Search",
        textEditingController: TextEditingController(),
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
      SizedBox(height: 16),
      SizedBox(
        height: 16,
        width: double.infinity,
        child: Obx(
          () =>
              controller.isLoading.value
                  ? Center(child: CircularProgressIndicator(color: whiteColor))
                  : controller.errorMessage.value.isNotEmpty
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.errorMessage.value,
                          style: TextStyle(color: Colors.red, fontSize: 16),
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
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: controller.collections.length,
                    itemBuilder:
                        (context, index) => Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: GestureDetector(
                            onTap: () {
                             /* Get.put(
                                HomeSpecificCollectController(),
                              ).fetchCollectionProducts(
                                "gid://shopify/Collection/"+controller.collections[index].id.toString(),
                                isLoadMore: false,

                              );*/Get.put(
                                ShopifyProductController(),
                              ).fetchAllProductsFromCollection(
                                'gid://shopify/Collection/'+controller.collections[index].id.toString(),
                                // isLoadMore: false,
                              );

                              // print(controller.collections[index].id);
                              // Get.put(
                              //   HomeSpecificCollectController(),
                              // ).fetchCollectionProducts(
                              //   controller.collections[index].id.toString(),
                              //   isLoadMore: false,
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

      SizedBox(height: 16),
      Expanded(
        child: Obx(() {
          if (Get.put(ShopifyProductController()).isLoading.value) {
            return const Center(child: CircularProgressIndicator(color: whiteColor,));
          }

          if (Get.put(ShopifyProductController()).filteredProducts.isEmpty) {
            return const Center(child: Text("No products found."));
          }

          return GridView.builder(
            // padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            itemCount: controllerShopify.filteredProducts.length,
            itemBuilder: (_, index) {
              final product = controllerShopify.filteredProducts[index];
              return buildProductThumbnail(product);
            },
          );
        }),
      ),
      /* Expanded(
        child: Obx(() {
          if (Get.put(
            HomeSpecificCollectController(),
          ).isCollProdLoading.value) {
            return Center(child: CircularProgressIndicator(color: whiteColor));
          }

          if (Get.put(
            HomeSpecificCollectController(),
          ).isCollProderrorMessage.value.isNotEmpty) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("No products found"),
                  MaterialButton(
                    onPressed: () {
                      Get.put(
                        HomeSpecificCollectController(),
                      ).retryFetchCollectionProducts();
                    },
                    child: Text("Retry"),
                    color: redColor,
                  ),
                ],
              ),
            );
          } else if (Get.put(
            HomeSpecificCollectController(),
          ).collectionProducts.isEmpty) {
            return Center(child: Text("No products found"));
          }

          return GridView.builder(
            itemCount:
                Get.put(
                  HomeSpecificCollectController(),
                ).collectionProducts.length,
            controller:
                Get.put(HomeSpecificCollectController()).scrollController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              final product =
                  Get.put(
                    HomeSpecificCollectController(),
                  ).collectionProducts[index];
              // return Text(product.title.toString());
              return GestureDetector(
                onTap: () {
                  String gid = product.id;
                  String numericId = gid.split('/').last;
                  Get.put(
                    ProductDetailsController(),
                  ).fetchProduct(int.parse(numericId));
                  Get.put(HomeController()).selectedVariant.value = null;
                  Get.to(
                    CustomCollectDetails(
                      homeModel: product,
                      title: product.title,
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  // spacing: 8,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            product.imageSrc == null
                                ? 'https://cdn.shopify.com/s/files/1/1190/6424/files/Afro_Fusion.png?v=1733257065'
                                : product.imageSrc!,
                            // height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Image.asset(
                                  'assets/extra_images/girl_1.png',
                                  // height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                            loadingBuilder:
                                (context, child, loadingProgress) =>
                                    loadingProgress == null
                                        ? child
                                        : Image.asset(
                                          'assets/extra_images/girl_1.png',
                                          // height: 200,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                          ),
                        ),
                        // if (whichPage == 'New' ||
                        //     whichPage == 'All Produccts' &&
                        //         product.status == "active")
                        //   Positioned(
                        //     top: 10,
                        //     left: 10,
                        //     child: Container(
                        //       decoration: BoxDecoration(
                        //         color:
                        //             whichPage == 'All Produccts'
                        //                 ? greyColor
                        //                 : primaryBlackColor,
                        //         borderRadius: BorderRadius.circular(8),
                        //       ),
                        //       child: CustomText(
                        //         text:
                        //             whichPage == 'New'
                        //                 ? "New"
                        //                 : "Solid Out",
                        //         leftPadding: 8,
                        //         topPadding: 4,
                        //         rightPadding: 8,
                        //         bottomPadding: 4,
                        //         fontSize: 12,
                        //         maxLines: 1,
                        //         fontFamily: "Roboto",
                        //         color: whiteColor,
                        //       ),
                        //     ),
                        //   ),
                        // if (whichPage == 'Sale' ||
                        //     whichPage == 'Clearance')
                        //   Positioned(
                        //     top: 10,
                        //     left: 10,
                        //     child: Container(
                        //       decoration: BoxDecoration(
                        //         color: redColor,
                        //         borderRadius: BorderRadius.circular(8),
                        //       ),
                        //       child: CustomText(
                        //         text:
                        //             whichPage == 'Sale' ? "Sale" : "Sale",
                        //         leftPadding: 8,
                        //         topPadding: 4,
                        //         rightPadding: 8,
                        //         bottomPadding: 4,
                        //         fontSize: 12,
                        //         maxLines: 1,
                        //         fontFamily: "Roboto",
                        //         color: whiteColor,
                        //       ),
                        //     ),
                        //   ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: whiteColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SvgPicture.asset(
                              'assets/icons_svg/cart_add_icon.svg',
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    CustomText(
                      text: product.title.toString(),
                      fontSize: 14,
                      maxLines: 2,
                      fontFamily: "Roboto",
                      color: whiteColor,
                      fontWeight: FontWeight.w500,
                    ),
                    // if (whichPage == 'Sale' || whichPage == 'Clearance')
                    CustomText(
                      text: "\$${product.variantPrice}",
                      fontSize: 12,
                      maxLines: 1,
                      topPadding: 4,
                      fontFamily: "Roboto",
                      color: whiteColor,
                      // decoration:
                      //     whichPage == 'Sale' || whichPage == 'Clearance'
                      //         ? TextDecoration.lineThrough
                      //         : null,
                      fontWeight: FontWeight.w400,
                    ),
                    // SizedBox(height: 4),
                    // CustomText(
                    //   text: "\$${product.variantPrice}",
                    //   fontSize: 12,
                    //   maxLines: 1,
                    //   fontFamily: "Roboto",
                    //   topPadding: 2,

                    //   color:
                    //       whichPage == 'Sale' || whichPage == 'Clearance'
                    //           ? redColor
                    //           : whiteColor,
                    //   fontWeight: FontWeight.w400,
                    // ),
                  ],
                ),
              );
            },
          );
        }),
      ),*/
    ],
  );
}
Widget buildProductThumbnail(Product product) {
  return GestureDetector(
    onTap: () {
      // final productID= product.id.split();
      print("......${product.id}");
      String gid =
          product
              .id;
      final controller = Get.put(ProductDetailScreen(title: product.title,product: product));
      controller;
      Get.to(ProductDetailScreen(product: product,title: product.title.toString()));
      // String numericId = gid.split('/').last;
      // Get.put(
      //   ProductDetailsController(),
      // ).fetchProduct(int.parse(numericId));
      // Get.put(HomeController())
      //     .selectedVariant
      //     .value = null;
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
              ),
            ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
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
            if(product.hasComparablePrice==true)
            CustomText(
              text:
              "\$${product.compareAtPrice.toString()}",
              fontSize: 12,
              maxLines: 1,

               // decorationStyle:  TextDecorationStyle.dashed,
              decoration: TextDecoration.lineThrough,
              fontFamily: "Roboto",

              color: redColor,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ],
    ),
  );
}

Widget tabbarViewWholesale({required String title}) {
  print("FirebaseAuth.instance.currentUser");
  // print(FirebaseAuth.instance.currentUser!.uid);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          // color: whiteColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: whiteColor, width: 0.3),
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            // tileMode: TileMode.,
            colors: [
              primaryBlackColor.withOpacity(0.2),
              // primaryBlackColor.withOpacity(0.3),
              whiteColor.withOpacity(0.1),
              // whiteColor.withOpacity(0.1),
              // primaryBlackColor.withOpacity(0.2),

              // primaryBlackColor,
              // whiteColor.withOpacity(0.1),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: "Become a wholesale partner",
              leftPadding: 24,
              topPadding: 33,
              rightPadding: 8,
              bottomPadding: 4,
              fontSize: 18,
              maxLines: 1,
              fontWeight: FontWeight.w600,
              fontFamily: "Roboto",
              color: whiteColor,
            ),
            CustomText(
              text: "\* Cheaper prices",
              leftPadding: 24,
              // topPadding: 4,
              rightPadding: 8,
              // bottomPadding: 4,
              fontSize: 14,
              maxLines: 1,
              fontWeight: FontWeight.w400,

              fontFamily: "Roboto",
              color: whiteColor,
            ),
            CustomText(
              text: "\* Bulk order access",
              leftPadding: 24,
              // topPadding: 4,
              rightPadding: 8,
              // bottomPadding: 4,
              fontSize: 14,
              maxLines: 1,
              fontWeight: FontWeight.w400,

              fontFamily: "Roboto",
              color: whiteColor,
            ),
            CustomText(
              text: "\* Exclusive inventory",
              leftPadding: 24,
              // topPadding: 4,
              rightPadding: 8,
              bottomPadding: 33,
              fontSize: 14,
              maxLines: 1,
              fontWeight: FontWeight.w400,

              fontFamily: "Roboto",
              color: whiteColor,
            ),
          ],
        ),
      ),
      SizedBox(height: 47),
      CustomButton(
        text: "Request access".toUpperCase(),
        onPressed: () {
          Get.to(() => RequestAccessPage());
        },
        backgroundColor: whiteColor,
        textColor: primaryBlackColor,
        fontSize: 14,

        minWidth: double.infinity,
        fontWeight: FontWeight.w600,
        height: 48,
      ),
    ],
  );

}

