import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rio_deep/features/auth/domain/entities/driver.dart';
import 'package:rio_deep/features/driver/bloc/driverdashboard_bloc.dart';
import 'package:rio_deep/features/driver/bloc/driverdashboardevent_event.dart';
import 'package:rio_deep/features/vehicle/domain/entities/vehicle.dart';

class VehicleItemCardWidget extends StatelessWidget {
  const VehicleItemCardWidget({
    super.key,
    required this.vehicle,
    required this.currentDriver,
  });

  final Vehicle vehicle;
  final Driver currentDriver;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,

      margin: const EdgeInsets.only(bottom: 12),

      child: Padding(
        padding: const EdgeInsets.all(12),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                const Icon(Icons.directions_car),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    vehicle.vehicleName,

                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Container(
                  width: 10,
                  height: 10,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    color:
                    DateTime.now()
                        .difference(vehicle.lastUpdated)
                        .inSeconds <
                        10
                        ? Colors.green
                        : Colors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text("Number: ${vehicle.vehicleNumber}"),

            Text("Type: ${vehicle.vehicleType}"),

            Text("Status: ${vehicle.status}"),

            Text(
              "Updated: ${vehicle.lastUpdated.hour}:${vehicle.lastUpdated.minute}",
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,

              children: [
                IconButton(
                  onPressed: () async {
                    context.read<DriverDashboardBloc>().add(
                      GoToEditVehicle(vehicle),
                    );
                  },

                  icon: const Icon(Icons.edit),
                ),

                IconButton(
                  onPressed: () async {
                    context.read<DriverDashboardBloc>().add(
                      DeleteVehicle(vehicle.id),
                    );
                  },

                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
