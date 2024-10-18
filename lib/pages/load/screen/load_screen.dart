import 'package:bohiba/utils/bohiba_appbar/load_appbar.dart';
import 'package:flutter/material.dart';

class LoadScreen extends StatelessWidget {
  const LoadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: LoadAppBar(
        title: 'Load',
      ),
      body: Column(),
    );
  }
}
