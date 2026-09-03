import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PRODUCT DETAILS'),
      ),
      body: const Center(
        child: Text('PRODUCT DETAILS'),
      ),
    );
  }
}