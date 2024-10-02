import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class DashboardPageShimmerEffect extends StatefulWidget {
  const DashboardPageShimmerEffect({super.key});

  @override
  DashboardPageShimmerEffectState createState() =>
      DashboardPageShimmerEffectState();
}

class DashboardPageShimmerEffectState
    extends State<DashboardPageShimmerEffect> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(child: _buildShimmerContent()),
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

  // Widget _buildContentBox(String title, Color color) {
  //   return Container(
  //     height: 100,
  //     width: 100,
  //     color: color,
  //     child: Center(
  //         child: Text(title, style: const TextStyle(color: Colors.white))),
  //   );
  // }
}
