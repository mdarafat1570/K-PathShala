import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildShimmerLoadingEffect() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      children: [
        _buildShimmerContainer(height: 180),
        const SizedBox(height: 10),
        _buildShimmerContainer(height: 100, width: 150),
        _buildShimmerContainer(height: 100, width: 150),
        _buildShimmerContainer(height: 100, width: 150),
        _buildShimmerContainer(height: 100, width: 150),
        _buildShimmerContainer(height: 100, width: 150),
        _buildShimmerContainer(height: 100, width: 150),
        _buildShimmerContainer(height: 100, width: 150),
        _buildShimmerContainer(height: 100, width: 150),
        _buildShimmerContainer(height: 100, width: 150),
      ],
    ),
  );
}

Widget _buildShimmerContainer({
  required double height,
  double? width,
}) {
  return Container(
    height: height,
    width: width,
    margin: const EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      color: Colors.grey[300],
      borderRadius: BorderRadius.circular(10.0),
    ),
  );
}

List<Widget> _buildShimmerRows(int count) {
  return List.generate(
    count,
    (index) => Row(
      children: [
        _buildShimmerContainer(height: 35, width: 35),
        _buildShimmerContainer(height: 35, width: 200),
      ],
    ),
  );
}
