import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/controller/home_controller.dart';
import 'package:mushiya_beauty/model/product_model.dart';
import 'package:mushiya_beauty/new_app/screens/checkout_webview.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/view/checkout/checkout_page.dart';
import 'package:mushiya_beauty/view/faq/faq_page.dart';
import 'package:mushiya_beauty/view/profile/more_all_pages/partner_policy_page.dart';
import 'package:mushiya_beauty/view/profile/more_all_pages/shipping_policy_page.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';
import 'package:mushiya_beauty/widget/custom_button.dart';
import 'package:mushiya_beauty/widget/custom_dropdown.dart' show CustomDropdown;
import 'package:mushiya_beauty/widget/custom_tabbar.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:svg_flutter/svg.dart';

import '../../controller/policy_controller.dart';
import '../../controller/product_details_controller.dart';
import '../../model/best_selling_product_model.dart';
import 'dart:developer';

import 'package:mushiya_beauty/new_app//constants.dart';
import 'package:mushiya_beauty/new_app//extension.dart';

import 'package:shopify_flutter/mixins/src/shopify_error.dart';
import 'package:shopify_flutter/models/src/cart/inputs/attribute_input/attribute_input.dart';
import 'package:shopify_flutter/shopify_flutter.dart';

import '../../new_app/screens/cart_tab.dart';
import '../../utills/api_controller.dart';

class SearchProductDetailsPage extends StatefulWidget {
  SearchProductDetailsPage({
    super.key,
    required this.title,
    required this.homeModel,
  });

  final String title;
  final Product homeModel;

  @override
  State<SearchProductDetailsPage> createState() =>
      _SearchProductDetailsPageState();
}

class _SearchProductDetailsPageState extends State<SearchProductDetailsPage> {
  final homeController = Get.put(HomeController());
  final controller = Get.put(ProductDetailsController());
  final ShopifyStore shopifyStore = ShopifyStore.instance;
  final ShopifyCart shopifyCart = ShopifyCart.instance;
  // final HomeController controller = Get.put(HomeController());

  Cart? cart;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    loadOrCreateCart();
  }

  Future<void> loadOrCreateCart() async {
    try {
      // Check for existing cart ID in shared preferences
      final prefs = await SharedPreferences.getInstance();
      final cartId = prefs.getString('cart_id');

      if (cartId != null) {
        // Try to fetch existing cart
        try {
          final cartResponse = await shopifyCart.getCartById(cartId);
          setState(() {
            cart = cartResponse;
          });
          logCartInfo(cart!);
        } on ShopifyException catch (error) {
          log('getCartById ShopifyException: $error');
          // If cart is invalid or expired, create a new one
          await createCart();
        }
      } else {
        // No cart ID found, create a new cart
        await createCart();
      }
    } catch (error) {
      log('loadOrCreateCart Error: $error');
      if (!mounted) return;
      context.showSnackBar('Error loading cart');
    }
  }

  Future<void> createCart() async {
    String? accessToken = await ShopifyAuth.instance.currentCustomerAccessToken;
    final CartInput cartInput = CartInput(
      buyerIdentity: CartBuyerIdentityInput(
        email: kUserEmail,
        customerAccessToken: accessToken,
      ),
      attributes: [AttributeInput(key: 'color', value: 'Blue')],
    );
    try {
      final newCart = await shopifyCart.createCart(cartInput);
      // Save cart ID to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cart_id', newCart.id);
      setState(() {
        cart = newCart;
      });
      logCartInfo(newCart);
    } on ShopifyException catch (error) {
      log('createCart ShopifyException: $error');
      if (!mounted) return;
      context.showSnackBar(
        error.errors?[0]["message"] ?? 'Error creating cart',
      );
    } catch (error) {
      log('createCart Error: $error');
      if (!mounted) return;
      context.showSnackBar('Error creating cart');
    }
  }

  Future<void> getCartById(String cartId) async {
    try {
      final cartResponse = await shopifyCart.getCartById(cartId);
      setState(() {
        cart = cartResponse;
      });
      logCartInfo(cart!);
    } on ShopifyException catch (error) {
      log('getCartById ShopifyException: $error');
      if (!mounted) return;
      context.showSnackBar(
        error.errors?[0]["message"] ?? 'Error retrieving cart',
      );
    } catch (error) {
      log('getCartById Error: $error');
    }
  }

  void onCheckoutTap() async {
    final checkoutUrl = cart?.checkoutUrl;
    log('Checkout URL: $checkoutUrl');
    if (checkoutUrl == null) {
      context.showSnackBar('Invalid checkout URL');
      return;
    }
    final status = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WebViewCheckout(checkoutUrl: checkoutUrl),
      ),
    );
    if (status != null && status) {
      if (!mounted) return;
      context.showSnackBar('Checkout Success');
      await getCartById(cart!.id);
    }
  }

  void addLineItemToCart(ProductModel product) async {
    try {
      if (cart == null) {
        context.showSnackBar('Cart not initialized');
        return;
      }

      if (product.variants.isEmpty) {
        context.showSnackBar('No variants available for ${product.title}');
        return;
      }

      String merchandiseId = product.variants.first.id.toString();
      if (!merchandiseId.startsWith('gid://shopify/ProductVariant/')) {
        merchandiseId = 'gid://shopify/ProductVariant/$merchandiseId';
      }
      log('Adding to cart with merchandiseId: $merchandiseId');

      final cartLineInput = CartLineUpdateInput(
        quantity: Get.put(HomeController()).quantity.value,

        merchandiseId: merchandiseId,
        // attributes: [AttributeInput(key: 'color', value: 'red')],
      );

      final updatedCart = await shopifyCart.addLineItemsToCart(
        cartId: cart!.id,
        cartLineInputs: [cartLineInput],
      );

      setState(() {
        cart = updatedCart;
      });
      logCartInfo(updatedCart);
      if (!mounted) return;
      context.showSnackBar('Added ${product.title} to cart');
    } on ShopifyException catch (error) {
      log('addLineItemToCart ShopifyException: ${error.errors}');
      if (!mounted) return;
      context.showSnackBar(error.errors.toString());
    } catch (error) {
      log('addLineItemToCart Error: $error');
      if (!mounted) return;
      context.showSnackBar('Unexpected error adding item to cart');
    }
  }

  void onCartItemUpdate() async {
    if (cart == null) return;
    await getCartById(cart!.id);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(() => FaqPage());
          },
          materialTapTargetSize: MaterialTapTargetSize.padded,
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
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: MyAppBarWidget(
            title: widget.title.toUpperCase(),
            titleImage: true,
            actions: true,
            actionsWidget: SvgPicture.asset('assets/icons_svg/share_icon.svg'),
            leadingButton: true,
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: whiteColor),
            );
          }
          if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: controller.errorMessage.value,
                    color: redColor,
                    fontSize: 16,
                  ),
                  const SizedBox(height: 16),
                  MaterialButton(
                    onPressed:
                        () => controller.fetchProduct(
                          int.parse(widget.homeModel.id),
                        ),
                    color: redColor,
                    child: const Text(
                      'Retry',
                      style: TextStyle(color: whiteColor),
                    ),
                  ),
                ],
              ),
            );
          }
          final product = controller.product.value;
          if (product == null) {
            return const Center(
              child: CustomText(text: 'Product not found', color: whiteColor),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 320,
                      aspectRatio: 1.0,
                      autoPlay: true,
                      enableInfiniteScroll: false,
                      viewportFraction: 1.0,
                      autoPlayInterval: const Duration(seconds: 3),
                      initialPage: 0,
                    ),
                    items:
                        List.generate(
                          product.images.length,
                          (index) => index,
                        ).map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Image.network(
                                product.images.isEmpty
                                    ? 'https://cdn.shopify.com/s/files/1/1190/6424/files/Afro_Fusion.png?v=1733257065'
                                    : product.images[i].src,
                                height: 320,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) => Image.asset(
                                      'assets/extra_images/girl_1.png',
                                      height: 320,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                loadingBuilder:
                                    (context, child, loadingProgress) =>
                                        loadingProgress == null
                                            ? child
                                            : Center(
                                              child: CircularProgressIndicator(
                                                color: whiteColor,
                                              ),
                                            ),
                              );
                            },
                          );
                        }).toList(),
                  ),
                ),
                Row(
                  children: [
                    Obx(
                      () => CustomText(
                        text:
                            '\$${homeController.selectedVariant.value == null ? product.variants.first.price : homeController.selectedVariant.value!.price}',
                        fontSize: 18,
                        fontFamily: 'Archivo',
                        color: whiteColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Obx(
                      () => CustomText(
                        text:
                            '${homeController.selectedVariant.value == null
                                ? product.variants.first.compareAtPrice == product.variants.first.price
                                    ? ''
                                    : '${product.variants.first.compareAtPrice == '' ? '' : '\$${product.variants.first.compareAtPrice}'}'
                                : homeController.selectedVariant.value!.compareAtPrice == homeController.selectedVariant.value!.price
                                ? ''
                                : '${homeController.selectedVariant.value!.compareAtPrice == '' ? '' : '\$${homeController.selectedVariant.value!.compareAtPrice}'}'}',
                        // '\$${homeController.selectedVariant.value == null ? product.variants.first.compareAtPrice : homeController.selectedVariant.value!.compareAtPrice}',
                        fontSize: 14,
                        fontFamily: 'Archivo',
                        color: redColor,
                        decoration: TextDecoration.lineThrough,
                        decorationStyle: TextDecorationStyle.solid,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: List.generate(5, (index) {
                        double rating =
                            product.variants.first.weight!; // for example: 3.5

                        if (index < rating.floor()) {
                          // Full star
                          return Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 16,
                          );
                        } else if (index < rating && rating % 1 != 0) {
                          // Half star
                          return Icon(
                            Icons.star_half,
                            color: Colors.yellow,
                            size: 16,
                          );
                        } else {
                          // Empty star
                          return Icon(
                            Icons.star_border,
                            color: Colors.grey,
                            size: 16,
                          );
                        }
                      }),
                    ),
                    CustomText(
                      text: product.variants.first.weight.toString(),
                      fontSize: 14,
                      fontFamily: 'Archivo',
                      color: whiteColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Quantity selector
                Obx(
                  () => Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: whiteColor, width: 0.8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap:
                              () =>
                                  Get.put(HomeController()).decrementQuantity(),
                          child: Icon(
                            Icons.remove,
                            color: whiteColor,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 10),
                        CustomText(
                          text: '${Get.put(HomeController()).quantity.value}',
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          color: whiteColor,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap:
                              () =>
                                  Get.put(HomeController()).incrementQuantity(),
                          child: Icon(Icons.add, color: whiteColor, size: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Variant dropdown
                CustomDropdown(
                  hintText: 'Select ${product.options[0].name}',
                  items: product.variants.map((e) => e.title).toList(),
                  selectedValue: controller.selecctSize,
                  onChanged: (p0) {
                    controller.selecctSize.value = p0.toString();
                    final selectedVariant = product.variants.firstWhere(
                      (variant) => variant.title == p0.toString(),
                      orElse: () => product.variants.first,
                    );
                    homeController.selectedVariant.value =
                        selectedVariant; // Assign single VariantModel
                    log('Selected Variant Details:');
                    log('Title: ${selectedVariant.title}');
                    log('ID: ${selectedVariant.id}');
                    log('Price: ${selectedVariant.price}');
                    log('Weight: ${selectedVariant.weight}');
                    log('Available: ${selectedVariant.inventoryQuantity}');
                    log('SKU: ${selectedVariant.sku}');
                    log('Barcode: ${selectedVariant.barcode}');
                  },
                ),
                const SizedBox(height: 16),
                // Add to cart and buy now buttons
                // Text( controller.selectedVariant.value!.title),
                Obx(() {
                  final variant = homeController.selectedVariant.value;
                  final isVariantSelected = variant != null;
                  final isOutOfStock =
                      isVariantSelected
                          ? variant.inventoryQuantity == 0
                          : product.variants.first.inventoryQuantity == 0;

                  if (!isVariantSelected) {
                    // ✅ Variant not selected — show Add to Cart + Buy Now
                    return Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: "Add to Cart".toUpperCase(),
                            onPressed: () => addLineItemToCart(product),
                            backgroundColor: whiteColor,
                            textColor: primaryBlackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 40,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CustomButton(
                            text: "Buy Now".toUpperCase(),
                            onPressed: () {
                              addLineItemToCart(product);

                              onCheckoutTap();
                            },
                            backgroundColor: whiteColor,
                            textColor: primaryBlackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 40,
                          ),
                        ),
                      ],
                    );
                  } else if (isOutOfStock) {
                    // ✅ Variant selected but out of stock — show Notify button
                    return CustomButton(
                      text:
                          "Sold Out - Notify Me When It’s Available"
                              .toUpperCase(),
                      onPressed: () {
                        // Add notify logic here
                      },
                      minWidth: double.infinity,
                      backgroundColor: whiteColor,
                      textColor: primaryBlackColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 40,
                    );
                  } else {
                    // ✅ Variant selected and in stock — show Add to Cart + Buy Now
                    return Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: "Add to Cart".toUpperCase(),
                            onPressed: () {
                              if (homeController.selectedVariant.value ==
                                  null) {
                                Get.snackbar(
                                  'Error',
                                  'Please select a variant',
                                );
                              } else {
                                addLineItemToCart(product);
                              }
                            },
                            backgroundColor: whiteColor,
                            textColor: primaryBlackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 40,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CustomButton(
                            text: "Buy Now".toUpperCase(),
                            onPressed: () {
                              addLineItemToCart(product);

                              onCheckoutTap();
                            },
                            backgroundColor: whiteColor,
                            textColor: primaryBlackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 40,
                          ),
                        ),
                      ],
                    );
                  }
                }),

                const SizedBox(height: 16),
                // More payment options
                Center(
                  child: GestureDetector(
                    onTap: () => Get.to(() => CheckoutPage()),
                    child: CustomText(
                      text: 'More payment options',
                      fontSize: 12,
                      fontFamily: 'Archivo',
                      color: whiteColor,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                CustomTabWidget(
                    children: [
                      Tab(text: 'Description'),
                      Tab(text: 'Shipping policy'),
                      Tab(text: 'Return policy'),

                    ],
                    onTap: (value) {
                      print(value);
                      if(value == 0){


                      } else if(value == 1){
                        Get.put(PolicyController()).fetchPageContent(SHIPPING_POLICY);
                      } else if(value == 2){
                        Get.put(PolicyController()).fetchPageContent(RETURN_POLICY);
                      }}
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.30,
                  child: TabBarView(
                    children: [
                      tabbarView(
                        homeModel: product,
                        title: "Description",
                        description: product.bodyHtml,
                      ),
                      TheShoppingPolicyPage(
                        isPage: false,
                        handle: SHIPPING_POLICY,

                        // homeModel: homeModel,
                        // title: "Shipping policy",
                        // description: "adsadas",
                      ),
                      PartnerPolicyPage(
                        isPage: false,
                        handle:   RETURN_POLICY,
                        // homeModel: homeModel,
                        // title: "Return policy",
                        // description: "jksdjksa",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

Widget tabbarView({
  required ProductModel homeModel,
  required String title,
  required String description,
}) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // CustomText(
        //   text: title,
        //   fontSize: 18,
        //   fontFamily: 'Archivo',
        //   color: whiteColor,
        //   fontWeight: FontWeight.w600,
        // ),
        // const SizedBox(height: 12),
        Html(
          data: description,
          shrinkWrap: true,
          style: {
            'p': Style(
              fontSize: FontSize(14),
              fontWeight: FontWeight.w400,
              color: whiteColor.withOpacity(0.8),
            ),
            'strong': Style(
              fontWeight: FontWeight.w600,
              fontSize: FontSize(16),
              fontFamily: "Roboto",

              color: whiteColor,
            ),
            'ul': Style(margin: Margins(left: Margin(0))),
            'table': Style(
              fontSize: FontSize(14),
              fontFamily: "Roboto",
              fontWeight: FontWeight.w400,
              color: whiteColor.withOpacity(0.8),

              // bo: BorderCollapse.separate,
              // borderSpacing: 0,
            ),
            'td': Style(
              fontFamily: "Roboto",
              // padding: Padding(padding: paddingAll(8)),s
              // border: Border.all(color: Colors.grey),
            ),
            'span': Style(
              fontSize: FontSize(14),
              fontFamily: "Roboto",
              fontWeight: FontWeight.w400,
              color: whiteColor,
            ),
          },
        ),
        SizedBox(height: 80),
        // CustomText(
        //   text:
        //       description,
        //   fontSize: 12,
        //   fontFamily: 'Roboto',
        //   color: whiteColor,
        //   maxLines: 90,
        //   fontWeight: FontWeight.w400,
        // ),
      ],
    ),
  );
}
