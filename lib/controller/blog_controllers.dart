import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:mushiya_beauty/model/article_model.dart';
import 'package:mushiya_beauty/model/blog_model.dart';
import 'package:mushiya_beauty/utills/services.dart';

class BlogControllers extends GetxController {
  var currentIndex = 0.obs;
  var blogs = <BlogModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  // var article = Rxn<Article>(); // For a single article

  @override
  void onInit() {
    super.onInit();
    fetchBlogs();
  }

  Future<void> fetchBlogs() async {
    isLoading.value = true;
    errorMessage.value = '';

    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      errorMessage.value = 'No internet connection';
      isLoading.value = false;
      return;
    }

    try {
      final fetchedBlogs = await ApiServices.fetchBlogs();
      blogs.value = fetchedBlogs;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  var articles = <ArticleModel>[].obs;

  Future<void> fetchBlogDetails(String blogID) async {
    isLoading.value = true;
    errorMessage.value = '';
    articles.clear(); // clear previous data if necessary

    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      errorMessage.value = 'No internet connection';
      Get.snackbar(
        'Error',
        'No internet connection',
        snackPosition: SnackPosition.BOTTOM,
      );
      isLoading.value = false;
      return;
    }

    try {
      final apiService = ApiServices();
      final articleResponse = await apiService.fetchArticles(blogID);

      if (articleResponse.articles.isNotEmpty) {
        articles.assignAll(
          articleResponse.articles,
        ); // assign list to observable
        print('Articles fetched: ${articles.length}');
      } else {
        errorMessage.value = 'No articles found for this blog.';
        Get.snackbar(
          'Info',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Error: $e');
    } finally {
      isLoading.value = false;
      print(
        'isLoading: ${isLoading.value}, errorMessage: ${errorMessage.value}',
      );
    }
  }

  void retryFetch(String blogId) {
    fetchBlogDetails(blogId);
  }
}
