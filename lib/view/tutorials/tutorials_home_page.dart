import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:svg_flutter/svg.dart';
import '../../controller/tutorials_controller.dart';
import '../../utills/app_colors.dart';
import '../../view/faq/faq_page.dart';
import '../../view/tutorials/tutorial_detail_page.dart';
import '../../widget/custom_tabbar.dart';
import '../../widget/custom_text.dart';

class TutorialsHomePage extends StatelessWidget {
  TutorialsHomePage({super.key});
  final controller = Get.put(TutorialsController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.to(() => FaqPage()),
          shape: const CircleBorder(),
          backgroundColor: whiteColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              'assets/icons_svg/message_icon2.svg',
              height: 24,
              width: 24,
            ),
          ),
        ),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, color: whiteColor),
          ),
          centerTitle: true,
          title: CustomText(
            text: 'Tutorials'.toUpperCase(),
            fontFamily: "Archivo",
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: whiteColor,
          ),
        ),
        body: Column(
          children: [
            CustomTabWidget(
              onTap: (index) {
                controller.tabPage.value =
                    index == 0 ? 'Free Tutorials' : 'Premium Tutorials';
              },
              children: const [
                Tab(text: 'Free Tutorials'),
                Tab(text: 'Premium Tutorials'),
              ],
            ),
            Expanded(
              child: Obx(() {
                final tutorials = controller.filteredTutorials;

                if (controller.allTutorials.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (tutorials.isEmpty) {
                  return const Center(child: Text('No tutorials found'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: tutorials.length,
                  itemBuilder: (context, index) {
                    final tutorial = tutorials[index];

                    return GestureDetector(
                      onTap:
                          () =>
                              Get.to(() => TutorialDetailPage(model: tutorial)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: whiteColor.withOpacity(0.6),
                              width: 0.2,
                            ),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Stack(
                                children: [
                                  Image.network(
                                    tutorial.imageUrl.isNotEmpty
                                        ? tutorial.imageUrl
                                        : 'https://via.placeholder.com/81',
                                    width: 81,
                                    height: 81,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    bottom: 0,
                                    left: 0,
                                    child: Icon(
                                      Icons.play_circle_outline_outlined,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: tutorial.title,
                                    fontFamily: "Roboto",
                                    fontSize: 14,
                                    color: whiteColor,
                                    maxLines: 2,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  const SizedBox(height: 2),
                                  CustomText(
                                    text:
                                        tutorial.freeType ? 'Free' : 'Premium',
                                    fontFamily: "Roboto",
                                    fontSize: 12,
                                    color: whiteColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: 13,
                                        color: whiteColor.withOpacity(0.8),
                                      ),
                                      const SizedBox(width: 4),
                                      CustomText(
                                        text: '${tutorial.rating} Stars',
                                        fontFamily: "Roboto",
                                        fontSize: 12,
                                        color: whiteColor.withOpacity(0.8),
                                        fontWeight: FontWeight.w400,
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.circle,
                                        size: 4,
                                        color: whiteColor.withOpacity(0.8),
                                      ),
                                      const SizedBox(width: 8),
                                      CustomText(
                                        text:
                                            tutorial.videoDuration != null
                                                ? "${controller.formatDuration(tutorial.videoDuration!)}"
                                                : "Loading...",
                                        fontFamily: "Roboto",
                                        fontSize: 12,
                                        color: whiteColor.withOpacity(0.8),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
}
