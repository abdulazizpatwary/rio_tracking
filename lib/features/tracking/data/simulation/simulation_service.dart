import 'package:rio_deep/features/tracking/domain/entities/vehicle_position.dart';

class SimulationLocationService{
  Stream<VehiclePosition>getLocationStream()async*{
    double lat=23.8103;
    double lng=90.4125;

    while(true){

      await Future.delayed(
        const Duration(seconds:1),
      );

      lat+=0.0001;
      lng+=0.0001;

      yield VehiclePosition(
        latitude: lat,

        speed: 15, longtitude: lng,
      );

    }

  }

}
