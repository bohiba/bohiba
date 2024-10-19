import 'package:bohiba/component/bohiba_appbar/title_appbar.dart';
import 'package:flutter/material.dart';

class AddLoadScreen extends StatelessWidget {
  const AddLoadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TitleAppbar(
        title: 'Add Loads',
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
