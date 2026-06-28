import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rio_deep/features/auth/domain/entities/driver.dart';
import 'package:rio_deep/features/driver/bloc/driverdashboard_bloc.dart';
import 'package:rio_deep/features/driver/bloc/driverdashboard_state.dart';
import 'package:rio_deep/features/driver/bloc/driverdashboardevent_event.dart';
import 'package:rio_deep/features/driver/view/widgets/vehicle_card_item.dart';
import 'package:rio_deep/features/map/view/screens/map_screen.dart';
import 'package:rio_deep/features/vehicle/view/screens/add_vehicle_screen.dart';

class DriverDashboard extends StatefulWidget {
  const DriverDashboard({super.key, required this.currentDriver});

  final Driver currentDriver;

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      context.read<DriverDashboardBloc>().add(LoadVehicles(widget.currentDriver.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DriverDashboardBloc, DriverDashboardState>(
      listenWhen: (previous, current) => current is DriverDashBoardActionState,
      buildWhen: (previous, current) => current is! DriverDashBoardActionState,
      listener: (context, state) async {
        if (state is NavigateToAddVehicle) {
          await Navigator.push(
            context,

            MaterialPageRoute(
              builder: (_) => AddVehicleScreen(driver: widget.currentDriver),
            ),
          );
        }
        if (state is NavigateToEditVehicle) {
          await Navigator.push(
            context,

            MaterialPageRoute(
              builder: (_) => AddVehicleScreen(driver: widget.currentDriver),
            ),
          );
        }
        if (state is NavigateToTrack) {
          Navigator.push(
            context,

            MaterialPageRoute(
              builder: (_) => MapScreen(driverId: widget.currentDriver.id),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("${widget.currentDriver.name}'s Dashboard"),
          ),

          body: Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    context.read<DriverDashboardBloc>().add(GoToAddVehicle());
                  },

                  child: const Text("Add Vehicle"),
                ),

                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    context.read<DriverDashboardBloc>().add(GoToTrackVehicle());
                  },

                  child: const Text("Track My Vehicle"),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: state is VehicleLoading
                      ? const Center(child: CircularProgressIndicator())
                      : state is VehicleEmpty
                      ? const Center(child: Text("No Vehicles"))
                      : state is VehicleLoaded
                      ? ListView.builder(
                          itemCount: state.vehicles.length,

                          itemBuilder: (_, index) {
                            final vehicle = state.vehicles[index];

                            return VehicleItemCardWidget(
                              vehicle: vehicle,

                              currentDriver: widget.currentDriver,
                            );
                          },
                        )
                      : state is VehicleError
                      ? Center(child: Text(state.message))
                      : const SizedBox(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

