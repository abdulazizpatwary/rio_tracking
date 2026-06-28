class VehiclePosition {
  final double latitude;
  final double longtitude;
  final double speed;
  final double distance;
  final double heading;


  VehiclePosition({
    required this.latitude,
    required this.longtitude,
    this.speed = 0,
    this.distance = 0,
    this.heading = 0,
  });
}