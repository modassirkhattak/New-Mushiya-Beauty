import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/view/profile/main_profile_nav_page.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaPage extends StatelessWidget {
  const SocialMediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:  Size.fromHeight(60),
        child: MyAppBarWidget(
          title: 'Social media'.tr.toUpperCase(),
          titleImage: false,
          actions: true,
          actionsWidget: null,
          leadingButton: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                menuItem(
                  'assets/icons_svg/facebook-like.svg',
                  'Facebook'.tr,
                  color: whiteColor,
                  onPressed: () async {
                    final uri = Uri.parse(
                      'https://www.facebook.com/MushiyaBeautyUSA',
                    );
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Could not launch $uri')),
                      );
                    }
                  },
                ),

                const SizedBox(width: 20),
                menuItem(
                  'assets/icons_svg/Twitter--Streamline-Bootstrap.svg',
                  'Twitter'.tr,
                  color: whiteColor,
                  onPressed: () async {
                    final uri = Uri.parse(
                      'https://www.facebook.com/MushiyaBeautyUSA',
                    );
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Could not launch $uri')),
                      );
                    }
                  },
                ),
                const SizedBox(width: 20),
                menuItem(
                  'assets/icons_svg/instagram-follow.svg',
                  'Instagram'.tr,
                  color: whiteColor,
                  onPressed: () async {
                    final uri = Uri.parse(
                      'https://www.facebook.com/MushiyaBeautyUSA',
                    );
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Could not launch $uri')),
                      );
                    }
                  },
                ),
                const SizedBox(width: 20),
                menuItem(
                  'assets/icons_svg/Youtube--Streamline-Simple-Icons.svg',
                  'YouTube'.tr,
                  color: whiteColor,
                  onPressed: () async {
                    final uri = Uri.parse(
                      'https://linkedin.com/company/yourbrand',
                    );
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Could not launch $uri')),
                      );
                    }
                  },
                ),
                const SizedBox(width: 20),
                menuItem(
                  'assets/icons_svg/Tiktok--Streamline-Plump.svg',
                  'TikTok'.tr,
                  color: whiteColor,
                  onPressed: () async {
                    final uri = Uri.parse(
                      'https://www.tiktok.com/@mushiyabeautyusa',
                    );
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Could not launch $uri')),
                      );
                    }
                  },
                ),
                const SizedBox(width: 20),
                menuItem(
                  'assets/icons_svg/Pinterest--Streamline-Bootstrap.svg',
                  'Pinterest'.tr,
                  color: whiteColor,
                  onPressed: () async {
                    final uri = Uri.parse(
                      'https://www.pinterest.com/mushiyabeauty/',
                    );
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Could not launch $uri')),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SocialMediaIcon extends StatelessWidget {
  final String iconPath;
  final String url;

  const SocialMediaIcon({super.key, required this.iconPath, required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Could not launch $url')));
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[200],
        ),
        child: SvgPicture.asset(iconPath, width: 24, height: 24),
      ),
    );
  }
}
