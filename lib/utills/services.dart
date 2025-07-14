import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:mushiya_beauty/controller/profile_controller.dart';
import 'package:mushiya_beauty/model/article_model.dart';
import 'package:mushiya_beauty/model/best_selling_product_model.dart';
import 'package:mushiya_beauty/model/blog_model.dart';
import 'package:mushiya_beauty/model/cart_item_model.dart';
import 'package:mushiya_beauty/model/collection_sub_product_model.dart';
import 'package:mushiya_beauty/model/custom_collection_model.dart';
import 'package:mushiya_beauty/model/customer_model.dart';
import 'package:mushiya_beauty/model/order_model.dart';
import 'package:mushiya_beauty/model/policy_model.dart';
import 'package:mushiya_beauty/model/product_model.dart';
import 'package:mushiya_beauty/model/side_menu_model.dart';
import 'package:mushiya_beauty/model/teeth_service_model.dart';
import 'package:mushiya_beauty/model/update_customer_mdoel.dart';
import 'package:mushiya_beauty/utills/api_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

import '../controller/home_controller.dart';
import '../controller/product_details_controller.dart';
import '../model/side_menu_collection_model.dart';
import '../view/product_details/best_seller_details.dart';

class ApiServices {
  // Check internet connectivity
  Future<bool> _isConnected() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        throw Exception('No internet connection');
      }
      return true;
    } catch (e) {
      developer.log('Connectivity check failed: $e', name: 'ApiServices');
      throw Exception('Failed to check internet connection: $e');
    }
  }

  // Blogs API call with BlogModel
  static Future<List<BlogModel>> fetchBlogs() async {
    const String url = BASE_URL + BLOGS_ALL;

    try {
      await ApiServices()._isConnected(); // Check connectivity
      final response = await http
          .get(Uri.parse(url), headers: headerApi)
          .timeout(const Duration(minutes: 1));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['blogs'] == null) {
          throw Exception('No blogs found in response');
        }
        final List blogsJson = data['blogs'];
        return blogsJson.map((e) => BlogModel.fromJson(e)).toList();
      } else {
        throw HttpException(
          'Server error: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } on SocketException catch (e) {
      developer.log('Network error in fetchBlogs: $e', name: 'ApiServices');
      throw Exception('Network error: Unable to reach the server');
    } on TimeoutException catch (e) {
      developer.log('Timeout in fetchBlogs: $e', name: 'ApiServices');
      throw Exception('Request timed out');
    } on FormatException catch (e) {
      developer.log(
        'Invalid response format in fetchBlogs: $e',
        name: 'ApiServices',
      );
      throw Exception('Invalid response format');
    } catch (e) {
      developer.log('Unexpected error in fetchBlogs: $e', name: 'ApiServices');
      throw Exception('Failed to load blogs: $e');
    }
  }

  // Home page all products API call
  Future<ProductResponse> fetchProducts() async {
    try {
      await _isConnected();
      final url = Uri.parse(BASE_URL + PRODUCTS_URL);
      final response = await http
          .get(url, headers: headerApi)
          .timeout(const Duration(minutes: 1));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData == null) {
          throw Exception('Empty response from server');
        }
        return ProductResponse.fromJson(jsonData);
      } else {
        throw HttpException(
          'Server error: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } on SocketException catch (e) {
      developer.log('Network error in fetchProducts: $e', name: 'ApiServices');
      throw Exception('Network error: Unable to reach the server');
    } on TimeoutException catch (e) {
      developer.log('Timeout in fetchProducts: $e', name: 'ApiServices');
      throw Exception('Request timed out');
    } on FormatException catch (e) {
      developer.log(
        'Invalid response format in fetchProducts: $e',
        name: 'ApiServices',
      );
      throw Exception('Invalid response format');
    } catch (e) {
      developer.log(
        'Unexpected error in fetchProducts: $e',
        name: 'ApiServices',
      );
      throw Exception('Failed to load products: $e');
    }
  }

  // Privacy policy API call
  Future<PolicyResponse> fetchPolicies() async {
    try {
      await _isConnected();
      final response = await http
          .get(Uri.parse(BASE_URL + PRIVACY_POLICY), headers: headerApi)
          .timeout(const Duration(minutes: 1));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData == null) {
          throw Exception('Empty response from server');
        }
        return PolicyResponse.fromJson(jsonData);
      } else {
        throw HttpException(
          'Server error: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } on SocketException catch (e) {
      developer.log('Network error in fetchPolicies: $e', name: 'ApiServices');
      throw Exception('Network error: Unable to reach the server');
    } on TimeoutException catch (e) {
      developer.log('Timeout in fetchPolicies: $e', name: 'ApiServices');
      throw Exception('Request timed out');
    } on FormatException catch (e) {
      developer.log(
        'Invalid response format in fetchPolicies: $e',
        name: 'ApiServices',
      );
      throw Exception('Invalid response format');
    } catch (e) {
      developer.log(
        'Unexpected error in fetchPolicies: $e',
        name: 'ApiServices',
      );
      throw Exception('Failed to load policies: $e');
    }
  }

  // Blog details API call
  Future<ArticleResponse> fetchArticles(String blogID) async {
    try {
      await _isConnected();
      final response = await http
          .get(
            Uri.parse("${BASE_URL}blogs/$blogID/$ARTICLES_URL"),
            headers: headerApi,
          )
          .timeout(const Duration(minutes: 1));

      developer.log(
        'Request URL: ${BASE_URL}blogs/$blogID/$ARTICLES_URL',
        name: 'ApiServices',
      );
      developer.log('Response: ${response.body}', name: 'ApiServices');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData == null) {
          throw Exception('Empty response from server');
        }
        return ArticleResponse.fromJson(jsonData);
      } else {
        throw HttpException(
          'Server error: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } on SocketException catch (e) {
      developer.log('Network error in fetchArticles: $e', name: 'ApiServices');
      throw Exception('Network error: Unable to reach the server');
    } on TimeoutException catch (e) {
      developer.log('Timeout in fetchArticles: $e', name: 'ApiServices');
      throw Exception('Request timed out');
    } on FormatException catch (e) {
      developer.log(
        'Invalid response format in fetchArticles: $e',
        name: 'ApiServices',
      );
      throw Exception('Invalid response format');
    } catch (e) {
      developer.log(
        'Unexpected error in fetchArticles: $e',
        name: 'ApiServices',
      );
      throw Exception('Failed to load articles: $e');
    }
  }

  // Fetch cart API call
  Future<CartModel> fetchCart() async {
    try {
      await _isConnected();
      final response = await http
          .get(
            Uri.parse('https://runwaycurls.myshopify.com/cart.js'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(minutes: 1));

      developer.log('Cart Response: ${response.body}', name: 'ApiServices');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData == null) {
          throw Exception('Empty response from server');
        }
        return CartModel.fromJson(jsonData);
      } else {
        developer.log(
          'Cart fetch error: ${response.statusCode} - ${response.reasonPhrase}',
          name: 'ApiServices',
        );
        throw HttpException(
          'Failed to load cart: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } on SocketException catch (e) {
      developer.log('Network error in fetchCart: $e', name: 'ApiServices');
      throw Exception('Network error: Unable to reach the server');
    } on TimeoutException catch (e) {
      developer.log('Timeout in fetchCart: $e', name: 'ApiServices');
      throw Exception('Request timed out');
    } on FormatException catch (e) {
      developer.log(
        'Invalid response format in fetchCart: $e',
        name: 'ApiServices',
      );
      throw Exception('Invalid response format');
    } catch (e) {
      developer.log('Unexpected error in fetchCart: $e', name: 'ApiServices');
      throw Exception('Failed to load cart: $e');
    }
  }

  // Add to cart API call
  Future<CartModel> addToCartApi({
    required int variantId,
    required int quantity,
  }) async {
    try {
      await _isConnected();
      final response = await http
          .post(
            Uri.parse(CART_URL),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({"id": variantId, "quantity": quantity}),
          )
          .timeout(const Duration(minutes: 1));

      developer.log(
        'Add to cart response: ${response.body}',
        name: 'ApiServices',
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData == null) {
          throw Exception('Empty response from server');
        }
        return CartModel.fromJson(jsonData);
      } else {
        throw HttpException(
          'Failed to add to cart: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } on SocketException catch (e) {
      developer.log('Network error in addToCartApi: $e', name: 'ApiServices');
      throw Exception('Network error: Unable to reach the server');
    } on TimeoutException catch (e) {
      developer.log('Timeout in addToCartApi: $e', name: 'ApiServices');
      throw Exception('Request timed out');
    } on FormatException catch (e) {
      developer.log(
        'Invalid response format in addToCartApi: $e',
        name: 'ApiServices',
      );
      throw Exception('Invalid response format');
    } catch (e) {
      developer.log(
        'Unexpected error in addToCartApi: $e',
        name: 'ApiServices',
      );
      throw Exception('Failed to add to cart: $e');
    }
  }

  // Fetch orders API call
  Future<OrderResponse> fetchOrders() async {
    try {
      await _isConnected();
      final response = await http
          .get(Uri.parse(BASE_URL + ORDER_URL), headers: headerApi)
          .timeout(const Duration(minutes: 1));

      developer.log(
        'Fetch Orders Response: ${response.body}',
        name: 'ApiServices',
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData == null) {
          throw Exception('Empty response from server');
        }
        return OrderResponse.fromJson(jsonData);
      } else {
        throw HttpException(
          'Failed to fetch orders: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } on SocketException catch (e) {
      developer.log('Network error in fetchOrders: $e', name: 'ApiServices');
      throw Exception('Network error: Unable to reach the server');
    } on TimeoutException catch (e) {
      developer.log('Timeout in fetchOrders: $e', name: 'ApiServices');
      throw Exception('Request timed out');
    } on FormatException catch (e) {
      developer.log(
        'Invalid response format in fetchOrders: $e',
        name: 'ApiServices',
      );
      throw Exception('Invalid response format');
    } catch (e) {
      developer.log('Unexpected error in fetchOrders: $e', name: 'ApiServices');
      throw Exception('Failed to fetch orders: $e');
    }
  }

  // Fetch custom collections API call
  Future<List<CollectionModel>> fetchCollections() async {
    try {
      await _isConnected();
      var request = http.Request('GET', Uri.parse(BASE_URL + COLLECTIONS_URL));
      request.headers.addAll(headerApi);

      final response = await request.send().timeout(const Duration(minutes: 1));
      developer.log(
        'Collections API Response Status: ${response.statusCode}',
        name: 'ApiServices',
      );

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody);
        if (data['custom_collections'] == null) {
          throw Exception('No collections found in response');
        }
        return (data['custom_collections'] as List)
            .map((json) => CollectionModel.fromJson(json))
            .toList();
      } else {
        throw HttpException(
          'Failed to fetch collections: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } on SocketException catch (e) {
      developer.log(
        'Network error in fetchCollections: $e',
        name: 'ApiServices',
      );
      throw Exception('Network error: Unable to reach the server');
    } on TimeoutException catch (e) {
      developer.log('Timeout in fetchCollections: $e', name: 'ApiServices');
      throw Exception('Request timed out');
    } on FormatException catch (e) {
      developer.log(
        'Invalid response format in fetchCollections: $e',
        name: 'ApiServices',
      );
      throw Exception('Invalid response format');
    } catch (e) {
      developer.log(
        'Unexpected error in fetchCollections: $e',
        name: 'ApiServices',
      );
      throw Exception('Failed to fetch collections: $e');
    }
  }

  // Fetch collection products API call
  Future<Map<String, dynamic>> fetchCollectionProducts({
    String? cursor,
    required String collectionId,
    required int first,
  }) async {
    try {
      await _isConnected();
      var request = http.Request('POST', Uri.parse(GRAPHQL_URL));
      request.headers.addAll(headerApi);
      request.body = json.encode({
        "query": """
        query {
          collection(id: "gid://shopify/Collection/$collectionId") {
            title
            products(first: $first${cursor != null && cursor.isNotEmpty ? ', after: "$cursor"' : ''}) {
              edges {
                node {
                  id
                  title
                  handle
                  descriptionHtml
                  images(first: 1) {
                    edges {
                      node { src }
                    }
                  }
                  variants(first: 1) {
                    edges {
                      node { id title price }
                    }
                  }
                }
                cursor
              }
              pageInfo {
                hasNextPage
                endCursor
              }
            }
          }
        }
      """,
      });

      final response = await request.send().timeout(const Duration(minutes: 1));
      developer.log(
        'Collection Products API Response Status: ${response.statusCode}',
        name: 'ApiServices',
      );

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody);
        if (data['errors'] != null) {
          throw Exception('API Error: ${data['errors'][0]['message']}');
        }
        final productEdges =
            data['data']['collection']['products']['edges'] as List;
        final pageInfo = data['data']['collection']['products']['pageInfo'];
        return {
          'products':
              productEdges
                  .map(
                    (edge) => CollectionSubProductModel.fromJson(edge['node']),
                  )
                  .toList(),
          'hasNextPage': pageInfo['hasNextPage'] as bool,
          'endCursor': pageInfo['endCursor'] as String?,
        };
      } else {
        throw HttpException(
          'Failed to fetch collection products: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } on SocketException catch (e) {
      developer.log(
        'Network error in fetchCollectionProducts: $e',
        name: 'ApiServices',
      );
      throw Exception('Network error: Unable to reach the server');
    } on TimeoutException catch (e) {
      developer.log(
        'Timeout in fetchCollectionProducts: $e',
        name: 'ApiServices',
      );
      throw Exception('Request timed out');
    } on FormatException catch (e) {
      developer.log(
        'Invalid response format in fetchCollectionProducts: $e',
        name: 'ApiServices',
      );
      throw Exception('Invalid response format');
    } catch (e) {
      developer.log(
        'Unexpected error in fetchCollectionProducts: $e',
        name: 'ApiServices',
      );
      throw Exception('Failed to fetch collection products: $e');
    }
  }

  // Fetch best selling products API call
  Future<Map<String, dynamic>> fetchCollectionBestProducts({
    String? cursor,
  }) async {
    try {
      await _isConnected();
      var headers = headerApi;
      final query =
          cursor == null
              ? "query { collection(id: \"gid://shopify/Collection/87225499707\") { title products(first: 10) { pageInfo { hasNextPage endCursor } edges {  node { id title handle description images(first: 1) { edges { node { src } } } variants(first: 1) { edges { node { id title price } } } } } } } }"
              : "query { collection(id: \"gid://shopify/Collection/87225499707\") { title products(first: 10, after: \"$cursor\") { pageInfo { hasNextPage endCursor } edges { node { id title handle description images(first: 1) { edges { node { src } } } variants(first: 1) { edges { node { id title price } } } } } } } }";

      var request = http.Request('POST', Uri.parse(GRAPHQL_URL));
      request.headers.addAll(headers);
      request.body = json.encode({"query": query});

      final response = await request.send().timeout(const Duration(minutes: 1));
      developer.log(
        'Best Products API Response Status: ${response.statusCode}',
        name: 'ApiServices',
      );

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody);
        if (data['errors'] != null) {
          throw Exception('API Error: ${data['errors'][0]['message']}');
        }
        final productEdges =
            data['data']['collection']['products']['edges'] as List;
        final pageInfo = data['data']['collection']['products']['pageInfo'];
        return {
          'products':
              productEdges
                  .map((edge) => BestSellingProductModel.fromJson(edge['node']))
                  .toList(),
          'hasNextPage': pageInfo['hasNextPage'] as bool,
          'endCursor': pageInfo['endCursor'] as String?,
        };
      } else {
        throw HttpException(
          'Failed to fetch best products: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } on SocketException catch (e) {
      developer.log(
        'Network error in fetchCollectionBestProducts: $e',
        name: 'ApiServices',
      );
      throw Exception('Network error: Unable to reach the server');
    } on TimeoutException catch (e) {
      developer.log(
        'Timeout in fetchCollectionBestProducts: $e',
        name: 'ApiServices',
      );
      throw Exception('Request timed out');
    } on FormatException catch (e) {
      developer.log(
        'Invalid response format in fetchCollectionBestProducts: $e',
        name: 'ApiServices',
      );
      throw Exception('Invalid response format');
    } catch (e) {
      developer.log(
        'Unexpected error in fetchCollectionBestProducts: $e',
        name: 'ApiServices',
      );
      throw Exception('Failed to fetch best products: $e');
    }
  }

  // Fetch teeth service products API call
  static Future<TeethApiServiceModel> fetchTeethServiceProducts({
    String? cursor,
    int first = 5,
  }) async {
    try {
      await ApiServices()._isConnected();
      final query = '''
        query {
          collection(id: "gid://shopify/Collection/445888331999") {
            title
            products(first: $first${cursor != null && cursor.isNotEmpty ? ', after: "$cursor"' : ''}) {
              edges {
                node {
                  id
                  title
                  handle
                  descriptionHtml
                  images(first: 1) {
                    edges {
                      node {
                        src
                      }
                    }
                  }
                  variants(first: 1) {
                    edges {
                      node {
                        id
                        title
                        price
                        availableForSale
                        inventoryQuantity
                        createdAt
                      }
                    }
                  }
                }
              }
              pageInfo {
                hasNextPage
                endCursor
              }
            }
          }
        }
      ''';

      final response = await http
          .post(
            Uri.parse(GRAPHQL_URL),
            headers: headerApi,
            body: jsonEncode({'query': query}),
          )
          .timeout(const Duration(minutes: 1));

      developer.log(
        'Teeth Service Products Response Status: ${response.statusCode}',
        name: 'ApiServices',
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['errors'] != null) {
          throw Exception('API Error: ${jsonData['errors'][0]['message']}');
        }
        final productsData = jsonData['data']['collection']['products'];
        if (productsData == null) {
          throw Exception('No products found in response');
        }
        final products =
            (productsData['edges'] as List)
                .map((edge) => TeethServiceProductModel.fromJson(edge['node']))
                .toList();
        final pageInfo = productsData['pageInfo'];
        return TeethApiServiceModel(
          products: products,
          hasNextPage: pageInfo['hasNextPage'] as bool,
          endCursor: pageInfo['endCursor'] as String?,
        );
      } else {
        throw HttpException(
          'Failed to fetch teeth service products: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } on SocketException catch (e) {
      developer.log(
        'Network error in fetchTeethServiceProducts: $e',
        name: 'ApiServices',
      );
      throw Exception('Network error: Unable to reach the server');
    } on TimeoutException catch (e) {
      developer.log(
        'Timeout in fetchTeethServiceProducts: $e',
        name: 'ApiServices',
      );
      throw Exception('Request timed out');
    } on FormatException catch (e) {
      developer.log(
        'Invalid response format in fetchTeethServiceProducts: $e',
        name: 'ApiServices',
      );
      throw Exception('Invalid response format');
    } catch (e) {
      developer.log(
        'Unexpected error in fetchTeethServiceProducts: $e',
        name: 'ApiServices',
      );
      throw Exception('Failed to fetch teeth service products: $e');
    }
  }

  // Fetch damn saloon products API call
  static Future<TeethApiServiceModel> fetchDamnSaloonProducts({
    String? cursor,
    int first = 5,
  }) async {
    try {
      await ApiServices()._isConnected();
      final query = '''
        query {
          collection(id: "gid://shopify/Collection/417931722975") {
            title
            products(first: $first${cursor != null && cursor.isNotEmpty ? ', after: "$cursor"' : ''}) {
              edges {
                node {
                  id
                  title
                  handle
                  descriptionHtml
                  images(first: 1) {
                    edges {
                      node {
                        src
                      }
                    }
                  }
                  variants(first: 1) {
                    edges {
                      node {
                        id
                        title
                        price
                        availableForSale
                        inventoryQuantity
                        createdAt
                      }
                    }
                  }
                }
              }
              pageInfo {
                hasNextPage
                endCursor
              }
            }
          }
        }
      ''';

      final response = await http
          .post(
            Uri.parse(GRAPHQL_URL),
            headers: headerApi,
            body: jsonEncode({'query': query}),
          )
          .timeout(const Duration(minutes: 1));

      developer.log(
        'Damn Saloon Products Response Status: ${response.statusCode}',
        name: 'ApiServices',
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['errors'] != null) {
          throw Exception('API Error: ${jsonData['errors'][0]['message']}');
        }
        final productsData = jsonData['data']['collection']['products'];
        if (productsData == null) {
          throw Exception('No products found in response');
        }
        final products =
            (productsData['edges'] as List)
                .map((edge) => TeethServiceProductModel.fromJson(edge['node']))
                .toList();
        final pageInfo = productsData['pageInfo'];
        return TeethApiServiceModel(
          products: products,
          hasNextPage: pageInfo['hasNextPage'] as bool,
          endCursor: pageInfo['endCursor'] as String?,
        );
      } else {
        throw HttpException(
          'Failed to fetch damn saloon products: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } on SocketException catch (e) {
      developer.log(
        'Network error in fetchDamnSaloonProducts: $e',
        name: 'ApiServices',
      );
      throw Exception('Network error: Unable to reach the server');
    } on TimeoutException catch (e) {
      developer.log(
        'Timeout in fetchDamnSaloonProducts: $e',
        name: 'ApiServices',
      );
      throw Exception('Request timed out');
    } on FormatException catch (e) {
      developer.log(
        'Invalid response format in fetchDamnSaloonProducts: $e',
        name: 'ApiServices',
      );
      throw Exception('Invalid response format');
    } catch (e) {
      developer.log(
        'Unexpected error in fetchDamnSaloonProducts: $e',
        name: 'ApiServices',
      );
      throw Exception('Failed to fetch damn saloon products: $e');
    }
  }

  // Fetch customer API call
  static Future<CustomerModel?> getCustomer() async {
    try {
      await ApiServices()._isConnected();

      final sharedPreferences = await SharedPreferences.getInstance();
      final customerID = sharedPreferences.getString(
        'customer_ID',
      ); // This is a String like "gid://shopify/Customer/8039300104415"

      // Null check
      if (customerID == null) {
        throw Exception('Customer ID not FOUND');
      }

      // ✅ Extract numeric customer ID from GID format
      final customerIdInt = int.parse(customerID.split('/').last);
      print("Extracted Customer ID: $customerIdInt");

      // ✅ Use the raw numeric ID in the request URL
      final url = Uri.parse('$BASE_URL/customers/$customerIdInt.json');
      final response = await http
          .get(url, headers: headerApi)
          .timeout(const Duration(minutes: 1));

      developer.log('Customer Response: ${response.body}', name: 'ApiServices');

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body['customer'] == null) {
          throw Exception('No customer data found in response');
        }
        return CustomerModel.fromJson(body['customer']);
      } else {
        developer.log(
          'Customer fetch error: ${response.statusCode} - ${response.reasonPhrase}',
          name: 'ApiServices',
        );
        throw HttpException(
          'Failed to fetch customer: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } on SocketException catch (e) {
      developer.log('Network error in getCustomer: $e', name: 'ApiServices');
      throw Exception('Network error: Unable to reach the server');
    } on TimeoutException catch (e) {
      developer.log('Timeout in getCustomer: $e', name: 'ApiServices');
      throw Exception('Request timed out');
    } on FormatException catch (e) {
      developer.log(
        'Invalid response format in getCustomer: $e',
        name: 'ApiServices',
      );
      throw Exception('Invalid response format');
    } catch (e) {
      developer.log('Unexpected error in getCustomer: $e', name: 'ApiServices');
      throw Exception('Failed to fetch customer: $e');
    }
  }

  // Update customer API call
  Future<String?> updateCustomer(UpdateCustomerMdoel customer) async {
    try {
      await _isConnected();
      final url = Uri.parse('$BASE_URL/customers/${customer.id}.json');
      final response = await http
          .put(url, headers: headerApi, body: json.encode(customer.toJson()))
          .timeout(const Duration(minutes: 1));

      developer.log(
        'Update Customer Response: ${response.body}',
        name: 'ApiServices',
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Customer updated successfully.");
        Get.put(ProfileController()).fetchCustomer();
        return "Customer updated successfully.";
      } else {
        Get.snackbar(
          "Error",
          "Failed to update customer: ${response.statusCode}",
        );
        throw HttpException(
          'Failed to update customer: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } on SocketException catch (e) {
      developer.log('Network error in updateCustomer: $e', name: 'ApiServices');
      Get.snackbar("Error", "Network error: Unable to reach the server");
      throw Exception('Network error: Unable to reach the server');
    } on TimeoutException catch (e) {
      developer.log('Timeout in updateCustomer: $e', name: 'ApiServices');
      Get.snackbar("Error", "Request timed out");
      throw Exception('Request timed out');
    } on FormatException catch (e) {
      developer.log(
        'Invalid response format in updateCustomer: $e',
        name: 'ApiServices',
      );
      Get.snackbar("Error", "Invalid response format");
      throw Exception('Invalid response format');
    } catch (e) {
      developer.log(
        'Unexpected error in updateCustomer: $e',
        name: 'ApiServices',
      );
      Get.snackbar("Error", "Failed to update customer: $e");
      throw Exception('Failed to update customer: $e');
    }
  }

  // Fetch single product API call
  Future<ProductModel> fetchProductDetails(int productId) async {
    try {
      await _isConnected();
      var request = http.Request(
        'GET',
        Uri.parse('$BASE_URL/products/$productId.json'),
      );
      request.headers.addAll(headerApi);

      final response = await request.send().timeout(const Duration(minutes: 1));
      developer.log(
        'Product Details API Response Status: ${response.statusCode}',
        name: 'ApiServices',
      );

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody);
        if (data['product'] == null) {
          throw Exception('No product found in response');
        }
        return ProductModel.fromJson(data['product']);
      } else {
        throw HttpException(
          'Failed to fetch product: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } on SocketException catch (e) {
      developer.log(
        'Network error in fetchProductDetails: $e',
        name: 'ApiServices',
      );
      throw Exception('Network error: Unable to reach the server');
    } on TimeoutException catch (e) {
      developer.log('Timeout in fetchProductDetails: $e', name: 'ApiServices');
      throw Exception('Request timed out');
    } on FormatException catch (e) {
      developer.log(
        'Invalid response format in fetchProductDetails: $e',
        name: 'ApiServices',
      );
      throw Exception('Invalid response format');
    } catch (e) {
      developer.log(
        'Unexpected error in fetchProductDetails: $e',
        name: 'ApiServices',
      );
      throw Exception('Failed to fetch product: $e');
    }
  }

  // side menu
  final String _shopifyStoreUrl = 'https://runwaycurls.myshopify.com';
  final String _apiVersion = '2025-04';
  final String _accessToken = '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';

  Future<Map<String, dynamic>> fetchMenus() async {
    try {
      final url = Uri.parse(
        '$_shopifyStoreUrl/admin/api/$_apiVersion/graphql.json',
      );

      final headers = {
        'Content-Type': 'application/json',
        'X-Shopify-Access-Token': _accessToken,
      };

      const query = """
        query {
          menus(first: 10) {
            edges {
              node {
                id
                handle
                title
                items {
                  id
                  title
                  type
                  url
                  items {
                    id
                    title
                    type
                    url
                    items {
                      id
                      title
                      type
                      url
                    }
                  }
                }
              }
            }
          }
        }
      """;

      final response = await http
          .post(url, headers: headers, body: json.encode({'query': query}))
          .timeout(const Duration(minutes: 1));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw 'Failed to load menus (${response.statusCode})';
      }
    } on http.ClientException catch (e) {
      throw 'Network error: ${e.message}';
    } on TimeoutException catch (_) {
      throw 'Request timed out';
    } catch (e) {
      throw 'Failed to fetch menus: $e';
    }
  }


  // side menu api ccall collection and product
  static Future<Map<String, dynamic>> fetchBabyNapsProducts({String? cursor, required String collectionId}) async {
    const url = 'https://runwaycurls.myshopify.com/admin/api/2024-04/graphql.json';

    final query = {
      "query": """
      query GetCollectionByHandle(\$handle: String!, \$cursor: String) {
        collectionByHandle(handle: \$handle) {
          products(first: 8, after: \$cursor) {
            pageInfo {
              hasNextPage
              endCursor
            }
            edges {
              node {
                id
                title
                handle
                description
                images(first: 1) {
                  edges {
                    node {
                      src
                    }
                  }
                }
                variants(first: 1) {
                  edges {
                    node {
                      id
                      title
                      price
                    }
                  }
                }
              }
            }
          }
        }
      }
    """,
      "variables": {"handle": collectionId, "cursor": cursor},
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headerApi,
      body: jsonEncode(query),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final data = jsonData['data']['collectionByHandle']['products'];

      final edges = data['edges'] as List;
      final products = edges.map((e) => ShopifyProduct.fromJson(e['node'])).toList();

      return {
        "products": products,
        "hasNextPage": data['pageInfo']['hasNextPage'],
        "endCursor": data['pageInfo']['endCursor'],
      };
    } else {
      throw Exception('Failed to load products');
    }
  }



  // side menu api call product
  Future<Map<String, dynamic>> fetchProductByHandle(String handle) async {
    try {
      final url = Uri.parse('$_shopifyStoreUrl/admin/api/$_apiVersion/graphql.json');


      final query = """
      query GetProductByHandle(\$handle: String!) {
        productByHandle(handle: \$handle) {
          id
          title
          description
          descriptionHtml
          images(first: 5) {
            edges {
              node {
                src
              }
            }
          }
          variants(first: 10) {
            edges {
              node {
                id
                title
                price
                availableForSale
                compareAtPrice
                sku
                selectedOptions {
                  name
                  value
                }
              }
            }
          }
          options {
            name
            values
          }
        }
      }
    """;

      final variables = {
        'handle': handle,
      };

      final response = await http.post(
        url,
        headers: headerApi,
        body: json.encode({
          'query': query,
          'variables': variables,
        }),
      ).timeout(const Duration(minutes: 1));
      print("response.body");


      if (response.statusCode == 200) {
        final body = json.decode(response.body); // decode the response
        print(body["data"]["productByHandle"]["id"]); // now this works
        final ProdID=body["data"]["productByHandle"];
        String gid =ProdID["id"];
        String numericId = gid.split('/').last;
        Get.put(
          ProductDetailsController(),
        ).fetchProduct(int.parse(numericId));
        Get.put(HomeController())
            .selectedVariant
            .value = null;

        Get.to(
          BestSellerDetails(
            id: ProdID["id"],
            title: ProdID["title"],
          ),
        );
        return body;


      } else {
        throw 'Failed to load product (${response.statusCode})';
      }
    } catch (e) {
      throw 'Failed to fetch product: $e';
    }
  }

  // pages call profile menu policy api call

  // Future<ShopifyPageModel?> fetchPageContent() async {
  //   final uri = Uri.parse("https://runwaycurls.myshopify.com/api/2025-04/graphql.json");
  //   final headers = {
  //     'Content-Type': 'application/json',
  //     'X-Shopify-Storefront-Access-Token': STORE_TOKEN,
  //   };
  //
  //   const query = '''
  //   query {
  //     page(handle: "return-policy") {
  //       id
  //       title
  //       body
  //     }
  //   }
  // ''';
  //
  //   final response = await http.post(uri, headers: headers, body: jsonEncode({'query': query}));
  //
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     final pageJson = data['data']['page'];
  //
  //     if (pageJson != null) {
  //       return ShopifyPageModel.fromJson(pageJson);
  //     }
  //   } else {
  //     print("Error: ${response.statusCode} - ${response.reasonPhrase}");
  //   }
  //
  //   return null;
  // }

}



// Custom exceptions for better error handling
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class DataParsingException implements Exception {
  final String message;
  DataParsingException(this.message);
}

class GenericApiException implements Exception {
  final String message;
  GenericApiException(this.message);
}
