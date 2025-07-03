import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';

class WebViewCheckout extends StatefulWidget {
  const WebViewCheckout({super.key, required this.checkoutUrl});
  final String checkoutUrl;

  @override
  State<WebViewCheckout> createState() => _WebViewCheckoutState();
}

class _WebViewCheckoutState extends State<WebViewCheckout> {
  late final InAppWebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black, // Dark black background
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text('Checkout'.toUpperCase(), style: TextStyle(color: Colors.white,fontFamily: "Archivo")),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri(widget.checkoutUrl),
          ),
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
          onUpdateVisitedHistory: (controller, url, androidIsReload) {
            if (url != null) handleUrlChanged(url.toString());
          },
          onPageCommitVisible: (controller, url) {
            controller.evaluateJavascript(source: """
              document.body.style.backgroundColor = "#000000";
              document.body.style.color = "white";

              var inputs = document.getElementsByTagName('input');
              for (var i = 0; i < inputs.length; i++) {
                inputs[i].style.backgroundColor = "#111111";
                inputs[i].style.color = "white";
                inputs[i].style.border = "1px solid white";
              }

              var buttons = document.getElementsByTagName('button');
              for (var i = 0; i < buttons.length; i++) {
                buttons[i].style.backgroundColor = "#222222";
                buttons[i].style.color = "white";
              }

              var headers = document.getElementsByTagName('header');
              for (var i = 0; i < headers.length; i++) {
                headers[i].style.backgroundColor = "#000000";
              }

              var footers = document.getElementsByTagName('footer');
              for (var i = 0; i < footers.length; i++) {
                footers[i].style.backgroundColor = "#000000";
              }

              var elements = document.getElementsByClassName("_19gi7yt0 _19gi7yth _1fragemfq _19gi7ytb");
              if (elements.length > 0) {
                elements[0].style.display = "none";
              }
            """);
          },
        ),
      ),
    );
  }

  void handleUrlChanged(String url) {
    if (url.contains('/order-received/') ||
        url.contains('checkout/success') ||
        url.contains('thank-you') ||
        url.contains('thank_you')) {
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        Navigator.pop(context, true);
      });
    }
    if (url.contains('/member-login/')) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text('Unauthorized User'),
          ),
        );
      Navigator.pop(context);
    }
  }
}
