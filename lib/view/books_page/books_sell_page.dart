import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kpathshala/app_theme/app_color.dart';
import 'package:kpathshala/view/common_widget/common_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class BookSellPage extends StatefulWidget {
  const BookSellPage({super.key});

  @override
  State<BookSellPage> createState() => _BookSellPageState();
}

class _BookSellPageState extends State<BookSellPage> {
  late final WebViewController _controller;
  double progress = 0; // To track the loading progress

  @override
  void initState() {
    super.initState();

    final PlatformWebViewControllerCreationParams params =
        (WebViewPlatform.instance is WebKitWebViewPlatform)
            ? WebKitWebViewControllerCreationParams(
                allowsInlineMediaPlayback: true,
                mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
              )
            : const PlatformWebViewControllerCreationParams();

    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progressValue) {
            setState(() {
              progress = progressValue /
                  100; // Convert to decimal for LinearProgressIndicator
            });
          },
          onPageStarted: (String url) {
            debugPrint('Page started: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished: $url');
            setState(() {
              progress = 0; // Reset progress after page load
            });
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('Error: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('Blocked: ${request.url}');
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://kpathshala.com/books'));

    if (kIsWeb || !Platform.isMacOS) {
      _controller.setBackgroundColor(const Color(0x80000000));
    }

    if (_controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (_controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(
          title: 'Book Buy',
          backgroundColor: const Color.fromARGB(
            255,
            26,
            26,
            46,
          ),
          titleColor: AppColor.white,
          titleFontSize: 20,
          progress: progress,
          showBackButton: false,
        ),
        body: WebViewWidget(controller: _controller),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final String text = "K-Pathshala Mobile App";
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '💖 You just favorited: $text! Enjoy the best learning experience with us. 📚✨',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          child: const Icon(
            Icons.favorite,
            color: AppColor.white,
          ),
        ));
  }
}
