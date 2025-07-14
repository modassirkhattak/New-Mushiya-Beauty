import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartItem {
  final String id;
  final String name;
  final String image;
  final String bookedDate;
  final String timeSlot;
  final double price;
  late int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.image,
    required this.bookedDate,
    required this.price,
    required this.quantity,
    required this.timeSlot,
  });

  // Convert CartItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'bookedDate': bookedDate,
      'price': price,
      'timeSlot': timeSlot,
      'quantity': quantity,
    };
  }

  // Create CartItem from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      bookedDate: json['bookedDate'],
      timeSlot: json['timeSlot'],
      price: json['price'],
      quantity: json['quantity'],
    );
  }
}

class CartSaloonController extends GetxController {
  var cartItems = <CartItem>[].obs;

  void addToCart(CartItem item) {
    // Find the index of the item with the same ID and bookedDate
    int index = cartItems.indexWhere((cartItem) =>
    cartItem.id == item.id );

    if (index != -1) {
      // If the item exists, update its details
      cartItems[index] = item; // Replace the existing item with the new item
    } else {
      // If the item doesn't exist, add it as a new entry
      cartItems.add(item);
    }

    cartItems.refresh(); // Notify listeners about the change
    saveCartToPrefs(); // Save the updated cart to shared preferences
  }

  // Remove item from the cart
  void removeFromCart(String id) {
    cartItems.removeWhere((item) => item.id == id);
    saveCartToPrefs();
  }

  // Update quantity
  void updateQuantity(String id, String bookedDate, int newQuantity) {
    int index = cartItems.indexWhere((item) => item.id == id && item.bookedDate == bookedDate);
    if (index != -1) {
      if (newQuantity > 0) {
        cartItems[index].quantity = newQuantity;
      } else {
        cartItems.removeAt(index);
      }
      cartItems.refresh();
      saveCartToPrefs();
    }
  }


  // Get total price
  double get totalPrice {
    return cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Save cart data to Shared Preferences
  Future<void> saveCartToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = cartItems.map((item) => item.toJson()).toList();
    await prefs.setString('cartData', jsonEncode(cartData));
  }

  // Load cart data from Shared Preferences
  Future<void> loadCartFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('cartData');
    if (cartData != null) {
      final List<dynamic> data = jsonDecode(cartData);
      cartItems.value = data.map((item) => CartItem.fromJson(item)).toList();
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadCartFromPrefs(); // Load cart data when the controller is initialized
  }
}