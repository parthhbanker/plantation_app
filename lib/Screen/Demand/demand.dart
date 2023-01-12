import 'package:flutter/material.dart';

class DemandPage extends StatefulWidget {
  const DemandPage({super.key});

  @override
  State<DemandPage> createState() => _DemandPageState();
}

class _DemandPageState extends State<DemandPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demand Tree'),
      ),
    );
  }
}
