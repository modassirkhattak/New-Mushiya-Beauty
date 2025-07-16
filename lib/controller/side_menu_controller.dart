import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:mushiya_beauty/controller/product_details_controller.dart';
import 'package:mushiya_beauty/model/side_menu_model.dart';
import 'package:mushiya_beauty/utills/api_controller.dart';
import 'package:mushiya_beauty/utills/services.dart';
import 'package:http/http.dart' as http;
import 'package:mushiya_beauty/view/product_details/search_product_details_page.dart';
import '../model/side_menu_collection_model.dart';
import '../new_app/screens/home_tab.dart';
import '../view/product_details/product_detail_screen.dart';
import 'home_controller.dart';

class SideMenuController extends GetxController {
  final ApiServices _menuService = ApiServices();

  final Rx<MenuResponse> _menuResponse = MenuResponse(menus: []).obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  MenuResponse get menuResponse => _menuResponse.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  Future<void> fetchMenus() async {
    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      final response = await _menuService.fetchMenus();
      _menuResponse.value = MenuResponse.fromJson(response);
      if (_menuResponse.value.error != null) {
        _errorMessage.value = _menuResponse.value.error!;
      }
    } catch (e) {
      _menuResponse.value = MenuResponse.withError(e.toString());
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  List<MenuModel> getMenusByHandle(String handle) {
    return _menuResponse.value.menus
        .where(
          (menu) => menu.handle.toLowerCase().contains(handle.toLowerCase()),
        )
        .toList();
  }

  @override
  void onInit() {
    fetchMenus();
    // fetchInitialProducts();
    super.onInit();
  }


  // side munu collection click
  RxBool isLoading2 = true.obs;
  RxList<ShopifyProduct> products = <ShopifyProduct>[].obs;
  String? endCursor;
  bool hasNextPage = true;
  bool isFetchingMore = false;


  void fetchInitialProducts({required String collectionId}) async {
    try {
      isLoading2(true);
      final result = await ApiServices.fetchBabyNapsProducts(collectionId: collectionId.toString());
      products.assignAll(result['products']);
      endCursor = result['endCursor'];
      hasNextPage = result['hasNextPage'];
    } finally {
      isLoading2(false);
    }
  }

  void loadMoreProducts({required String collectionId}) async {
    if (!hasNextPage || isFetchingMore) return;

    isFetchingMore = true;
    try {
      final result = await ApiServices.fetchBabyNapsProducts(cursor: endCursor, collectionId: collectionId.toString());
      products.addAll(result['products']);
      endCursor = result['endCursor'];
      hasNextPage = result['hasNextPage'];
    } finally {
      isFetchingMore = false;
    }
  }

  Future<void> refreshProducts({required String collectionId, required bool isProduct}) async {
    var headers = {
      'X-Shopify-Access-Token': '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',
      'Content-Type': 'application/json',
      // 'Cookie': '_master_udr=eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaEpJaWxqWkdNd1l6ZGxOaTB3TnpWa0xUUmpOMll0T1RjMU55MHpaR1F6WVdFeFpESXhaamdHT2daRlJnPT0iLCJleHAiOiIyMDI3LTA2LTE1VDA5OjI4OjUyLjM2NloiLCJwdXIiOiJjb29raWUuX21hc3Rlcl91ZHIifX0%3D--b59496ce250416b715e94156ac93408a9106b34a; _secure_admin_session_id=03d3dc7f6a1401b9d3ed26d95ca5d823; _secure_admin_session_id_csrf=03d3dc7f6a1401b9d3ed26d95ca5d823; _landing_page=%2Fapi%2Fadmin%2F2025-04%2Fgraphql.json; _orig_referrer=; _shopify_essential=:AZdnpi4GAAEA016_mfIidugcJGUIQgchBQazuRotTe1f0BMwawLt2rPjMd7r3B2pF8h2r8_qwqur0enEYRRXc_tOHsikwPH26VDppivuEj5ReQVVRPT-7OOcDs4ovFi6sRIKpQ5PCMsoZdjIBCdKgM0vpeLq703CfYVKJele7t94jHksxgvLZzCemenu7uRVOlmhzxkfYuxk3H4AAoXHQJEtJ1JlyhgvtBClnWf9FATrpEy5qq9UvL5eSPapeW5TYJpiRRE5YjHLnwRZIM_8kuO5Rc9IvVebsgCAKf1ViGLTz-3ENdbIqVH72F-18gaY4FNLdGXb7gTXkD3QtyP2XR3_Dvnfwztj6Q:; _shopify_y=95777da9-a312-47fb-bdd7-bd27eed5698e; _tracking_consent=3.AMPS_USVA_f_f_-DlBBsijT9252dNjR-wT4w; cart=Z2NwLXVzLWVhc3QxOjAxSlhLSlo2Mk5TS0VWRFRINldaRFAwWTc4%3Fkey%3D87b9ebd20dd6af1e7e1eb70caa8aed85; cart_currency=USD; cart_sig=48550588996a1edd338320c26420567c; localization=US'
    };
    var request = http.Request('POST', Uri.parse('https://runwaycurls.myshopify.com/admin/api/2025-04/graphql.json'));
    request.body = json.encode({
      "query": "query { collectionByHandle(handle: \"$collectionId\") { id handle title } }"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());

      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody)['data']['collectionByHandle'];

      print(data['id']);
      Get.put(
        ShopifyProductController(),
      ).fetchAllProductsFromCollection(
          data['id']
        // isLoadMore: false,
      );
      Get.to(
        HomeTab(
          whichPage:  data['title'],
        ),
      );

      // print(data['data']['productByHandle']['id']);
    }
    else {
      print(response.reasonPhrase);
    }

    /*var headers = {
      'X-Shopify-Access-Token': ADMIN_TOKEN,
      'Content-Type': 'application/json',
    };
    var request = http.Request('POST', Uri.parse('https://runwaycurls.myshopify.com/admin/api/2025-04/graphql.json'));
    if(isProduct==true){
      request.body = json.encode({
        "query": "query { productByHandle(handle: \"$collectionId\") { id title } }"
      });
    }else{
      request.body = json.encode({
        "query": "query { collectionByHandle(handle: \"$collectionId\") { id handle title } }"
      });
    }

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      if(isProduct==true){
        final data = jsonDecode(responseBody);
        print(data['data']['productByHandle']['id']);
        final id= data['data']['productByHandle']['id'];
        print("......${id}");
        String gid = id;
        String numericId = gid.split('/').last;
        Get.put(
          ProductDetailsController(),
        ).fetchProduct(int.parse(numericId));
        Get.put(HomeController())
            .selectedVariant
            .value = null;
        // Get.to(ProductDetailScreen(product: product))
        final controller = Get.put(ProductDetailScreen(title: data['data']['productByHandle']['title'],product: product));
        controller;
        Get.to(ProductDetailScreen(product: product,title: product.title.toString()));
      }else{
        final data = jsonDecode(responseBody);
        print(data['data']['collectionByHandle']['id']);
        final id= data['data']['collectionByHandle']['id'];

        print(id);
        Get.put(
          ShopifyProductController(),
        ).fetchAllProductsFromCollection(
          id,
          // isLoadMore: false,
        );
        Get.to(
          HomeTab(
            whichPage:  data['data']['collectionByHandle']['title'],
          ),
        );
        print(data);


        // print(response.stream);
        print(await response.stream.bytesToString());
      }
    }
    else {
    print(response.reasonPhrase);
    }
*/
  }

  Future<void> refreshProductsCollect({required String collectionId, required bool isProduct}) async {
    var headers = {
      'X-Shopify-Access-Token': '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',
      'Content-Type': 'application/json',
      // 'Cookie': '_master_udr=eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaEpJaWxqWkdNd1l6ZGxOaTB3TnpWa0xUUmpOMll0T1RjMU55MHpaR1F6WVdFeFpESXhaamdHT2daRlJnPT0iLCJleHAiOiIyMDI3LTA2LTE1VDA5OjI4OjUyLjM2NloiLCJwdXIiOiJjb29raWUuX21hc3Rlcl91ZHIifX0%3D--b59496ce250416b715e94156ac93408a9106b34a; _secure_admin_session_id=03d3dc7f6a1401b9d3ed26d95ca5d823; _secure_admin_session_id_csrf=03d3dc7f6a1401b9d3ed26d95ca5d823; _landing_page=%2Fapi%2Fadmin%2F2025-04%2Fgraphql.json; _orig_referrer=; _shopify_essential=:AZdnpi4GAAEA016_mfIidugcJGUIQgchBQazuRotTe1f0BMwawLt2rPjMd7r3B2pF8h2r8_qwqur0enEYRRXc_tOHsikwPH26VDppivuEj5ReQVVRPT-7OOcDs4ovFi6sRIKpQ5PCMsoZdjIBCdKgM0vpeLq703CfYVKJele7t94jHksxgvLZzCemenu7uRVOlmhzxkfYuxk3H4AAoXHQJEtJ1JlyhgvtBClnWf9FATrpEy5qq9UvL5eSPapeW5TYJpiRRE5YjHLnwRZIM_8kuO5Rc9IvVebsgCAKf1ViGLTz-3ENdbIqVH72F-18gaY4FNLdGXb7gTXkD3QtyP2XR3_Dvnfwztj6Q:; _shopify_y=95777da9-a312-47fb-bdd7-bd27eed5698e; _tracking_consent=3.AMPS_USVA_f_f_-DlBBsijT9252dNjR-wT4w; cart=Z2NwLXVzLWVhc3QxOjAxSlhLSlo2Mk5TS0VWRFRINldaRFAwWTc4%3Fkey%3D87b9ebd20dd6af1e7e1eb70caa8aed85; cart_currency=USD; cart_sig=48550588996a1edd338320c26420567c; localization=US'
    };
    var request = http.Request('POST', Uri.parse('https://runwaycurls.myshopify.com/admin/api/2025-04/graphql.json'));
    request.body = json.encode({

        "query": "query { productByHandle(handle: \"premium-passion-twists\") { id title } }"
          });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());

      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody)['data']['productByHandle'];

      String gid = data['id'];
      String numericId = gid.split('/').last;
      Get.put(
        ProductDetailsController(),
      ).fetchProduct(int.parse(numericId));
      Get.put(HomeController())
          .selectedVariant
          .value = null;
      // Get.to(ProductDetailScreen(product: product))
      // final controller = Get.put(ProductDetailScreen().fe);
      // controller;
      Get.to(ProductDetailScreenDrawer(productId: data['id'],title:  data['title'].toString()));
      // Get.put(
      //   ShopifyProductController(),
      // ).fetchAllProductsFromCollection(
      //     data['id']
      //   // isLoadMore: false,
      // );
      // Get.to(
      //   HomeTab(
      //     whichPage:  data['title'],
      //   ),
      // );

      // print(data['data']['productByHandle']['id']);
    }
    else {
      print(response.reasonPhrase);
    }

    /*var headers = {
      'X-Shopify-Access-Token': ADMIN_TOKEN,
      'Content-Type': 'application/json',
    };
    var request = http.Request('POST', Uri.parse('https://runwaycurls.myshopify.com/admin/api/2025-04/graphql.json'));
    if(isProduct==true){
      request.body = json.encode({
        "query": "query { productByHandle(handle: \"$collectionId\") { id title } }"
      });
    }else{
      request.body = json.encode({
        "query": "query { collectionByHandle(handle: \"$collectionId\") { id handle title } }"
      });
    }

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      if(isProduct==true){
        final data = jsonDecode(responseBody);
        print(data['data']['productByHandle']['id']);
        final id= data['data']['productByHandle']['id'];
        print("......${id}");
        String gid = id;
        String numericId = gid.split('/').last;
        Get.put(
          ProductDetailsController(),
        ).fetchProduct(int.parse(numericId));
        Get.put(HomeController())
            .selectedVariant
            .value = null;
        // Get.to(ProductDetailScreen(product: product))
        final controller = Get.put(ProductDetailScreen(title: data['data']['productByHandle']['title'],product: product));
        controller;
        Get.to(ProductDetailScreen(product: product,title: product.title.toString()));
      }else{
        final data = jsonDecode(responseBody);
        print(data['data']['collectionByHandle']['id']);
        final id= data['data']['collectionByHandle']['id'];

        print(id);
        Get.put(
          ShopifyProductController(),
        ).fetchAllProductsFromCollection(
          id,
          // isLoadMore: false,
        );
        Get.to(
          HomeTab(
            whichPage:  data['data']['collectionByHandle']['title'],
          ),
        );
        print(data);


        // print(response.stream);
        print(await response.stream.bytesToString());
      }
    }
    else {
    print(response.reasonPhrase);
    }
*/
  }
}
