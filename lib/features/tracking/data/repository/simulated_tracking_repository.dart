import 'dart:async';

import 'package:rio_deep/features/tracking/data/repository/tracking_repository.dart';
import 'package:rio_deep/features/tracking/domain/entities/vehicle_position.dart';
import 'package:rio_deep/features/vehicle/domain/entities/vehicle.dart';

class SimulatedTrackingRepository
    implements TrackingRepository {

  Timer? _timer;

  @override
  Stream<VehiclePosition>
  getLocationStream() {

    late StreamController<
        VehiclePosition>
    streamController;

    streamController =
        StreamController<
            VehiclePosition>();

    double lat = 23.8103;
    double lng = 90.4125;

    _timer = Timer.periodic(

      const Duration(
        seconds: 2,
      ),

          (timer){

        lat += 0.0005;
        lng += 0.0005;

        streamController.add(

          VehiclePosition(
            latitude: lat,
            longtitude: lng,
          ),

        );
      },
    );

    streamController.onCancel = () {

      _timer?.cancel();

      streamController.close();

    };

    return streamController.stream;
  }

  @override
  Future<void>
  requestPermission()
  async {

    return;
  }

  @override
  Stream<List<Vehicle>>
  getVehicles(){

    return Stream.value(
      [],
    );
  }

}