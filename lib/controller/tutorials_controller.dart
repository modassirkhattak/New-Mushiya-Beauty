import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../model/tutorials_model.dart';

class TutorialsController extends GetxController {
  RxString tabPage = 'Free Tutorials'.obs;
  RxList<TutorialModel> allTutorials = <TutorialModel>[].obs;

  /// Firestore stream without duration fetch
  Stream<List<TutorialModel>> getTutorialsStream() {
    return FirebaseFirestore.instance
        .collection('Tutorials')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => TutorialModel.fromJson(doc.data()))
                  .toList(),
        );
  }

  /// Filter list based on Free/Premium tab
  List<TutorialModel> get filteredTutorials {
    final isFree = tabPage.value == 'Free Tutorials';
    return allTutorials.where((t) => t.freeType == isFree).toList();
  }

  /// Duration fetch with delay for safety
  Future<Duration> fetchVideoDuration(String url) async {
    try {
      final controller = VideoPlayerController.networkUrl(Uri.parse(url));
      await controller.initialize();
      await Future.delayed(const Duration(milliseconds: 200));
      final duration = controller.value.duration;
      await controller.dispose();
      return duration;
    } catch (e) {
      print('❌ Failed to load video: $e');
      return Duration.zero;
    }
  }

  /// Start listening to Firestore
  @override
  void onInit() {
    super.onInit();

    getTutorialsStream().listen((tutorialsFromDB) {
      allTutorials.assignAll(tutorialsFromDB);
      // Start background fetch for durations
      _fetchDurationsLazily(tutorialsFromDB);
    });
  }

  /// Fetch durations one-by-one without blocking UI
  void _fetchDurationsLazily(List<TutorialModel> tutorials) async {
    for (int i = 0; i < tutorials.length; i++) {
      final tutorial = tutorials[i];
      if (tutorial.videoDuration == null ||
          tutorial.videoDuration == Duration.zero) {
        final duration = await fetchVideoDuration(tutorial.videoLink);
        tutorial.videoDuration = duration;

        // Trigger UI update
        allTutorials[i] = tutorial;
      }
    }
  }

  /// Duration format: 1h 20m 5sec
  String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    String result = '';
    if (hours > 0) result += '${hours}h ';
    if (minutes > 0) result += '${minutes}m ';
    if (seconds > 0 || result.isEmpty) result += '${seconds}sec';

    return result.trim();
  }
}
