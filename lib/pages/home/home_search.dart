import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

class HomeSearchField extends StatelessWidget {
  const HomeSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextField(
        decoration: InputDecoration(
            prefixIcon: const Icon(
              Remix.search_line,
            ),
            prefixIconColor: Theme.of(context).primaryColor),
      ),
    );
  }
}
