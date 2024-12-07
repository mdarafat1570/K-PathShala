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
  bool _canGoBack = false;
  bool _canGoForward = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _updateNavigationStatus() async {
    bool canGoBack = await _controller.canGoBack();
    bool canGoForward = await _controller.canGoForward();
    setState(() {
      _canGoBack = canGoBack;
      _canGoForward = canGoForward;
    });
  }

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
          _updateNavigationStatus();
        },
        onProgressChanged: (controller, int progressValue) {
          setState(() {
            progress = progressValue / 100;
          });
        },
        onLoadStart: (controller, url) {
          _updateNavigationStatus();
          debugPrint('Page started loading: $url');
        },
        onLoadStop: (controller, url) {
          _updateNavigationStatus();
          debugPrint('Page finished loading: $url');
          setState(() {
            progress = 0;
          });
        },
        onLoadError: (controller, url, code, message) {
          _updateNavigationStatus();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error loading page: $message'),
              backgroundColor: Colors.red,
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 26, 26, 46),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: _canGoBack ? AppColor.white : Colors.grey,
              ),
              onPressed: _canGoBack
                  ? () async {
                      await _controller.goBack();
                      _updateNavigationStatus();
                    }
                  : null,
            ),
            IconButton(
              icon: Icon(
                Icons.arrow_forward,
                color: _canGoForward ? AppColor.white : Colors.grey,
              ),
              onPressed: _canGoForward
                  ? () async {
                      await _controller.goForward();
                      _updateNavigationStatus();
                    }
                  : null,
            ),
            IconButton(
              icon: const Icon(
                Icons.refresh,
                color: AppColor.white,
              ),
              onPressed: () {
                _controller.reload();
                _updateNavigationStatus();
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
