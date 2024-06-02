import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gracieusgalerij/screens/user/pick_location.dart';
import 'package:gracieusgalerij/screens/user/review/review_edit_screen.dart';

class GoogleMapWidget extends StatefulWidget {
  final LatLng? initialLocation;

  GoogleMapWidget({this.initialLocation});

  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  LatLng? _pickedLocation;

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  Future<void> _selectLocation() async {
    final LatLng? pickedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ReviewEditScreen(),
      ),
    );
    if (pickedLocation != null) {
      setState(() {
        _pickedLocation = pickedLocation;
        _markers = {
          Marker(
            markerId: MarkerId('picked-location'),
            position: pickedLocation,
          ),
        };
        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: pickedLocation,
              zoom: 16,
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _pickedLocation ?? widget.initialLocation ?? LatLng(0, 0),
        zoom: 15,
      ),
      markers: _markers,
      onTap: (LatLng location) {
        // Fungsi ini akan dipanggil ketika pengguna mengetuk peta
        // Anda dapat menangani logika untuk menambahkan penanda atau tindakan lain di sini
      },
    );
  }
}
