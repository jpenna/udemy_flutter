import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location,
  });

  final PlaceLocation? location;

  @override
  State<StatefulWidget> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLatLng;
  late bool _isSelecting;

  @override
  void initState() {
    _isSelecting = widget.location == null;
    _pickedLatLng = _isSelecting
        ? null
        : LatLng(widget.location!.latitude, widget.location!.longitude);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isSelecting ? 'Select the location' : 'Your Location',
        ),
        actions: [
          if (_isSelecting)
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(_pickedLatLng);
              },
              icon: const Icon(Icons.save),
            ),
        ],
      ),
      body: GoogleMap(
        onTap: _isSelecting
            ? (position) {
                setState(() {
                  _pickedLatLng = position;
                });
              }
            : null,
        initialCameraPosition: CameraPosition(
          target: _pickedLatLng ?? const LatLng(-14, -50),
          zoom: _isSelecting ? 8 : 16,
        ),
        markers: {
          if (_pickedLatLng != null)
            Marker(
              markerId: const MarkerId('A'),
              position: LatLng(
                _pickedLatLng!.latitude,
                _pickedLatLng!.longitude,
              ),
            ),
        },
      ),
    );
  }
}
