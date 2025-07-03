import 'package:cloud_firestore/cloud_firestore.dart';

class WigService {
  final CollectionReference wigs = FirebaseFirestore.instance.collection(
    'wigs',
  );

  Future<List<Map<String, dynamic>>> getWigs() async {
    try {
      final snapshot = await wigs.get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching wigs: $e');
      return [];
    }
  }

  Future<void> saveSession(String userId, String wigId) async {
    try {
      await FirebaseFirestore.instance.collection('user_sessions').add({
        'userId': userId,
        'wigId': wigId,
        'timestamp': DateTime.now(),
      });
    } catch (e) {
      print('Error saving session: $e');
    }
  }
}
