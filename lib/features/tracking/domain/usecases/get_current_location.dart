import 'package:rio_deep/features/tracking/data/repository/tracking_repository.dart';
import 'package:rio_deep/features/tracking/domain/entities/vehicle_position.dart';

class GetCurrentLocation {
  final TrackingRepository trackingRepository;
  GetCurrentLocation({required this.trackingRepository});
  Future<void>requestLocationPermission()async{
    await trackingRepository.requestPermission();
  }
  Stream<VehiclePosition>call(){
    return trackingRepository.getLocationStream();
  }
}