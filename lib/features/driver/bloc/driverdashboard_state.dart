
import 'package:rio_deep/features/vehicle/domain/entities/vehicle.dart';

abstract class DriverDashboardState {}
abstract class DriverDashBoardActionState extends DriverDashboardState{}

class DashboardInitial
    extends DriverDashboardState {}

class VehicleLoading
    extends DriverDashboardState {}

class VehicleLoaded
    extends DriverDashboardState{

  final List<Vehicle>
  vehicles;

  VehicleLoaded(
      this.vehicles);
}

class VehicleEmpty
    extends DriverDashboardState {}

class VehicleError
    extends DriverDashboardState{

  final String message;

  VehicleError(
      this.message);
}


class NavigateToAddVehicle
    extends DriverDashBoardActionState{}

class NavigateToTrack
    extends DriverDashBoardActionState{}

class NavigateToEditVehicle
    extends DriverDashBoardActionState{

  final Vehicle vehicle;

  NavigateToEditVehicle(
      this.vehicle);
}