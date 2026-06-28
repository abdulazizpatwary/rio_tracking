import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rio_deep/features/vehicle/domain/entities/vehicle.dart';

class VehicleRepository {

  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  Future<void> addVehicle(
      Vehicle vehicle) async {

    await firestore
        .collection("vehicles")
        .doc(vehicle.id)
        .set({

      "id": vehicle.id,
      "vehicleName":
      vehicle.vehicleName,

      "vehicleNumber":
      vehicle.vehicleNumber,

      "vehicleType":
      vehicle.vehicleType,

      "driverId":
      vehicle.driverId,

      "latitude":
      vehicle.latitude,

      "longitude":
      vehicle.longitude,

      "status":
      vehicle.status,

      "speed":
      vehicle.speed,

      "distance":
      vehicle.distance,

      "heading":
      vehicle.heading,

      "lastUpdated":
      vehicle.lastUpdated
          .millisecondsSinceEpoch,
    });
  }

  Stream<List<Vehicle>>
  getVehicles(
      String driverId){

    return firestore
        .collection("vehicles")
        .where(
      "driverId",
      isEqualTo: driverId,
    )
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
            data["latitude"],

            longitude:
            data["longitude"],

            status:
            data["status"],

            speed:
            data["speed"],

            distance:
            data["distance"],

            heading:
            data["heading"],

            lastUpdated:
            DateTime.fromMillisecondsSinceEpoch(
                data["lastUpdated"]),
          );

        }).toList();
      },
    );
  }
  Future<void> updateVehicle(Vehicle vehicle) async {

    await FirebaseFirestore.instance
        .collection("vehicles")
        .doc(vehicle.id)
        .update({

      "latitude": vehicle.latitude,
      "longitude": vehicle.longitude,
      "speed": vehicle.speed,
      "distance": vehicle.distance,
      "heading": vehicle.heading,
      "status": vehicle.status,
      "lastUpdated":
      vehicle.lastUpdated.millisecondsSinceEpoch,
    });
  }
  Future<void> deleteVehicle(
      String vehicleId) async {

    await firestore
        .collection("vehicles")
        .doc(vehicleId)
        .delete();
  }
}