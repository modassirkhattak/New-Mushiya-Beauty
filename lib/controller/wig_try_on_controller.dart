import 'package:get/get.dart';
import 'package:mushiya_beauty/utills/wigs_service.dart';

class WigController extends GetxController {
  var wigs = <Map<String, dynamic>>[].obs; // List of wigs from Firestore
  var selectedWig = ''.obs; // Selected wig ID
  var isLoading = false.obs;

  final WigService _wigService = WigService();

  @override
  void onInit() {
    super.onInit();
    fetchWigs();
  }

  Future<void> fetchWigs() async {
    isLoading.value = true;
    wigs.value = await _wigService.getWigs();
    if (wigs.isNotEmpty) selectedWig.value = wigs[0]['wigId'];
    isLoading.value = false;
  }

  void selectWig(String wigId) {
    selectedWig.value = wigId;
    // Save session to Firestore
    _wigService.saveSession('user123', wigId); // Replace with actual user ID
  }
}
