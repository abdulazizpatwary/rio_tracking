import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rio_deep/features/auth/domain/entities/driver.dart';

class DriverRepository {

  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  Future<void> addDriver(
      Driver driver) async {

    await firestore
        .collection("drivers")
        .doc(driver.id)
        .set({

      "id": driver.id,
      "name": driver.name,
      "email": driver.email,

    });
  }
}