import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../pages/truck/truck_all_page.dart';
import 'package:flutter/material.dart';

class MapAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const MapAppBar({
    super.key,
    this.title = "Map",
  });

  @override
  Size get preferredSize => const Size.fromHeight(55);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        title: Text(title),
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        actions: [
          // Add Vehicle
          IconButton(
            tooltip: 'Add Truck',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllTruckPage(),
                ),
              );
            },
            icon: FaIcon(FontAwesomeIcons.plus),
          ),

          IconButton(
            tooltip: 'Search Company',
            onPressed: () {
              // showSearch(
              //   context: context,
              //   delegate: BohibaSearchDelegate(
              //       items: [],
              //       searchPredicate: (item, String query) {
              //         return Text('data');
              //       },
              //       itemBuilder: (BuildContext context, item) {
              //         return Text(item);
              //       }),
              // );
            },
            icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
          ),
        ],
      ),
    );
  }
}
