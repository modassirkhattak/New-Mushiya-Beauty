import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/controller/tutorials_controller.dart';
import 'package:mushiya_beauty/model/tutorials_model.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/view/tutorials/play_now_video_page.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';
import 'package:mushiya_beauty/widget/custom_button.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';

class TutorialDetailPage extends StatelessWidget {
  TutorialDetailPage({super.key, required this.model});

  final controller = Get.put(TutorialsController());

  final TutorialModel model;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: MyAppBarWidget(
          title: "Tutorial details".toUpperCase(),
          titleImage: true,
          actions: true,

          actionsWidget:
              null, // SvgPicture.asset('assets/icons_svg/share_icon.svg'),
          leadingButton: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  Image(
                    image: NetworkImage(model.imageUrl),
                    height: 192,
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    bottom: 0,
                    left: 0,
                    child: Icon(Icons.play_circle_outline_outlined, size: 46),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            CustomText(
              text: model.title,
              fontSize: 18,
              color: whiteColor,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 16),
            CustomText(
              text: model.description,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              maxLines: 5,
              fontFamily: 'Roboto',
              color: whiteColor.withOpacity(0.80),

              // overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 16),
            CustomText(
              text: controller.formatDuration(model.videoDuration!),
              fontSize: 12,
              fontWeight: FontWeight.w400,
              maxLines: 5,
              fontFamily: 'Roboto',
              color: whiteColor.withOpacity(0.80),

              // overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 47),
            CustomButton(
              text: "Play now",
              onPressed: () {
                Get.to(
                  () => VideoPlayerScreen(
                    videoUrl: model.videoLink,
                    title: model.title,
                    description: model.description,
                  ),
                );
              },
              height: 48,
              backgroundColor: whiteColor,
              fontSize: 16,
              textColor: primaryBlackColor,
              fontWeight: FontWeight.w600,
              minWidth: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
