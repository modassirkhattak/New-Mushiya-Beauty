import 'package:mushiya_beauty/new_app//screens/cart_tab.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shopify_flutter/shopify_flutter.dart';

import '../view/home/home_page.dart';
import 'screens/auth_tab.dart';
import 'screens/blog_tab.dart';
import 'screens/collection_tab.dart';
import 'screens/home_tab.dart';
import 'screens/shop_tab.dart';
import 'screens/search_tab.dart';
// import 'screens/checkout_page.dart';
import 'screens/orders_tab.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  List<Widget> tabs = [
    HomePage2(),
     // HomeTab(),
    const CollectionTab(),
    const SearchTab(),
    const ShopTab(),
    const BlogTab(),
    // const CheckoutPage(),
    const CartTab(),
    const OrdersTab(),
    const AuthTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: tabs),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavigationBarItemClick,
        fixedColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home2'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Collections',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.shopify), label: 'Shop'),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online_outlined),
            label: 'Blog',
          ),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.checkroom_outlined), label: 'Checkout'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.login), label: 'Login'),
        ],
      ),
    );
  }

  void _onNavigationBarItemClick(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
