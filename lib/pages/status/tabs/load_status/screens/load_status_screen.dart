import 'package:bohiba/routes/bohiba_route.dart';
import 'package:flutter/material.dart';
import 'package:bohiba/utils/bohiba_colors.dart';

class LoadStatusScreen extends StatelessWidget {
  const LoadStatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bohibaColors.bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.5),
              child: ListTile(
                onTap: () =>
                    Navigator.of(context).pushNamed(BohibaRoute.viewChallan),
                title: const Text('0D 14A 7224'),
                subtitle: const Text('26.59 Tonne'),
                trailing: const Text("OMC - JSW"),
              ),
            );
          },
        ),
      ),
    );
  }
}
