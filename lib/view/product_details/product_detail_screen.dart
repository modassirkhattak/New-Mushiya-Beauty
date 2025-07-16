import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shopify_flutter/models/src/product/product.dart';
import 'package:shopify_flutter/models/src/product/product_variant/product_variant.dart';
import 'package:shopify_flutter/shopify_flutter.dart';
import 'package:svg_flutter/svg.dart';

import '../../controller/home_controller.dart';
import '../../controller/product_details_controller.dart';
import '../../utills/api_controller.dart';
import '../../utills/app_colors.dart';
import '../checkout/checkout_page.dart';
import '../faq/faq_page.dart';
import '../profile/more_all_pages/partner_policy_page.dart';
import '../profile/more_all_pages/shipping_policy_page.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_dropdown.dart';
import '../../widget/custom_tabbar.dart';
import '../../widget/custom_text.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopify_flutter/shopify_flutter.dart';
import 'package:shopify_flutter/models/src/cart/inputs/attribute_input/attribute_input.dart';
import 'package:shopify_flutter/mixins/src/shopify_error.dart';
import 'dart:developer';
import '../../new_app/screens/checkout_webview.dart'; // For context.showSnackBar

class CartController extends GetxController {
  final ShopifyCart shopifyCart = ShopifyCart.instance;
  final ShopifyAuth shopifyAuth = ShopifyAuth.instance;

  // Reactive variables
  var cart = Rxn<Cart>(); // Current cart
  var isLoading = false.obs; // Loading state
  var errorMessage = ''.obs; // Error message for UI

  @override
  void onInit() {
    super.onInit();
    loadOrCreateCart();
  }

  Future<void> loadOrCreateCart() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final cartId = prefs.getString('cart_id');

      if (cartId != null) {
        try {
          final cartResponse = await shopifyCart.getCartById(cartId);
          cart.value = cartResponse;
          logCartInfo(cartResponse!);
        } on ShopifyException catch (error) {
          log('getCartById ShopifyException: $error');
          await createCart();
        }
      } else {
        await createCart();
      }
    } catch (error) {
      log('loadOrCreateCart Error: $error');
      errorMessage.value = 'Error loading cart';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createCart() async {
    try {
      isLoading.value = true;
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      final token = sharedPreferences.getString('customer_access_token');
      String? accessToken =  token;
      final CartInput cartInput = CartInput(
        buyerIdentity: CartBuyerIdentityInput(
          email:  FirebaseAuth.instance.currentUser!.email.toString(), // Replace with actual user email or constant
          customerAccessToken: accessToken,
        ),
        attributes: [AttributeInput(key: 'color', value: 'Blue')],
      );
      final newCart = await shopifyCart.createCart(cartInput);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cart_id', newCart.id);
      cart.value = newCart;
      logCartInfo(newCart);
    } on ShopifyException catch (error) {
      log('createCart ShopifyException: $error');
      errorMessage.value = error.errors?[0]["message"] ?? 'Error creating cart';
    } catch (error) {
      log('createCart Error: $error');
      errorMessage.value = 'Error creating cart';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addLineItemToCart(Product product, int quantity) async {
    try {
      if (cart.value == null) {
        errorMessage.value = 'Cart not initialized';
        return;
      }
      if (product.productVariants.isEmpty) {
        errorMessage.value = 'No variants available for ${product.title}';
        return;
      }

      String merchandiseId = product.productVariants.first.id.toString();
      if (!merchandiseId.startsWith('gid://shopify/ProductVariant/')) {
        merchandiseId = 'gid://shopify/ProductVariant/$merchandiseId';
      }
      log('Adding to cart with merchandiseId: $merchandiseId');

      final cartLineInput = CartLineUpdateInput(
        quantity: quantity,
        merchandiseId: merchandiseId,
      );

      final updatedCart = await shopifyCart.addLineItemsToCart(
        cartId: cart.value!.id,
        cartLineInputs: [cartLineInput],
      );

      cart.value = updatedCart;
      logCartInfo(updatedCart);
      errorMessage.value = '';
      Get.snackbar('Success', 'Added ${product.title} to cart');
    } on ShopifyException catch (error) {
      log('addLineItemToCart ShopifyException: ${error.errors}');
      errorMessage.value =
          error.errors?[0] ?? 'Error adding item to cart';
    } catch (error) {
      log('addLineItemToCart Error: $error');
      errorMessage.value = 'Unexpected error adding item to cart';
    }
  }

  Future<void> getCartById(String cartId) async {
    try {
      isLoading.value = true;
      final cartResponse = await shopifyCart.getCartById(cartId);
      cart.value = cartResponse;
      logCartInfo(cartResponse!);
      errorMessage.value = '';
    } on ShopifyException catch (error) {
      log('getCartById ShopifyException: $error');
      errorMessage.value =
          error.errors?[0]["message"] ?? 'Error retrieving cart';
    } catch (error) {
      log('getCartById Error: $error');
      errorMessage.value = 'Error retrieving cart';
    } finally {
      isLoading.value = false;
    }
  }

  void logCartInfo(Cart cart) {
    log('Cart ID: ${cart.id}');
    log(
      'Cart Lines: ${cart.lines.map((line) => line.merchandise!.title).toList()}',
    );
    log('Total Quantity: ${cart.totalQuantity}');
    log('Total Cost: ${cart.cost!.totalAmount}');
  }

  Future<bool> checkout() async {
    final checkoutUrl = cart.value?.checkoutUrl;
    if (checkoutUrl == null) {
      errorMessage.value = 'Invalid checkout URL';
      return false;
    }
    final status = await Get.to(
      () => WebViewCheckout(checkoutUrl: checkoutUrl),
    );
    if (status != null && status) {
      await getCartById(cart.value!.id);
      return true;
    }
    return false;
  }

  void clearError() {
    errorMessage.value = '';
  }
}

class ProductDetailController extends GetxController {
  late Product product;
  // Rx<Product> product = Rx<Product>(Product.fromJson({}));
  // Rx<Product> product = Rx<Product>(Product.fromJson({}));
  Rx<ProductVariant?> selectedVariant = Rx<ProductVariant?>(null);
  RxMap<String, String> selectedOptions = <String, String>{}.obs;

  void setProduct(Product newProduct) {
    product = newProduct;
    if (newProduct.productVariants.isNotEmpty) {
      selectVariant(newProduct.productVariants.first);
    }
  }

  void selectVariant(ProductVariant variant) {
    selectedVariant.value = variant;

    // Clear previous selections
    selectedOptions.clear();

    // Add new options (e.g., Size, Color)
    for (var option in variant.selectedOptions!) {
      selectedOptions[option.name] = option.value;
    }
  }

  void updateSelectedOption(String name, String value) {
    selectedOptions[name] = value;
  }
  // Share function
  void shareProductUrl(Product product) {
    final url = product.onlineStoreUrl ?? 'https://your-shopify-store.com/products/${product.handle}';
    final shareText = 'Check out ${product.title} at $url';
    Share.share(shareText, subject: 'Share ${product.title}');
    // Get.snackbar('Success', 'Product shared successfully');
  }
}

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  final String title;

  ProductDetailScreen({super.key, required this.product, required this.title}) {
    final controller = Get.put(ProductDetailController());
    controller.setProduct(product);
  }

  final cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductDetailController());

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
            title: title.toUpperCase(),
            titleImage: true,
            actions: true,
            actionsWidget: GestureDetector(onTap: (){
              controller.shareProductUrl(product);
            },child: SvgPicture.asset('assets/icons_svg/share_icon.svg')),
            leadingButton: true,
          ),
        ),
        body: Obx(() {
          final selected = controller.selectedVariant.value;
          // final selected = controller.selectedVariant.value;
          if (selected == null) {
            return Center(child: Text("No variants available"));
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                product.images.isNotEmpty
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        selected.image?.originalSrc ??
                            product.images.first.originalSrc,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 3,
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
                                      child: Container(
                                        height: MediaQuery.of(context).size.height / 3,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: whiteColor,
                                          ),
                                        ),
                                      ),
                                    ),
                      ),
                    )
                    : SizedBox.shrink(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    CustomText(
                      text: selected.price.formattedPriceWithLocale('en_US'),
                      fontSize: 18,
                      fontFamily: 'Archivo',
                      color: whiteColor,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(width: 10),
                    if (selected.compareAtPrice != null &&
                        selected.compareAtPrice!.amount != selected.price.amount)
                      CustomText(
                        text: selected.compareAtPrice!.formattedPriceWithLocale('en_US'),
                        fontSize: 14,
                        fontFamily: 'Archivo',
                        color: redColor,
                        decoration: TextDecoration.lineThrough,
                        decorationStyle: TextDecorationStyle.solid,
                        fontWeight: FontWeight.w500,
                      ),
                    const Spacer(),
                    Row(
                      children: List.generate(5, (index) {
                        double rating =  double.parse(selected.weight > 5 ? '5.0' : '${selected.weight}'); // Replace with actual rating if available
                        if (index < rating.floor()) {
                          return const Icon(Icons.star, color: Colors.yellow, size: 16);
                        } else if (index < rating && rating % 1 != 0) {
                          return const Icon(Icons.star_half, color: Colors.yellow, size: 16);
                        } else {
                          return const Icon(Icons.star_border, color: Colors.grey, size: 16);
                        }
                      }),
                    ),
                     CustomText(
                      text:  selected.weight > 5 ? '5.0' : '${selected.weight}',
                      fontSize: 14,
                      fontFamily: 'Archivo',
                      color: whiteColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // CustomText(
                //   text: '${product.onlineStoreUrl}',
                //   fontSize: 16,
                //   fontFamily: 'Roboto',
                //   color: whiteColor,
                //   fontWeight: FontWeight.w600,
                // ),
                // Dropdown for Variant Selection
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
                // Container(
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(12),
                //     border: Border.all(color: whiteColor, width: 0.8),
                //   ),
                //   child: DropdownButtonFormField<ProductVariant>(
                //     borderRadius:  BorderRadius.circular(12),
                //     value: selected,
                //     items: controller.variants
                //         .map((v) => DropdownMenuItem<ProductVariant>(
                //       value: v,
                //       child: Text(v.title),
                //     ))
                //         .toList(),
                //     onChanged: (value) {
                //
                //       if (value != null) controller.selectVariant(value);
                //     },
                //     validator:
                //             (value) {
                //           if (value == null) {
                //             return 'Please select a value';
                //           }
                //           return null;
                //         },
                //
                //     isExpanded: true,
                //     icon:  Icon(Icons.keyboard_arrow_down, color: Colors.white,size: 24,),
                //     style: GoogleFonts.roboto(color: Colors.white, fontSize: 14),
                //     decoration: InputDecoration(
                //       hintText: 'Select Variant',
                //       hintStyle: GoogleFonts.roboto(color: Colors.white, fontSize: 16),
                //       contentPadding:  EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                //       border: InputBorder.none,
                //       constraints: BoxConstraints(maxHeight: 48,minHeight: 48),
                //       enabledBorder: InputBorder.none,
                //       focusedBorder: InputBorder.none,
                //       errorBorder:InputBorder.none,
                //
                //     ),
                //
                //   ),
                //
                // ),

                /// --- Variant Dropdown ---
                Container(
                  decoration:  BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: whiteColor, width: 0.4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: DropdownButton<ProductVariant>(
                      isExpanded: true,
                      style: GoogleFonts.roboto(color: Colors.white, fontSize: 14),
                         padding: EdgeInsets.symmetric(horizontal: 12),
                         underline: Text(''),
                         autofocus: false,

                         menuMaxHeight: MediaQuery.of(context).size.width*0.80,
                         // menuWidth: 400,
                         alignment: Alignment.bottomCenter,
                         // itemHeight: 5,

                         icon: Icon(Icons.keyboard_arrow_down, color: Colors.white,size: 24,),
                      value: controller.selectedVariant.value,
                      items: controller.product.productVariants.map((variant) {
                        return DropdownMenuItem(
                          value: variant,
                          child: Text(variant.title),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) controller.selectVariant(value);
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                /// --- Options Dropdowns (inside Variant) ---
                ...controller.selectedVariant.value!.selectedOptions!.map((option) {
                  final optionName = option.name;

                  /// Get all values for this option across all variants
                  final allValues = controller.product.productVariants
                      .map((v) => v.selectedOptions!
                      .firstWhereOrNull((o) => o.name == optionName)
                      ?.value)
                      .whereType<String>()
                      .toSet()
                      .toList();

                  /// If only value is 'Default Title', skip rendering this dropdown
                  if (allValues.length == 1 && allValues.first == 'Default Title') {
                    return const SizedBox.shrink(); // Return nothing
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        optionName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8, bottom: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: whiteColor, width: 0.4),
                        ),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          style: GoogleFonts.roboto(color: Colors.white, fontSize: 14),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          underline: const SizedBox(),
                          autofocus: false,
                          menuMaxHeight: MediaQuery.of(context).size.width * 0.80,
                          alignment: Alignment.bottomCenter,
                          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 24),

                          value: controller.selectedOptions[optionName],
                          items: allValues.map((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value == "Default Title" ? "Empty Title" : value),
                            );
                          }).toList(),

                          onChanged: (value) {
                            if (value != null) {
                              controller.updateSelectedOption(optionName, value);
                            }
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),


                // SizedBox(height: 20),

                // /// Selected Variant Info
                // if (controller.selectedVariant.value != null)
                //   ListTile(
                //     leading: controller.selectedVariant.value?.image != null
                //         ? Image.network(
                //       controller.selectedVariant.value!.image!.originalSrc,
                //       width: 50,
                //     )
                //         : null,
                //     title: Text(controller.selectedVariant.value!.title),
                //     subtitle: Text(
                //       controller.selectedVariant.value!.price.formattedPriceWithLocale('en_US'),
                //     ),
                //   ),


                const SizedBox(height: 16),
                // CustomDropdown(
                //   hintText: 'Select ${product.options[0].name}',
                //   items:
                //       product.productVariants
                //           .map(
                //             (e) => e.selectedOptions!
                //                 .map((e) => e.value)
                //                 .join(', '),
                //           )
                //           .toList(),
                //   selectedValue:
                //       Get.put(
                //         ProductDetailsController(),
                //       ).selecctColor, // Use the existing instance
                //   onChanged: (value) {
                //     Get.put(ProductDetailsController()).selecctColor.value =
                //         value.toString();
                //
                //     final selectedVariant = product.productVariants.firstWhere(
                //       (variant) =>
                //           variant.selectedOptions!
                //               .map((e) => e.value)
                //               .join(', ') ==
                //           value.toString(),
                //       orElse: () => product.productVariants.first,
                //     );
                //
                //     controller.selectedVariant.value = selectedVariant;
                //   },
                // ),
                // const SizedBox(height: 16),
                Obx(() {
                  final variant = controller.selectedVariant.value;
                  final isVariantSelected = variant != null;
                  final isOutOfStock = isVariantSelected
                      ? !variant.availableForSale || variant.quantityAvailable == 0
                      : !product.productVariants.first.availableForSale ||
                      product.productVariants.first.quantityAvailable == 0;

                  if (!isVariantSelected) {
                    return Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: "Add to Cart".toUpperCase(),
                            onPressed: () {
                              Get.snackbar('Error', 'Please select a variant');
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
                              Get.snackbar('Error', 'Please select a variant');
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
                    return CustomButton(
                      text: "Sold Out - Notify Me When It’s Available".toUpperCase(),
                      onPressed: () {
                        Get.snackbar('Notify', 'You will be notified when this item is back in stock');
                      },
                      minWidth: double.infinity,
                      backgroundColor: whiteColor,
                      textColor: primaryBlackColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 40,
                    );
                  } else {
                    return Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: "Add to Cart".toUpperCase(),
                            onPressed: () {
                              if (controller.selectedVariant.value == null) {
                                Get.snackbar('Error', 'Please select a variant');
                              } else {
                                cartController.addLineItemToCart(
                                  product,
                                  Get.put(HomeController()).quantity.value,//.quantity.value,
                                  // : controller.selectedVariant.value,
                                );
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
                            onPressed: () async {
                              if (controller.selectedVariant.value == null) {
                                Get.snackbar('Error', 'Please select a variant');
                              } else {
                                await cartController.addLineItemToCart(
                                  product,
                                  Get.put(HomeController()).quantity.value,
                                  // variant: controller.selectedVariant.value,
                                );
                                if (cartController.errorMessage.isEmpty) {
                                  await cartController.checkout();
                                }
                              }
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
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.30,
                  child: TabBarView(
                    children: [
                      tabbarView(
                        homeModel: product,
                        title: "Description",
                        description: product.descriptionHtml.toString(),
                      ),
                      TheShoppingPolicyPage(
                        isPage: false,
                        handle: SHIPPING_POLICY,
                      ),
                      PartnerPolicyPage(isPage: false, handle: PARTNER_POLICY),
                    ],
                  ),
                ),

                // Price & Info
                // ListTile(
                //   title: Text(
                //     "Price: ${selected.price.formattedPriceWithLocale('en_US')}",
                //   ),
                //   subtitle: Text("Title: ${selected.title}"),
                // ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

Widget tabbarView({
  required Product homeModel,
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

      ],
    ),
  );
}
