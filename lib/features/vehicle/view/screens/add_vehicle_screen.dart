import 'package:flutter/material.dart';
import 'package:rio_deep/features/auth/domain/entities/driver.dart';
import 'package:rio_deep/features/vehicle/data/repository/vehicle_repository.dart';
import 'package:rio_deep/features/vehicle/domain/entities/vehicle.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key, this.vehicle, required this.driver});

  final Vehicle? vehicle;
  final Driver driver;

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final vehicleNameController = TextEditingController();

  final vehicleNumberController = TextEditingController();

  String selectedType = "Car";
  final VehicleRepository vehicleRepository = VehicleRepository();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.vehicle != null) {
      vehicleNameController.text = widget.vehicle!.vehicleName;

      vehicleNumberController.text = widget.vehicle!.vehicleNumber;

      selectedType = widget.vehicle!.vehicleType;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Vehicle")),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              controller: vehicleNameController,

              decoration: const InputDecoration(labelText: "Vehicle Name"),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: vehicleNumberController,

              decoration: const InputDecoration(labelText: "Vehicle Number"),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField(
              initialValue: selectedType,

              items: const [
                DropdownMenuItem(value: "Car", child: Text("Car")),

                DropdownMenuItem(
                  value: "Motorcycle",
                  child: Text("Motorcycle"),
                ),

                DropdownMenuItem(value: "Cycle", child: Text("Cycle")),
              ],

              onChanged: (value) {
                setState(() {
                  selectedType = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
                onPressed: () async {

                  final vehicle = Vehicle(

                    id: widget.vehicle?.id ??
                        DateTime.now()
                            .millisecondsSinceEpoch
                            .toString(),

                    vehicleName:
                    vehicleNameController.text,

                    vehicleNumber:
                    vehicleNumberController.text,

                    vehicleType:
                    selectedType,

                    driverId:
                    widget.driver.id,

                    latitude: 0,
                    longitude: 0,

                    status: "Stopped",

                    speed: 0,
                    distance: 0,
                    heading: 0,

                    lastUpdated:
                    DateTime.now(),
                  );

                  await vehicleRepository
                      .addVehicle(vehicle);

                  Navigator.pop(
                    context,
                    vehicle,
                  );
                },

              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
