import 'package:flutter/material.dart';

// Define the Item class for holding data
class Item {
  final String title;
  final String description;
  final int score; // Add score variable
  int count; // Add count variable to manage individual item state

  Item({
    required this.title,
    required this.description,
    required this.score,
    this.count = 0, // Initialize count
  });
}

// Define the list of items
final List<Item> items = [
  Item(
    title: 'EPS TOPIK Set 01',
    description: 'Contains questions from chapter 1, 2, 4 and 11',
    score: 40, // Example score
  ),
  Item(
    title: 'Item 2',
    description: 'Description 2',
    score: 35, // Example score
  ),
  Item(
    title: 'Item 3',
    description: 'Description 3',
    score: 40, // Example score
  ),
  Item(
    title: 'Item 4',
    description: 'Description 4',
    score: 30, // Example score
  ),
];
