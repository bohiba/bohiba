import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animarker/flutter_map_marker_animation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  late GoogleMapController mapController;
  Set<Marker> _nearbyMarkers = {};
  final String googleApiKey = "";
  late LatLng _currentPosition ;
  late LocationPermission permission;
  bool _isLoading = true;
  late final Marker _marker = Marker(
    markerId: MarkerId('my_marker'),
    // Start with the default Google Maps pin, except yellow.
    // (Note: Hue isn't supported on all platforms.)
    position:LatLng(22.587496, 88.481264) ,
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),

    clusterManagerId: _myCluster.clusterManagerId,
  );
  final ClusterManager _myCluster = ClusterManager(
    clusterManagerId: ClusterManagerId('my cluster'),
  );
  late BitmapDescriptor petrolIcon;
  @override
  void initState() {
    super.initState();
    _loadCustomMarker();
    getLocation();
  }
  Future<void> _loadCustomMarker() async {
    petrolIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(42, 42)),
      'assets/images/petrol-station.png',
    );
  }
  Future<void> fetchNearbyPetrolPumps(LatLng location) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
         final lat = location.latitude;   // targeted area
         final lng = location.longitude; // targeted area
         final  radius = '10000'; // in km
         final  type = 'gas_station'; //location type


    try {
      final response = await http.get(Uri.parse('$url?location=$lat,$lng&radius=$radius&type=$type&key=$googleApiKey'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];

        debugPrint("Nearby Petrol Pump : $results");

        setState(() {
          _nearbyMarkers = results.map((place) {
            final lat = place['geometry']['location']['lat'];
            final lng = place['geometry']['location']['lng'];
            final name = place['name'];
            final id = place['place_id'];

            return Marker(
              markerId: MarkerId(id),
              position: LatLng(lat, lng),
              infoWindow: InfoWindow(
                title: name,
                snippet: place['vicinity'],
              ),
              icon: petrolIcon,

            );
          }).toSet();
        });
      }
    } catch (e) {
      debugPrint("Error fetching places: $e");
    }
  }
  getLocation() async {

    permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.best, distanceFilter: 10));
    double lat = position.latitude;
    double long = position.longitude;

    LatLng location = LatLng(22.587496, 88.481264);

    setState(() {
      _currentPosition = location;
      _isLoading = false;
    });
    fetchNearbyPetrolPumps(location);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Google Map'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SizedBox(
            height: height,
            child: _isLoading? const Center(child: CircularProgressIndicator(),) :
            GoogleMap(
              zoomControlsEnabled: true,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                clusterManagers: {_myCluster},
                markers: {
                  _marker,
                  ..._nearbyMarkers,

                },
                initialCameraPosition: CameraPosition(
                  target: _currentPosition,
                  zoom: 15,
                ),
               onMapCreated: _onMapCreated,
              onCameraMove: (onCameraMove){

               // mapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(onCameraMove.target.latitude, onCameraMove.target.longitude), 16));

                fetchNearbyPetrolPumps(LatLng(onCameraMove.target.latitude, onCameraMove.target.longitude));
              },
              )
          )
        ],
      ),
    );
  }


}
