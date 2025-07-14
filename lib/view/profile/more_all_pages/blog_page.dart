import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mushiya_beauty/controller/blog_controllers.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/view/profile/more_all_pages/blog_details_page.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';

class BlogPage extends StatelessWidget {
  BlogPage({super.key});

  final controller = Get.put(BlogControllers());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: MyAppBarWidget(
          title: "Blogs".tr.toUpperCase(),
          titleImage: true,
          actions: true,
          actionsWidget:
              null, // SvgPicture.asset('assets/icons_svg/share_icon.svg'),
          leadingButton: true,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: whiteColor));
        } else if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        } else if (controller.articles.isEmpty) {
          return Center(
            child: Text(
              'No blogs found'.tr,
              style: TextStyle(color: Colors.red, fontFamily: "Roboto"),
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.articles.length,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
          itemBuilder: (context, index) {
            final item = controller.articles[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  print(item.id);
                  // controller.fetchBlogDetails(item.id.toString());
                  Get.to(() => BlogDetailsPage(blogsModel: item));
                },
                child: Column(
                  // spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        item.image!.src.toString(),
                        height: 173,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/extra_images/girl_1.png',
                            height: 173,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          );
                        },
                        loadingBuilder:
                            (context, child, loadingProgress) =>
                                loadingProgress == null
                                    ? child
                                    : Center(
                                      child: CircularProgressIndicator(
                                        color: whiteColor,
                                      ),
                                    ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(right: 75.0),
                      child: CustomText(
                        text:
                            item.title, // 'Mushiya chooses haiti for baby naps wigs production',
                        maxLines: 2,
                        fontSize: 14,
                        fontFamily: 'Roboto',
                        color: whiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    CustomText(
                      text: DateFormat('MMM dd, yyyy').format(
                        DateTime.parse(item.createdAt.toString()),
                      ), //'Sep 11, 2024',
                      maxLines: 1,
                      fontSize: 12,
                      fontFamily: 'Roboto',
                      color: whiteColor.withOpacity(0.8),
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
