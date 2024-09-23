import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TestSetsPageShimmer extends StatefulWidget {
  @override
  _TestSetsPageShimmerState createState() => _TestSetsPageShimmerState();
}

class _TestSetsPageShimmerState extends State<TestSetsPageShimmer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 6, // Number of shimmer items
        itemBuilder: (context, index) => _buildShimmerEffect(),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8.0),
        child: Container(
          height: 110,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
