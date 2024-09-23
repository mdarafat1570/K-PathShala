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
        itemCount: 10, // Number of items in the list
        itemBuilder: (context, index) => _buildShimmerEffect(),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListTile(
        // ignore: prefer_const_constructors
        leading: CircleAvatar(
          backgroundColor: Colors.white,
        ),
        title: Container(
          height: 20,
          color: Colors.white,
        ),
        subtitle: Container(
          height: 14,
          color: Colors.white,
        ),
      ),
    );
  }
}
