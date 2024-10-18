import 'package:bohiba/utils/bohiba_appbar/load_appbar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class AllLoadScreen extends StatelessWidget {
  const AllLoadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LoadAppBar(
        title: 'Loads',
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: List.generate(3, (int index) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: ListTile(
                  title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('C-1'),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(EvaIcons.diagonalArrowRightUp),
                  ),
                  Text('C-1')
                ],
              )),
            );
          }),
        ),
      ),
    );
  }
}
