import 'package:get/get.dart';

class RewardController extends GetxController {
  List<RewardModel> rewardList = [
    RewardModel(
      icon: 'assets/icons_svg/signup.svg',
      subText: '50 Mushiya Bucks',
      title: 'Signup',
    ),
    RewardModel(
      icon: 'assets/icons_svg/place_order.svg',
      subText: "1 Mushiya Buck for every \$1 spent",
      title: 'Place an order',
    ),
    RewardModel(
      icon: 'assets/icons_svg/instagram-follow.svg',
      subText: "50 Mushiya Bucks",
      title: 'Follow on Instagram',
    ),
    RewardModel(
      icon: 'assets/icons_svg/facebook-like.svg',
      subText: "50 Mushiya Bucks",
      title: 'Like on Facebook',
    ),
    RewardModel(
      icon: 'assets/icons_svg/share_fac.svg',
      subText: "50 Mushiya Bucks",
      title: 'Share on Facebook',
    ),
    RewardModel(
      icon: 'assets/icons_svg/birthday.svg',
      subText: "200 Mushiya Bucks",
      title: 'Celebrate a birthday',
    ),
  ];
}

class RewardModel {
  final String title;
  final String icon;
  final String subText;

  RewardModel({required this.icon, required this.subText, required this.title});
}
