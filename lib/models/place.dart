import 'dart:io';

import 'package:favorite_places/consts.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class PlaceLocation {
  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  final double latitude;
  final double longitude;
  final String address;

  String get imageUrl {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$API_KEY';
  }
}

class Place {
  Place({required this.title, required this.image, required this.location})
      : id = uuid.v4();

  final String id;
  final String title;
  final File image;
  final PlaceLocation location;
}
