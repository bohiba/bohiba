import 'package:flutter/material.dart';

class StatusAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const StatusAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(55);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(title),
        actions: [
          // Add Vehicle
          /*IconButton(
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
          ),*/
        ],
      ),
    );
  }
}
