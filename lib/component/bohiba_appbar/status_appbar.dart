import 'package:bohiba/pages/vehicle/all_vechile_screen/all_vehicle_screen.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class StatusAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const StatusAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(55);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(45),
      child: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(title),
        actions: [
          // Add Vehicle
          IconButton(
            tooltip: 'Add Vehicle',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllVehicleScreen(),
                ),
              );
            },
            icon: const Icon(EvaIcons.plus),
          ),
        ],
      ),
    );
  }
}
