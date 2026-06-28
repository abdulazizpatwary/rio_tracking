import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rio_deep/features/tracking/data/repository/tracking_repository.dart';
import 'package:rio_deep/features/tracking/domain/entities/vehicle_position.dart';
import 'package:rio_deep/features/vehicle/domain/entities/vehicle.dart';

class TrackingRepositoryImplementation implements TrackingRepository {
  Position? previousPosition;
  double totalDistance = 0;


  TrackingRepositoryImplementation(
      );


  @override
  Future<void> requestPermission() async {

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location service disabled");
    }

    LocationPermission locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
    }
    if (locationPermission == LocationPermission.deniedForever) {
      throw Exception("Location Permission denied permanently");
    }
  }

  @override
  Stream<VehiclePosition> getLocationStream() {
    // TODO: implement getLocationStream
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    ).map(
      (position) {
        if(previousPosition !=null){
          totalDistance+=Geolocator.distanceBetween(previousPosition!.latitude, previousPosition!.longitude, position.latitude, position.longitude);
        }
        previousPosition=position;
        return VehiclePosition(
          latitude: position.latitude,
          longtitude: position.longitude,
          speed: position.speed*3.6,
          distance: totalDistance/1000,
          heading: position.heading
        );

      }
    );
  }

  @override
  Stream<List<Vehicle>> getVehicles() {
    return FirebaseFirestore.instance
        .collection("vehicles")
        .snapshots()
        .map(

          (snapshot){

        return snapshot.docs
            .map((doc){

          final data =
          doc.data();

          return Vehicle(

            id: data["id"],

            vehicleName:
            data["vehicleName"],

            vehicleNumber:
            data["vehicleNumber"],

            vehicleType:
            data["vehicleType"],

            driverId:
            data["driverId"],

            latitude:
            (data["latitude"] as num)
                .toDouble(),

            longitude:
            (data["longitude"] as num)
                .toDouble(),

            status:
            data["status"],

            speed:
            (data["speed"] as num)
                .toDouble(),

            distance:
            (data["distance"] as num)
                .toDouble(),

            heading:
            (data["heading"] as num)
                .toDouble(),

            lastUpdated:
            DateTime.fromMillisecondsSinceEpoch(
              data["lastUpdated"],
            ),
          );

        }).toList();
      },
    );

  }


}
