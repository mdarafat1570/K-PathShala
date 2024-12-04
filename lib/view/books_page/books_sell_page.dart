import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:kpathshala/app_theme/app_color.dart';
import 'package:kpathshala/view/common_widget/common_app_bar.dart';

class BookSellPage extends StatefulWidget {
  const BookSellPage({super.key});

  @override
  State<BookSellPage> createState() => _BookSellPageState();
}

class _BookSellPageState extends State<BookSellPage> {
  late InAppWebViewController _controller;
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Book Buy',
        backgroundColor: const Color.fromARGB(255, 26, 26, 46),
        titleColor: AppColor.white,
        titleFontSize: 20,
        progress: progress,
        showBackButton: false,
      ),
      body: InAppWebView(
        initialUrlRequest:
            URLRequest(url: Uri.parse('https://kpathshala.com/books')),
        onWebViewCreated: (controller) {
          _controller = controller;
        },
        onProgressChanged: (controller, int progressValue) {
          setState(() {
            progress = progressValue / 100;
          });
        },
        onLoadStart: (controller, url) {
          debugPrint('Page started loading: $url');
        },
        onLoadStop: (controller, url) {
          debugPrint('Page finished loading: $url');
          setState(() {
            progress = 0;
          });
        },
        onLoadError: (controller, url, code, message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error loading page: $message'),
              backgroundColor: Colors.red,
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                if (await _controller.canGoBack()) {
                  await _controller.goBack();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No back history available')),
                  );
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () async {
                if (await _controller.canGoForward()) {
                  await _controller.goForward();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('No forward history available')),
                  );
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                _controller.reload();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          const String text = "K-Pathshala Mobile App";
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                '💖 You just favorited: $text! Enjoy the best learning experience with us. 📚✨',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        },
        child: const Icon(Icons.favorite, color: AppColor.white),
      ),
    );
  }
}
