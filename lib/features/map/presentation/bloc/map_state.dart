import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapState {
  final LatLng currentPosition;
  final double heading;
  final BitmapDescriptor? markerIcon;

  const MapState({
    required this.currentPosition,
    this.heading = 190.0,
    this.markerIcon,
  });

  factory MapState.initial() {
    const defaultPosition = LatLng(30.0444, 31.2357); // Cairo, Egypt
    return const MapState(
      currentPosition: defaultPosition,
      heading: 0.0,
      markerIcon: null,
    );
  }

  MapState copyWith({
    LatLng? currentPosition,
    double? heading,
    BitmapDescriptor? markerIcon,
  }) {
    return MapState(
      currentPosition: currentPosition ?? this.currentPosition,
      heading: heading ?? this.heading,
      markerIcon: markerIcon ?? this.markerIcon,
    );
  }
}
