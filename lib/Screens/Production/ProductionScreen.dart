import 'package:flutter/material.dart';

class ProductionOverview extends StatefulWidget {
  const ProductionOverview({super.key});

  @override
  State<ProductionOverview> createState() => _ProductionOverviewState();
}

class _ProductionOverviewState extends State<ProductionOverview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Production Overview')),
      body: const Center(child: Text('Production Screen Content Goes Here')),
    );
  }
}
