import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/model/booked_event_model.dart';
import 'package:mushiya_beauty/model/order_model.dart';
import 'package:mushiya_beauty/utills/services.dart';
import 'package:mushiya_beauty/view/orders_history/order_details_page.dart';

class OrderHistoryController extends GetxController {
  final RxInt _mainTab =
      0.obs; // 0: Order History, 1: Salon Booking, 2: Event Booking
  final RxInt _subTab = 0.obs; // 0: Active, 1: Completed
  final RxList<Map<String, dynamic>> _orders = <Map<String, dynamic>>[].obs;

  int get mainTab => _mainTab.value;
  int get subTab => _subTab.value;
  List<Map<String, dynamic>> get orders {
    return _orders.where((order) {
      final isCorrectCategory =
          order['category'] == _mainTabToCategory(mainTab);
      final isCorrectStatus =
          subTab == 0
              ? order['status'] == 'active'
              : order['status'] == 'completed';
      return isCorrectCategory && isCorrectStatus;
    }).toList();
  }

  String _mainTabToCategory(int tab) {
    switch (tab) {
      case 0:
        return 'order';
      case 1:
        return 'salon';
      case 2:
        return 'event';
      default:
        return 'order';
    }
  }

  @override
  void onInit() {
    fetchOrders();
    fetchBookedEvents();
    super.onInit();
    // Simulate initial order data with categories and statuses
    _orders.assignAll([
      // Order History
      {
        'id': '1234',
        'name': 'new year city 3',
        'price': '\$600',
        'items': 3,
        'date': '6/6/2024',
        'status': 'active',
        'category': 'order',
        'image': 'assets/extra_images/girl_2.png',
      },
      {
        'id': '1234',
        'name': 'new year city',
        'price': '\$600',
        'items': 3,
        'date': '6/6/2024',
        'status': 'active',
        'category': 'order',
        'image': 'assets/extra_images/girl_2.png',
      },
      {
        'id': '1234',
        'name': 'City Afro',
        'price': '\$600',
        'items': 3,
        'date': '6/6/2024',
        'status': 'active',
        'category': 'order',
        'image': 'assets/extra_images/girl_2.png',
      },
      {
        'id': '1234',
        'name': 'City Afro complete',
        'price': '\$400',
        'items': 3,
        'date': '6/6/2024',
        'status': 'completed',
        'category': 'order',
        'image': 'assets/extra_images/girl_2.png',
      },
      {
        'id': '1235',
        'name': 'City Afro',
        'price': '\$400',
        'items': 3,
        'date': '5/23/2025',
        'status': 'active',
        'category': 'order',
        'image': 'assets/extra_images/girl_2.png',
      },
      // Salon Booking
      {
        'id': '5678',
        'name': 'Salon Service',
        'price': '\$150',
        'items': 1,
        'date': '5/22/2025',
        'status': 'active',
        'category': 'salon',
        'image': 'assets/extra_images/girl_2.png',
      },
      {
        'id': '5679',
        'name': 'Salon Service',
        'price': '\$150',
        'items': 1,
        'date': '5/20/2025',
        'status': 'completed',
        'category': 'salon',
        'image': 'assets/extra_images/girl_2.png',
      },
      // Event Booking
      {
        'id': '9012',
        'name': 'Event Ticket',
        'price': '\$200',
        'items': 2,
        'date': '5/25/2025',
        'status': 'active',
        'category': 'event',
        'image': 'assets/extra_images/girl_2.png',
      },
      {
        'id': '9013',
        'name': 'Event Ticket',
        'price': '\$200',
        'items': 2,
        'date': '5/21/2025',
        'status': 'completed',
        'category': 'event',
        'image': 'assets/extra_images/girl_2.png',
      },
    ]);
  }

  void setMainTab(int index) {
    _mainTab.value = index;
  }

  void setSubTab(int index) {
    _subTab.value = index;
  }

  void viewDetails(OrderModel order, {required String tag}) {
    if (tag == '') {
      Get.to(() => OrderDetailsPage(order: order, title: "Order Summary"));
    } else if (tag == 'salon') {
      // Get.to(
      // () => SaloonBookingDetailsPage(order: order, title: "Salon bookings"),
      // );
    } else if (tag == 'event') {
      // Get.to(() => EventBookDetailsPage(order: order, title: "Event bookings"));
    }
    // Get.to(() => OrderDetailScreen(order: order));
  }

  /// dynamic setting api calling backend work
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  final Rx<OrderResponse?> orderResponse = Rx<OrderResponse?>(
    null,
  ); // Store full OrderResponse

  // Getter for orders list
  List<OrderModel> get ordersModel => orderResponse.value?.orders ?? [];

  Future<void> fetchOrders() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await ApiServices().fetchOrders();
      orderResponse.value = response; // Store the full OrderResponse
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void retryFetchOrders() {
    fetchOrders();
  }

  RxList<BookedEventModel> bookedEvents = <BookedEventModel>[].obs;

  void fetchBookedEvents() {
    FirebaseFirestore.instance
        .collection('BookedEvents')
        .orderBy('booked_by_name')
        .snapshots()
        .listen((snapshot) {
          final data =
              snapshot.docs
                  .map((doc) => BookedEventModel.fromSnapshot(doc))
                  .toList();
          bookedEvents.assignAll(data);
        });
  }
}
