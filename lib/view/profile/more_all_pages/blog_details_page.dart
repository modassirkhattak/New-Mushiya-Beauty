import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// import 'package:mushiya_beauty/controller/blog_controllers.dart';
import 'package:mushiya_beauty/model/article_model.dart';
// import 'package:mushiya_beauty/model/blog_model.dart';
// import 'package:mushiya_beauty/model/home_model.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';

import 'package:mushiya_beauty/widget/custom_text.dart';

class BlogDetailsPage extends StatelessWidget {
  BlogDetailsPage({super.key, required this.blogsModel});

  final ArticleModel blogsModel;
  // final controller = Get.put(BlogControllers());

  // final controller = Get.put(ProductDetailsController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: MyAppBarWidget(
            title: "Blog details".tr.toUpperCase(),
            titleImage: true,
            actions: true,
            actionsWidget:
                null, // SvgPicture.asset('assets/icons_svg/share_icon.svg'),
            leadingButton: true,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //  yle: const TextStyle(color: Colors.grey),
              // ),
              CustomText(
                text: blogsModel.title,
                maxLines: 3,
                fontFamily: "Roboto",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: whiteColor,
              ),
              SizedBox(height: 10),
              CustomText(
                text: DateFormat('MMM dd, yyyy').format(
                  DateTime.parse(blogsModel.createdAt.toString()),
                ), //'Sep 11, 2024',
                maxLines: 1,
                fontSize: 12,
                fontFamily: 'Roboto',
                color: whiteColor.withOpacity(0.8),
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 10),
              if (blogsModel.image?.src != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    blogsModel.image!.src.toString(),
                    width: double.infinity,

                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              // NetworkImage(blogsModel.image!.src.toString()),
              const SizedBox(height: 16),

              Html(
                data: blogsModel.bodyHtml,
                style: {
                  'p': Style(
                    fontSize: FontSize(14),
                    fontWeight: FontWeight.w400,
                    color: whiteColor.withOpacity(0.8),
                  ),
                  'strong': Style(
                    fontWeight: FontWeight.w600,
                    fontSize: FontSize(16),
                    fontFamily: "Roboto",

                    color: whiteColor,
                  ),
                  'ul': Style(margin: Margins(left: Margin(0))),
                  'table': Style(
                    fontSize: FontSize(14),
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w400,
                    color: whiteColor.withOpacity(0.8),

                    // bo: BorderCollapse.separate,
                    // borderSpacing: 0,
                  ),
                  'td': Style(
                    fontFamily: "Roboto",
                    // padding: Padding(padding: paddingAll(8)),s
                    // border: Border.all(color: Colors.grey),
                  ),
                  'span': Style(
                    fontSize: FontSize(14),
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w400,
                    color: whiteColor.withOpacity(0.8),
                  ),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
