import 'dart:convert';

import 'package:favorite_places/consts.dart';
import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({
    super.key,
    required this.onSelectLocation,
  });

  final void Function(PlaceLocation selectedLocation) onSelectLocation;

  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _selectedLocation;
  bool _isGettingLocation = false;

  void _setSelectedLocation(LatLng latLng) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=$API_KEY',
    );

    final response = await http.get(url);
    final decoded = json.decode(response.body);

    setState(() {
      _selectedLocation = PlaceLocation(
        latitude: latLng.latitude,
        longitude: latLng.longitude,
        address: decoded['results'][0]['formatted_address'],
      );
    });

    widget.onSelectLocation(_selectedLocation!);
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    LocationData foundLocation = await location.getLocation();

    final lat = foundLocation.latitude;
    final long = foundLocation.longitude;

    if (lat == null || long == null) {
      return;
    }

    _setSelectedLocation(LatLng(lat, long));

    setState(() {
      _isGettingLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget containerContent;

    if (_isGettingLocation) {
      containerContent = const CircularProgressIndicator();
    } else if (_selectedLocation != null) {
      containerContent = Image.network(
        _selectedLocation!.imageUrl,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      containerContent = Center(
        child: Text(
          _selectedLocation != null
              ? _selectedLocation!.address
              : 'Pick a location',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      );
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 160,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: containerContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.pin_drop),
              label: const Text('Use current location'),
            ),
            TextButton.icon(
              onPressed: () async {
                LatLng? selectedLocation = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MapScreen()),
                );
                if (selectedLocation == null) {
                  return;
                }
                print(
                  '${selectedLocation.latitude} ${selectedLocation.longitude}',
                );
                _setSelectedLocation(selectedLocation);
              },
              icon: const Icon(Icons.map),
              label: const Text('Pick on map'),
            ),
          ],
        ),
      ],
    );
  }
}
