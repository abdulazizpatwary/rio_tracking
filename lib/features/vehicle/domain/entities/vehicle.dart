class Vehicle {
  final String id;

  final String vehicleName;

  final String vehicleType;
  final String vehicleNumber;

  final String driverId;

  final double latitude;

  final double longitude;
  final String status;
  final double speed;
  final double distance;
  final double heading;
  final DateTime lastUpdated;

  Vehicle({required this.id, required this.vehicleName, required this.vehicleType, required this.driverId, required this.latitude, required this.longitude, required this.status, required this.speed, required this.distance, required this.heading, required this.lastUpdated, required this.vehicleNumber});
}