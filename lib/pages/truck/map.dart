import 'package:flutter/material.dart';
import '/component/bohiba_appbar/map_appbar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        //AppBar
        appBar: MapAppBar(),
        body: Center(child: Text('Map Screen')));
  }
}
