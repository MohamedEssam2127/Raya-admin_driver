import 'dart:math';
import 'package:driver_admin/core/utils/map_marker_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit({double initialHeading = 0.0})
      : super(MapState.initial());

  /// Initializes marker icon using MapMarkerHelper
  Future<void> init() async {
    try {
      final markerIcon = await MapMarkerHelper.createDriverCarMarkerBitmap();
      emit(state.copyWith(
        markerIcon: markerIcon,
      ));
    } catch (_) {
      emit(state.copyWith(
        markerIcon: BitmapDescriptor.defaultMarker,
      ));
    }
  }

  /// Calculates bearing between two coordinates in degrees (0 - 360)
  double _calculateBearing(LatLng start, LatLng end) {
    final double lat1 = start.latitude * (pi / 180.0);
    final double lng1 = start.longitude * (pi / 180.0);
    final double lat2 = end.latitude * (pi / 180.0);
    final double lng2 = end.longitude * (pi / 180.0);

    final double dLng = lng2 - lng1;
    final double y = sin(dLng) * cos(lat2);
    final double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLng);
    final double bearing = atan2(y, x);

    return (bearing * (180.0 / pi) + 360.0) % 360.0;
  }

  /// Updates marker location and recalculates heading/bearing
  void updateLocation(LatLng newPosition) {
    final newBearing = _calculateBearing(state.currentPosition, newPosition);
    emit(state.copyWith(
      currentPosition: newPosition,
      heading: newBearing,
    ));
  }

  /// Explicitly sets the marker heading in degrees (0 - 360)
  void setHeading(double newHeading) {
    emit(state.copyWith(heading: newHeading));
  }
}
