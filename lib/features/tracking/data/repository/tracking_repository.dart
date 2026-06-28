import 'package:rio_deep/features/tracking/domain/entities/vehicle_position.dart';
import 'package:rio_deep/features/vehicle/domain/entities/vehicle.dart';

abstract class TrackingRepository {
  Future<void>requestPermission();
  Stream<VehiclePosition>getLocationStream();
  Stream<List<Vehicle>>
  getVehicles();

}