import 'dart:developer';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mushiya_beauty/new_app/constants.dart';
import 'package:mushiya_beauty/new_app/extension.dart';
import 'package:mushiya_beauty/new_app/screens/checkout_webview.dart';
import 'package:flutter/material.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';

import 'package:mushiya_beauty/widget/custom_appbar.dart';
import 'package:mushiya_beauty/widget/custom_button.dart';

import 'package:mushiya_beauty/widget/custom_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopify_flutter/mixins/src/shopify_error.dart';
import 'package:shopify_flutter/models/src/cart/inputs/attribute_input/attribute_input.dart';
import 'package:shopify_flutter/shopify_flutter.dart';

void logCartInfo(Cart cart) {
  log('log => cart id: ${cart.id}');
  log('log => cart attributes: ${cart.attributes}');
  for (final line in cart.lines) {
    log('log => line attributes: ${line.attributes}');
  }
}

class CartInfo extends StatefulWidget {
  const CartInfo({super.key});

  @override
  State<CartInfo> createState() => _CartInfoState();
}

class _CartInfoState extends State<CartInfo> {
  final ShopifyCart shopifyCart = ShopifyCart.instance;
  final TextEditingController noteCtrl = TextEditingController();
  Cart? cart;

  @override
  void initState() {
    super.initState();
    loadOrCreateCart();
  }

  Future<void> loadOrCreateCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartId = prefs.getString('cart_id');

      if (cartId != null) {
        try {
          final cartResponse = await shopifyCart.getCartById(cartId);
          setState(() {
            cart = cartResponse;
            noteCtrl.text = cart?.note ?? '';
          });
          logCartInfo(cart!);
        } on ShopifyException catch (error) {
          log('getCartById ShopifyException: $error');
          await createCart();
        }
      } else {
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
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cart_id', newCart.id);
      setState(() {
        cart = newCart;
        noteCtrl.text = cart?.note ?? '';
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
        noteCtrl.text = cart?.note ?? '';
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

  void removeLineItemFromCart(String lineId) async {
    try {
      if (!lineId.startsWith('gid://shopify/CartLine/')) {
        context.showSnackBar('Invalid lineId');
        log('Invalid lineId: $lineId');
        return;
      }
      final updatedCart = await shopifyCart.removeLineItemsFromCart(
        cartId: cart!.id,
        lineIds: [lineId],
      );
      setState(() {
        cart = updatedCart;
      });
      if (!mounted) return;
      context.showSnackBar('Removed item from cart');
    } on ShopifyException catch (error) {
      log('removeLineItemFromCart ShopifyException: $error');
      context.showSnackBar(
        error.errors?[0]["message"] ?? 'Error removing item from cart',
      );
    } catch (error) {
      log('removeLineItemFromCart Error: $error');
    }
  }

  void onCartItemUpdate(Line line, {bool increment = true}) async {
    try {
      int quantity = line.quantity ?? 0;
      if (!increment && quantity <= 0) {
        context.showSnackBar('Cannot reduce quantity below 0');
        return;
      }
      quantity = increment ? quantity + 1 : quantity - 1;

      String merchandiseId = line.variantId ?? '';
      if (!merchandiseId.startsWith('gid://shopify/ProductVariant/')) {
        merchandiseId = 'gid://shopify/ProductVariant/$merchandiseId';
      }

      final cartLineInput = CartLineUpdateInput(
        id: "${line.id}",
        quantity: quantity,
        merchandiseId: merchandiseId,
        attributes: [
          AttributeInput(key: 'color', value: 'blue'),
          AttributeInput(key: 'Misc', value: '1'),
        ],
      );
      final updatedCart = await shopifyCart.updateLineItemsInCart(
        cartId: cart!.id,
        cartLineInputs: [cartLineInput],
      );
      setState(() {
        cart = updatedCart;
      });
      if (!mounted) return;
      // context.showSnackBar('Updated item in cart');
    } on ShopifyException catch (error) {
      log('onCartItemUpdate ShopifyException: ${error.errors?[0]["message"]}');
      context.showSnackBar(
        error.errors?[0]["message"] ?? 'Error updating cart',
      );
    } catch (error) {
      log('onCartItemUpdate Error: $error');
    }
  }

  void updateCartNote() async {
    try {
      final updatedCart = await shopifyCart.updateNoteInCart(
        cartId: cart!.id,
        note: noteCtrl.text.trim(),
      );
      setState(() {
        cart = updatedCart;
      });
      if (!mounted) return;
      context.showSnackBar('Updated cart note');
    } catch (error) {
      log('updateCartNote Error: $error');
      if (!mounted) return;
      context.showSnackBar('Error updating cart note');
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

  // Calculate subtotal
  double _calculateSubtotal() {
    if (cart == null || cart!.lines.isEmpty) return 0.00;
    double subtotal = 0.0;
    for (final line in cart!.lines) {
      final merchandise = line.merchandise;
      if (merchandise != null) {
        subtotal += merchandise.price.amount * (line.quantity ?? 0);
      }
    }
    return double.parse(subtotal.toStringAsFixed(2));
  }

  // Calculate total (assuming no taxes/shipping for now)
  double _calculateTotal() {
    // If Cart has totalCost or similar, use it here
    // For now, return subtotal
    return _calculateSubtotal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: MyAppBarWidget(
          title: 'Cart'.toUpperCase(),
          titleImage: true,
          actions: true,
          actionsWidget: null,
          leadingButton: true,
        ),
      ),
      body:  /*cart!.lines.isEmpty
          ? const Center(
        child: CustomText(
          text: "Your cart is empty",
          fontSize: 14,
          maxLines: 2,
          color: Colors.white,
          fontFamily: "Roboto",
          fontWeight: FontWeight.w500,
        ), // Text('Your cart is empty'),
      ):*/ Padding(
        padding: const EdgeInsets.only(
          top: 16.0,
          right: 16.0,
          left: 16.0,
          bottom: 16.0,
        ),

        child:  SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          width: double.infinity,
          child:
              cart == null
                  ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                  : cart!.lines.isEmpty? const Center(
                child: CustomText(
                  text: "Your cart is empty",
                  fontSize: 14,
                  maxLines: 2,
                  color: Colors.white,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w500,
                ), // Text('Your cart is empty'),
              ):Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 7,
                        child:
                            cart!.lines.isEmpty
                                ? const Center(
                                  child: CustomText(
                                    text: "Your cart is empty",
                                    fontSize: 14,
                                    maxLines: 2,
                                    color: Colors.white,
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.w500,
                                  ), // Text('Your cart is empty'),
                                )
                                : SingleChildScrollView(
                                  child: Column(
                                    children: cart!.lines.map((line) {
                                      final merchandise = line.merchandise;
                                      if (merchandise == null) return const SizedBox();

                                      return Container(
                                        margin: const EdgeInsets.only(bottom: 24.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Slidable(
                                          key: ValueKey(line.id),
                                          endActionPane: ActionPane(
                                            motion: const ScrollMotion(),
                                            extentRatio: 0.25,
                                            children: [

                                              SlidableAction(

                                                onPressed: (context) => removeLineItemFromCart("${line.id}"),
                                                backgroundColor: Colors.red,
                                                foregroundColor: Colors.white,
                                                icon: Icons.delete,
                                                label: 'Delete',
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ],
                                          ),
                                          child: Container(
                                            // margin: const EdgeInsets.only(bottom: 24.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Image.network(
                                                  merchandise.product?.image.toString() ?? '',
                                                  height: 75,
                                                  width: 88,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) => Image.asset(
                                                    'assets/extra_images/product_placeholder.png',
                                                    height: 75,
                                                    width: 88,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  flex: 3,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      CustomText(
                                                        text: merchandise.product?.title ?? merchandise.title,
                                                        fontSize: 14,
                                                        maxLines: 2,
                                                        fontFamily: "Roboto",
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(6),
                                                          border: Border.all(
                                                            color: primaryBlackColor,
                                                            width: 0.8,
                                                          ),
                                                        ),
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () => onCartItemUpdate(line, increment: false),
                                                              child: Icon(Icons.remove, color: primaryBlackColor, size: 11),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                                              child: CustomText(
                                                                text: line.quantity.toString(),
                                                                fontSize: 14,
                                                                fontFamily: 'Roboto',
                                                                color: primaryBlackColor,
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () => onCartItemUpdate(line),
                                                              child: Icon(Icons.add, color: primaryBlackColor, size: 11),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                CustomText(
                                                  text: '\$${merchandise.price.amount.toStringAsFixed(2)}',
                                                  fontSize: 18,
                                                  fontFamily: "Archivo",
                                                  color: primaryBlackColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),

                            ),
                      ),
                      // const Spacer(),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          CustomText(
                            text: "Sub total (${cart!.lines.length} items)",
                            fontSize: 14,
                            fontFamily: "Roboto",
                            color: whiteColor.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                          const Spacer(),
                          CustomText(
                            text: '\$${_calculateSubtotal()}',
                            fontSize: 18,
                            fontFamily: "Archivo",
                            color: whiteColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Divider(height: 0.1, color: whiteColor, thickness: 0.2),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          CustomText(
                            text: "Total",
                            fontSize: 14,
                            fontFamily: "Roboto",
                            color: whiteColor,
                            fontWeight: FontWeight.w500,
                          ),
                          const Spacer(),
                          CustomText(
                            text: '\$${_calculateTotal()}',
                            fontSize: 18,
                            fontFamily: "Archivo",
                            color: whiteColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      CustomButton(
                        text: "Checkout".toUpperCase(),
                        onPressed: onCheckoutTap,
                        backgroundColor: whiteColor,
                        minWidth: double.infinity,
                        textColor: primaryBlackColor,
                        fontSize: 16,
                        height: 48,
                        fontWeight: FontWeight.w600,
                      ),
                      // const SizedBox(height: 20),
                    ],
                  ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    noteCtrl.dispose();
    super.dispose();
  }
}
