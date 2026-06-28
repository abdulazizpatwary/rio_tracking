
abstract class TrackingEvent {}
class StartTrackingEvent extends TrackingEvent{


}
class UpdateTrackingEvent extends TrackingEvent {

  final double latitude;
  final double longtitude;
  final double speed;
  final double distance;
  final double heading;

  UpdateTrackingEvent({
    required this.latitude,
    required this.longtitude,
    required this.speed,
    required this.distance, required this.heading,
  });
}
class TrackingErrorEvent extends TrackingEvent{

  final String message;

  TrackingErrorEvent(this.message);
}
class EndTrackingEvent extends TrackingEvent{}