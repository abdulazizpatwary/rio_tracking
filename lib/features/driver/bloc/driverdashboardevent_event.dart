import 'package:rio_deep/features/vehicle/domain/entities/vehicle.dart';


abstract class DriverDashboardEvent {}

class LoadVehicles
    extends DriverDashboardEvent {

  final String driverId;

  LoadVehicles(this.driverId);
}

class DeleteVehicle
    extends DriverDashboardEvent {

  final String vehicleId;

  DeleteVehicle(this.vehicleId);
}

class GoToAddVehicle
    extends DriverDashboardEvent {}

class GoToTrackVehicle
    extends DriverDashboardEvent {}

class GoToEditVehicle
    extends DriverDashboardEvent {

  final Vehicle vehicle;

  GoToEditVehicle(
      this.vehicle);
}