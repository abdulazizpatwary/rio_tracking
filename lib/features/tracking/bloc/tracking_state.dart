import 'package:rio_deep/features/vehicle/domain/entities/vehicle.dart';

abstract class TrackingState {}
class TrackingInitialState extends TrackingState{}
class TrackingLoadingState extends TrackingState{

}
class TrackingEndState extends TrackingState{}
class TrackingUpdatedState extends TrackingState {
  final double latitude;
  final double longtitude;

  final double speed;
  final double distance;
  final double heading;

  final List<Vehicle> vehicles;




  TrackingUpdatedState({
    required this.latitude,
    required this.longtitude,
    required this.speed,
    required this.distance, required this.heading, required this.vehicles,

  });
}
class TrackingErrorState extends TrackingState{
  final String errorMsg;

  TrackingErrorState({required this.errorMsg});
}