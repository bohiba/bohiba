import 'package:flutter/material.dart';

class RoadTaxScreen extends StatefulWidget {
  const RoadTaxScreen({super.key});

  @override
  State<RoadTaxScreen> createState() => _RoadTaxScreenState();
}

class _RoadTaxScreenState extends State<RoadTaxScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent.withOpacity(0),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text(
          "Road Tax",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w300,
          ),
        ),
        leading: const BackButton(
          color: Colors.deepPurple,
        ),
        leadingWidth: 25,
        elevation: 0,
      ),
      body: const Center(
        child: Text('Road Tax'),
      ),
    );
  }
}
