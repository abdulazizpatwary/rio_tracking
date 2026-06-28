import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rio_deep/features/tracking/bloc/tracking_event.dart';
import 'package:rio_deep/features/tracking/bloc/tracking_state.dart';
import 'package:rio_deep/features/tracking/data/repository/tracking_repository.dart';
import 'package:rio_deep/features/vehicle/data/repository/vehicle_repository.dart';
import 'package:rio_deep/features/vehicle/domain/entities/vehicle.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final TrackingRepository repository;
  final VehicleRepository vehicleRepository = VehicleRepository();

  StreamSubscription? _locationSubscription;
  StreamSubscription? _vehicleSubscription;

  List<Vehicle> _vehicles = [];

  TrackingBloc(this.repository) : super(TrackingInitialState()) {
    on<StartTrackingEvent>(startTrackingEvent);
    on<UpdateTrackingEvent>(updateTrackingEvent);
    on<EndTrackingEvent>(endTrackingEvent);

    on<TrackingErrorEvent>((event, emit) {
      emit(TrackingErrorState(errorMsg: event.message));
    });
  }

  Future<void> startTrackingEvent(
    StartTrackingEvent event,
    Emitter<TrackingState> emit,
  ) async {
    emit(TrackingLoadingState());

    try {
      await repository.requestPermission();

      await _vehicleSubscription?.cancel();

      _vehicleSubscription = repository.getVehicles().listen((vehicles) {
        _vehicles = vehicles;
      });

      await _locationSubscription?.cancel();

      _locationSubscription = repository.getLocationStream().listen(
        (position) async {
          if (_vehicles.isNotEmpty) {
            final vehicle = _vehicles.first;

            final updatedVehicle = Vehicle(
              id: vehicle.id,
              vehicleName: vehicle.vehicleName,

              vehicleNumber: vehicle.vehicleNumber,

              vehicleType: vehicle.vehicleType,

              driverId: vehicle.driverId,

              latitude: position.latitude,

              longitude: position.longtitude,

              speed: position.speed,

              distance: position.distance,

              heading: position.heading,

              status: position.speed > 1 ? "Moving" : "Stopped",

              lastUpdated: DateTime.now(),
            );

            await vehicleRepository.updateVehicle(updatedVehicle);
          }

          add(
            UpdateTrackingEvent(
              latitude: position.latitude,

              longtitude: position.longtitude,

              speed: position.speed,

              distance: position.distance,

              heading: position.heading,
            ),
          );
        },

        onError: (error) {
          add(TrackingErrorEvent(error.toString()));
        },
      );
    } catch (e) {
      emit(TrackingErrorState(errorMsg: e.toString()));
    }
  }


  Future<void> updateTrackingEvent(
      UpdateTrackingEvent event,
      Emitter<TrackingState> emit,
      ) async {

    final updatedVehicles = _vehicles.map((vehicle){

      return Vehicle(

        id: vehicle.id,
        vehicleName: vehicle.vehicleName,
        vehicleNumber: vehicle.vehicleNumber,
        vehicleType: vehicle.vehicleType,
        driverId: vehicle.driverId,

        latitude: event.latitude,
        longitude: event.longtitude,

        speed: event.speed,
        distance: event.distance,
        heading: event.heading,

        status:
        event.speed > 1
            ? "Moving"
            : "Stopped",

        lastUpdated:
        DateTime.now(),
      );

    }).toList();

    emit(
      TrackingUpdatedState(
        latitude: event.latitude,
        longtitude: event.longtitude,
        speed: event.speed,
        distance: event.distance,
        heading: event.heading,
        vehicles: updatedVehicles,
      ),
    );
  }


  Future<void> endTrackingEvent(
    EndTrackingEvent event,
    Emitter<TrackingState> emit,
  ) async {
    await _locationSubscription?.cancel();
    await _vehicleSubscription?.cancel();

    _locationSubscription = null;
    _vehicleSubscription = null;

    emit(TrackingEndState());
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    _vehicleSubscription?.cancel();

    return super.close();
  }
}
