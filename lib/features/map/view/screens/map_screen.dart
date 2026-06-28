import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:rio_deep/app/app_assets.dart';
import 'package:rio_deep/features/map/view/widgets/map_view.dart';
import 'package:rio_deep/features/map/view/widgets/vehicle_tap_listner.dart';
import 'package:rio_deep/features/tracking/bloc/tracking_bloc.dart';
import 'package:rio_deep/features/tracking/bloc/tracking_event.dart';
import 'package:rio_deep/features/tracking/bloc/tracking_state.dart';
import 'package:rio_deep/features/vehicle/domain/entities/vehicle.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, this.driverId});

  final String? driverId;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapboxMap? mapboxMap;
  PointAnnotationManager? _pointAnnotationManager;
  final Map<String, PointAnnotation> vehicleMarkers = {};
  Uint8List? carImage;
  PolylineAnnotationManager? _polylineManager;
  PolylineAnnotation? _polyline;
  List<Position> routePoints = [];
  Map<String, Uint8List> vehicleImages = {};
  final Map<String, Vehicle> vehicleData = {};
  String? selectedVehicleId;
  int totalVehicles = 0;

  //double currentRotation = 55;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //context.read<TrackingBloc>().add(StartTrackingEvent());
    //loadMarker();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadMarker();
  }

  Future<void> loadMarker() async {
    Future<Uint8List> load(String path) async {
      final bytes = await DefaultAssetBundle.of(context).load(path);

      return bytes.buffer.asUint8List();
    }

    vehicleImages = {
      "Car": await load(AppAssets.carImageUrl),

      "Motorcycle": await load(AppAssets.bikeImageUrl),

      "Cycle": await load(AppAssets.cycleImageUrl),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildTrackingFloatingButton(context),
      body: Stack(
        children: [
          BlocListener<TrackingBloc, TrackingState>(
            listener: _blocListener,
            child: MapView(
              onMapCreated: (MapboxMap controller) async {
                mapboxMap = controller;
                _pointAnnotationManager = await mapboxMap?.annotations
                    .createPointAnnotationManager();
                _polylineManager = await mapboxMap?.annotations
                    .createPolylineAnnotationManager();
                await mapboxMap?.location.updateSettings(
                  LocationComponentSettings(pulsingEnabled: false),
                );
                _pointAnnotationManager?.tapEvents(
                  onTap: (annotation) {
                    VehicleTapListener(
                      vehicleData,
                      context: context,
                      mapboxMap: mapboxMap,
                      onVehicleSelected: (id) {
                        setState(() {
                          selectedVehicleId = id;
                        });
                      },
                    ).onTap(annotation);
                  },
                );
              },
            ),
          ),
          _buildMapheaderSection(),
        ],
      ),
    );
  }

  Widget _buildTrackingFloatingButton(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: 'start',
          onPressed: () async {
            routePoints.clear();

            if (_polyline != null) {
              await _polylineManager?.delete(_polyline!);
              _polyline = null;
            }

              context.read<TrackingBloc>().add(StartTrackingEvent());



          },
          child: Icon(Icons.play_arrow),
        ),
        SizedBox(height: 12),
        FloatingActionButton(
          heroTag: 'stop',
          onPressed: () {
            routePoints.clear();

            context.read<TrackingBloc>()
                .add(EndTrackingEvent());
          },
          child: Icon(Icons.stop),
        ),
      ],
    );
  }

  Future<void> _blocListener(BuildContext context, TrackingState state) async {
            if (state is TrackingLoadingState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tracking Started')),
              );
            }
            if (state is TrackingEndState) {
              routePoints.clear();


              _polyline = null;

              vehicleMarkers.clear();

              await _pointAnnotationManager?.deleteAll();
              if (_polyline != null) {
                await _polylineManager?.delete(_polyline!);

                _polyline = null;
              }
            }
            if (state is TrackingErrorState) {
              //debugPrint(state.errorMsg);
            }

            if (state is TrackingUpdatedState) {
              if (vehicleImages.isEmpty) {
                return;
              }
              final vehicles = widget.driverId == null
                  ? state.vehicles
                  : state.vehicles
                        .where(
                          (vehicle) => vehicle.driverId == widget.driverId,
                        )
                        .toList();

              setState(() {
                totalVehicles = vehicles.length;
              });

              if (vehicles.isNotEmpty) {
                final vehicle = vehicles.first;
                mapboxMap?.flyTo(
                  CameraOptions(
                    center: Point(
                      coordinates: Position(
                        vehicle.longitude,
                        vehicle.latitude,
                      ),
                    ),
                    zoom: 15,
                  ),
                  MapAnimationOptions(duration: 500),
                );
              }

              for (final vehicle in vehicles) {
                final point = Point(
                  coordinates: Position(vehicle.longitude, vehicle.latitude),
                );

                if (vehicleMarkers.containsKey(vehicle.id)) {
                  vehicleMarkers[vehicle.id]!.geometry = point;
                  vehicleMarkers[vehicle.id]!.iconRotate = vehicle.heading;

                  await _pointAnnotationManager?.update(
                    vehicleMarkers[vehicle.id]!,
                  );
                } else {
                  final marker = await _pointAnnotationManager?.create(
                    PointAnnotationOptions(
                      geometry: point,
                      image: vehicleImages[vehicle.vehicleType],
                      //iconRotate: vehicle.heading,
                      iconSize: vehicle.id == selectedVehicleId ? 0.18 : 0.12,
                    ),
                  );

                  vehicleMarkers[vehicle.id] = marker!;
                  vehicleData[marker.id] = vehicle;
                }
              }
              if (vehicles.isNotEmpty) {


                routePoints.add(Position(vehicles.first.longitude,
                  vehicles.first.latitude,));
              }

              if (_polyline == null) {

                _polyline =
                await _polylineManager?.create(

                  PolylineAnnotationOptions(
                    geometry: LineString(
                      coordinates: routePoints,
                    ),
                    lineWidth: 5,
                  ),
                );

              } else {

                try {

                  _polyline!.geometry =
                      LineString(
                        coordinates: routePoints,
                      );

                  await _polylineManager
                      ?.update(_polyline!);

                } catch (e) {

                  debugPrint(
                    "Polyline update error: $e",
                  );

                }
              }
            }
          }

  Widget _buildMapheaderSection() {
    return Positioned(
          top: 50,
          right: 20,
          left: 20,
          child: BlocBuilder<TrackingBloc, TrackingState>(
            builder: (context, state) {
              double speed = 0;
              double distance = 0;
              String status = "Stopped";

              if (state is TrackingUpdatedState &&
                  state.vehicles.isNotEmpty) {
                speed = state.speed;

                distance = state.distance;

                status = state.vehicles.first.status;
              }

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,

                    children: [
                      _buildSpeedDIstanceMeeter('Speed', speed),

                      _buildSpeedDIstanceMeeter('Distance', distance),

                      Column(children: [const Text("Status"), Text(status)]),
                      Column(
                        children: [
                          const Text("Vehicles"),

                          Text(totalVehicles.toString()),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
  }

  Widget _buildSpeedDIstanceMeeter(String name, double value) {
    String postFix = '';
    if (name == 'Speed') {
      postFix = 'km/h';
    } else {
      postFix = 'km';
    }
    return Column(
      children: [Text(name), Text('${value.toStringAsFixed(1)}$postFix')],
    );
  }
  @override
  void dispose() {

    routePoints.clear();

    context.read<TrackingBloc>()
        .add(
      EndTrackingEvent(),
    );

    super.dispose();
  }
}

