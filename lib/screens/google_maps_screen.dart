import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  const GoogleMapsScreen(
      {super.key, required this.latitude, required this.longitude});

  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  late CameraPosition _cameraPosition;
  late Set<Marker> _markers;
  late MarkerId _markerId;
  late LatLng _selectedLocation;

  @override
  void initState() {
    super.initState();
    _selectedLocation = LatLng(widget.latitude, widget.longitude);
    _cameraPosition = CameraPosition(
      target: _selectedLocation,
      zoom: 15,
    );

    _markers = {};
    _markerId =
        MarkerId(widget.latitude.toString() + widget.longitude.toString());

    _markers.add(
      Marker(
        markerId: _markerId,
        position: _selectedLocation,
        infoWindow: const InfoWindow(
          title: 'Your target location',
          snippet: 'a good place to visit',
        ),
        draggable: true,
        onDragEnd: (newPosition) {
          setState(() {
            _selectedLocation = newPosition;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context, _selectedLocation);
            },
          ),
        ],
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: _cameraPosition,
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        onTap: (LatLng position) {
          setState(() {
            _selectedLocation = position;
            _markers.clear();
            _markers.add(
              Marker(
                markerId: _markerId,
                position: _selectedLocation,
                draggable: true,
                onDragEnd: (newPosition) {
                  setState(() {
                    _selectedLocation = newPosition;
                  });
                },
              ),
            );
          });
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToLocation,
        label: const Text('To the location!'),
        icon: const Icon(Icons.directions_car),
      ),
    );
  }

  Future<void> _goToLocation() async {
    final GoogleMapController controller = await _controller.future;
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
  }
}
