import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  QuillController? _controller;

  @override
  void initState() {
    super.initState();
    _fetchAboutUs();
  }

  Future<void> _fetchAboutUs() async {
    final snapshot = await FirebaseFirestore.instance.collection("PrivacyPolicy").get();

    if (snapshot.docs.isNotEmpty) {
      final jsonData = snapshot.docs[0]["text"];

      setState(() {
        _controller = QuillController(
          document: jsonData.isEmpty ? Document() : Document.fromJson(List<Map<String, dynamic>>.from(jsonData)),
          selection: const TextSelection.collapsed(offset: 0),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: MyAppBarWidget(
          title: "About Us".toUpperCase(),
          titleImage: true,
          actions: true,
          actionsWidget: null,
          leadingButton: true,
        ),
      ),
      body: _controller == null
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : Container(
        padding: const EdgeInsets.all(16),
        color: primaryBlackColor,
        child: QuillEditor.basic(
          controller: _controller!,
          config: QuillEditorConfig(
            readOnlyMouseCursor: MouseCursor.uncontrolled,
            checkBoxReadOnly: false,
            disableClipboard: true,
          ),
        ),
      ),
    );
  }
}
