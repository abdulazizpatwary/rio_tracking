import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rio_deep/features/driver/bloc/driverdashboard_state.dart';
import 'package:rio_deep/features/driver/bloc/driverdashboardevent_event.dart';
import 'package:rio_deep/features/vehicle/data/repository/vehicle_repository.dart';

class DriverDashboardBloc
    extends Bloc<DriverDashboardEvent, DriverDashboardState> {
  final VehicleRepository repository;

  DriverDashboardBloc(this.repository) : super(DashboardInitial()) {
    on<LoadVehicles>(_loadVehicles);

    on<DeleteVehicle>(_deleteVehicle);

    on<GoToAddVehicle>((event, emit) {
      emit(NavigateToAddVehicle());

      emit(DashboardInitial());
    });

    on<GoToTrackVehicle>((event, emit) {
      emit(NavigateToTrack());

      emit(DashboardInitial());
    });

    on<GoToEditVehicle>((event, emit) {
      emit(NavigateToEditVehicle(event.vehicle));

      emit(DashboardInitial());
    });
  }

  Future<void> _loadVehicles(
    LoadVehicles event,
    Emitter<DriverDashboardState> emit,
  ) async {
    emit(VehicleLoading());

    await emit.forEach(
      repository.getVehicles(event.driverId),

      onData: (vehicles) {
        if (vehicles.isEmpty) {
          return VehicleEmpty();
        }

        return VehicleLoaded(vehicles);
      },

      onError: (_, __) {
        return VehicleError("Failed to load");
      },
    );
  }

  Future<void> _deleteVehicle(
    DeleteVehicle event,
    Emitter<DriverDashboardState> emit,
  ) async {
    await repository.deleteVehicle(event.vehicleId);
  }
}
