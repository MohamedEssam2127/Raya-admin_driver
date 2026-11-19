import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../bloc/map_cubit.dart';
import '../bloc/map_state.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MapCubit()..init(),
      child: const _MapScreenView(),
    );
  }
}

class _MapScreenView extends StatefulWidget {
  const _MapScreenView();

  @override
  State<_MapScreenView> createState() => _MapScreenViewState();
}

class _MapScreenViewState extends State<_MapScreenView> {
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: BlocConsumer<MapCubit, MapState>(
        listenWhen: (previous, current) =>
            previous.currentPosition != current.currentPosition,
        listener: (context, state) {
          _mapController?.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: state.currentPosition,
                zoom: 15.0,
                bearing: state.heading,
              ),
            ),
          );
        },
        builder: (context, state) {
          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: state.currentPosition,
              zoom: 14.0,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: true,
            markers: {
              Marker(
                markerId: const MarkerId('driver_marker'),
                position: state.currentPosition,
                icon: state.markerIcon ?? BitmapDescriptor.defaultMarker,
                rotation: state.heading,
                anchor: const Offset(0.5, 0.5),
                flat: true,
              ),
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
