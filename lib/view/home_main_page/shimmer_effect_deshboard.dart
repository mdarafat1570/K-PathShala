import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'dashboard_page.dart';

class DashboardPageShimmerEffect extends StatefulWidget {
  @override
  _DashboardPageShimmerEffectState createState() =>
      _DashboardPageShimmerEffectState();
}

class _DashboardPageShimmerEffectState
    extends State<DashboardPageShimmerEffect> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: _isLoading ? _buildShimmerContent() : DashboardPage(),
      ),
    );
  }

  // Shimmer effect placeholders
  Widget _buildShimmerContent() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey,
                  width: 2.0,
                ),
              ),
            ),
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildShimmerBoxDot(),
                      const SizedBox(width: 3),
                      _buildShimmerBoxDot(),
                      const SizedBox(width: 3),
                      _buildShimmerBoxDot(),
                      const SizedBox(width: 3),
                      _buildShimmerBoxDot(),
                      const SizedBox(width: 3),
                      _buildShimmerBoxDot(),
                      const SizedBox(width: 3),
                      _buildShimmerBoxDot(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildShimmerBox(),
                    _buildShimmerBox(),
                  ],
                ),
              ],
            ),
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildShimmerBox(),
                    _buildShimmerBox(),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 5),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey,
                  width: 2.0,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey,
                  width: 2.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Actual dashboard content when data is loaded
  Widget _buildDashboardContent() {
    return Column(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          color: Colors.blueAccent,
          child: const Center(
              child: Text('Dashboard Content 1',
                  style: TextStyle(color: Colors.white))),
        ),
        const SizedBox(height: 10),
        Container(
          height: 80,
          width: double.infinity,
          color: Colors.greenAccent,
          child: const Center(
              child: Text('Dashboard Content 2',
                  style: TextStyle(color: Colors.white))),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildContentBox('Item 1', Colors.redAccent),
            _buildContentBox('Item 2', Colors.purpleAccent),
            _buildContentBox('Item 3', Colors.orangeAccent),
          ],
        ),
      ],
    );
  }

  Widget _buildShimmerBox() {
    return Container(
      height: 60,
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12), // Add rounded corners here
      ),
    );
  }

  Widget _buildShimmerBoxDot() {
    return Container(
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12), // Add rounded corners here
      ),
    );
  }

  Widget _buildContentBox(String title, Color color) {
    return Container(
      height: 100,
      width: 100,
      color: color,
      child: Center(
          child: Text(title, style: const TextStyle(color: Colors.white))),
    );
  }
}
