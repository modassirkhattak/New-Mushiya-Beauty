import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/widget/custom_textfield.dart';
import 'package:shopify_flutter/shopify_flutter.dart';
import '../../controller/home_controller.dart';
import '../../controller/product_details_controller.dart';
import '../../view/product_details/best_seller_details.dart';
import '../../view/product_details/search_product_details_page.dart';
import '../../widget/custom_appbar.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  SearchTabState createState() => SearchTabState();
}

class SearchTabState extends State<SearchTab> {
  final _controller = TextEditingController(text: '');
  List<Product> products = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: MyAppBarWidget(
          title: 'Search Products'.toUpperCase(),
          titleImage: true,
          actions: true,
          actionsWidget: null,
          leadingButton: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: CustomTextField(
                    textEditingController: _controller,
                    hintText: 'Search...',
                    fillColor: whiteColor,
                    textColor: primaryBlackColor,
                    borderColor: Colors.white,
                    height: 40,
                  ),
                ),
                IconButton(
                  icon: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.search, color: primaryBlackColor),
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    _searchForProduct(_controller.text);
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            _isLoading
                ? const Expanded(
              child: Center(child: CircularProgressIndicator(color: Colors.white,)),
            )
                : products.length == 0 ? const Expanded(child: Center(child: Text('No products found', style: TextStyle(color: Colors.white),))) : Expanded(
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return _buildProductItem(product);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _searchForProduct(String searchKeyword) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final shopifyStore = ShopifyStore.instance;
      final results = await shopifyStore.searchProducts(searchKeyword, limit: 10);
      if (mounted) {
        setState(() {
          products = results ?? [];
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildProductItem(Product product) {

    return GestureDetector(
      onTap: (){
        print("......${product.id}");
        String gid =
            product.id;
        String numericId = gid.split('/').last;
        Get.put(
          ProductDetailsController(),
        ).fetchProduct(int.parse(numericId));
        Get.put(HomeController()).selectedVariant.value = null;
        Get.to(
          SearchProductDetailsPage(
            homeModel: product,
            title:
            product.title,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.id != null)
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Text(
              product.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              product.formattedPrice,
              style: const TextStyle(
                color: whiteColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
