import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:rio_deep/features/vehicle/domain/entities/vehicle.dart';

class VehicleTapListener {
  final Map<String, Vehicle> vehicleData;
  final BuildContext context;
  final MapboxMap? mapboxMap;
  final Function(String) onVehicleSelected;

  VehicleTapListener(
      this.vehicleData, {
        required this.context,
        required this.mapboxMap,
        required this.onVehicleSelected,
      });

  void onTap(PointAnnotation annotation) {
    final vehicle =
    vehicleData[annotation.id];

    if(vehicle == null){
      return;
    }
    onVehicleSelected(vehicle.id);
    mapboxMap?.flyTo(
      CameraOptions(
        center: Point(
          coordinates: Position(vehicle.longitude, vehicle.latitude),
        ),

        zoom: 17,
      ),

      MapAnimationOptions(duration: 1000),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,

      builder: (_) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                Text(
                  vehicle.vehicleName,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 10),

                ListTile(
                  leading: Icon(Icons.directions_car),

                  title: Text("Type"),

                  subtitle: Text(vehicle.vehicleType),
                ),

                ListTile(
                  leading: Icon(Icons.person),

                  title: Text("Driver ID"),

                  subtitle: Text(vehicle.driverId),
                ),
                ListTile(
                  leading: Icon(
                    Icons.circle,
                    color: vehicle.status == "Moving"
                        ? Colors.green
                        : vehicle.status == "Stopped"
                        ? Colors.orange
                        : Colors.red,
                  ),

                  title: const Text("Status"),

                  subtitle: Text(vehicle.status),
                ),
                ListTile(
                  leading: Icon(Icons.speed),
                  title: Text("Speed"),
                  subtitle: Text("${vehicle.speed.toStringAsFixed(1)} km/h"),
                ),

                ListTile(
                  leading: Icon(Icons.route),
                  title: Text("Distance"),
                  subtitle: Text("${vehicle.distance.toStringAsFixed(2)} km"),
                ),

                ListTile(
                  leading: Icon(Icons.explore),
                  title: Text("Heading"),
                  subtitle: Text("${vehicle.heading.toStringAsFixed(1)}°"),
                ),
                ListTile(
                  leading: Icon(Icons.access_time),

                  title: Text("Last Update"),

                  subtitle: Text(vehicle.lastUpdated.toString()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
