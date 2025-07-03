import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../model/event_model.dart';

class EventController extends GetxController {
  RxList<EventModel> eventList = <EventModel>[].obs;

  RxString selectedEventTicket = ''.obs;
  @override
  void onInit() {
    super.onInit();
    getEventStream().listen((events) {
      eventList.assignAll(events);
    });
  }

  Stream<List<EventModel>> getEventStream() {
    return FirebaseFirestore.instance
        .collection(
          'Events',
        ) // Make sure your Firestore collection is named 'Events'
        .orderBy('date_time', descending: false)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => EventModel.fromSnapshot(doc)).toList(),
        );
  }
}
