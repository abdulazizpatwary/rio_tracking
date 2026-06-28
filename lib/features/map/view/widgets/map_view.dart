import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapView extends StatefulWidget {
  const MapView({super.key, required this.onMapCreated});
   final Function(MapboxMap controller)onMapCreated;

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {

  @override
  Widget build(BuildContext context) {
    return MapWidget(
      onMapCreated: widget.onMapCreated,
      viewport: CameraViewportState(
    center: Point(coordinates: Position(90.4125, 23.8103)),
    zoom: 12.0,
    ),

    );
  }
}
