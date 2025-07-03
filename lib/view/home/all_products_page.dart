import 'dart:developer';

import 'package:get/get.dart';
import 'package:mushiya_beauty/controller/home_controller.dart';
import 'package:mushiya_beauty/model/product_model.dart';
import 'package:mushiya_beauty/new_app/constants.dart';
import 'package:mushiya_beauty/new_app/extension.dart';

import 'package:flutter/material.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/view/product_details/producct_details_page.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';
import 'package:mushiya_beauty/widget/custom_filter.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';
import 'package:mushiya_beauty/widget/custom_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopify_flutter/mixins/src/shopify_error.dart';
import 'package:shopify_flutter/models/src/cart/inputs/attribute_input/attribute_input.dart';
import 'package:shopify_flutter/shopify_flutter.dart';
import 'package:svg_flutter/svg.dart';

void logCartInfo(Cart cart) {
  log('log => cart id: ${cart.id}');
  log('log => cart attributes: ${cart.attributes}');
  for (final line in cart.lines) {
    log('log => line attributes: ${line.attributes}');
  }
}

class AllProductsPage extends StatefulWidget {
  AllProductsPage({super.key, this.whichPage});

  final String? whichPage;

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  final ShopifyStore shopifyStore = ShopifyStore.instance;
  final ShopifyCart shopifyCart = ShopifyCart.instance;
  final HomeController controller = Get.put(HomeController());

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
        quantity: 1,
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
      log('addLineItemToCart ShopifyException: ${error.errors?[0]["message"]}');
      if (!mounted) return;
      context.showSnackBar(
        error.errors?[0]["message"] ?? 'Error adding item to cart',
      );
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
    return Scaffold(
      backgroundColor: primaryBlackColor,
      persistentFooterAlignment: AlignmentDirectional.centerEnd,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: MyAppBarWidget(
          title: widget.whichPage!.toUpperCase(),
          titleImage: true,
          actions: true,
          actionsWidget: null,
          leadingButton: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: CustomTextField(
                    hintText: "Search",
                    textEditingController: () {
                      controller.textController.addListener(() {
                        controller.updateSearchQuery(
                          controller.textController.text,
                        );
                      });
                      return controller.textController;
                    }(),
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
            const SizedBox(height: 24),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: whiteColor),
                  );
                }

                if (controller.errorMessage.isNotEmpty) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Connection time out please try again"),
                        MaterialButton(
                          onPressed: () {
                            controller.retryFetchProduct();
                          },
                          child: const Text("Retry"),
                          color: redColor,
                        ),
                      ],
                    ),
                  );
                }

                if (controller.filteredProducts.isEmpty) {
                  return const Center(child: Text("No products found"));
                }

                return GridView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.filteredProducts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    final product = controller.filteredProducts[index];
                    return GestureDetector(
                      onTap: () {
                        controller.selectedVariant.value =
                            product.variants.first;

                        controller.selectedVariant.value = null;
                        Get.to(
                          ProducctDetailsPage(
                            title: product.title.toString(),
                            homeModel: product,
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  product.mainImage == null
                                      ? 'https://cdn.shopify.com/s/files/1/1190/6424/files/Afro_Fusion.png?v=1733257065'
                                      : product.mainImage!.src,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
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
                              if (widget.whichPage == 'New' ||
                                  widget.whichPage == 'All Produccts' &&
                                      product.status == "active")
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color:
                                          widget.whichPage == 'All Produccts'
                                              ? greyColor
                                              : primaryBlackColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: CustomText(
                                      text:
                                          widget.whichPage == 'New'
                                              ? "New"
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
                              if (widget.whichPage == 'Sale' ||
                                  widget.whichPage == 'Clearance')
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: redColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: CustomText(
                                      text:
                                          widget.whichPage == 'Sale'
                                              ? "Sale"
                                              : "Sale",
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
                                child: GestureDetector(
                                  onTap: () => addLineItemToCart(product),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: whiteColor.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/icons_svg/cart_add_icon.svg',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          CustomText(
                            text: product.title.toString(),
                            fontSize: 14,
                            maxLines: 2,
                            fontFamily: "Roboto",
                            color: whiteColor,
                            fontWeight: FontWeight.w500,
                          ),
                          if (widget.whichPage == 'Sale' ||
                              widget.whichPage == 'Clearance')
                            CustomText(
                              text: "\$${product.variants.first.price}",
                              fontSize: 12,
                              maxLines: 1,
                              topPadding: 4,
                              fontFamily: "Roboto",
                              color: whiteColor,
                              decoration:
                                  widget.whichPage == 'Sale' ||
                                          widget.whichPage == 'Clearance'
                                      ? TextDecoration.lineThrough
                                      : null,
                              fontWeight: FontWeight.w400,
                            ),
                          CustomText(
                            text: "\$${product.variants.first.price}",
                            fontSize: 12,
                            maxLines: 1,
                            fontFamily: "Roboto",
                            topPadding: 2,
                            color:
                                widget.whichPage == 'Sale' ||
                                        widget.whichPage == 'Clearance'
                                    ? redColor
                                    : whiteColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortByFilter(BuildContext context) async {
    final result = await Get.dialog(SortByFilter(), barrierDismissible: true);
    if (result != null) {
      print('Selected sort: $result');
    }
  }
}
