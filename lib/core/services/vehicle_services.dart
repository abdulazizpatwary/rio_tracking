import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rio_deep/features/vehicle/domain/entities/vehicle.dart';

class VehicleService {

  Stream<QuerySnapshot<Map<String, dynamic>>> getVehicles(){

    return  FirebaseFirestore.instance
        .collection("vehicles")
        .snapshots();
  }
}