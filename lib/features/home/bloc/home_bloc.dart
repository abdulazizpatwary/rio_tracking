import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rio_deep/features/home/bloc/home_bloc_event.dart';
import 'package:rio_deep/features/home/bloc/home_bloc_state.dart';


class HomeBloc extends Bloc<HomeBlocEvent,HomeBlocState>{
  HomeBloc():super(HomeBlocInitialState()){
    on<HomeNavigateToUserInterfaceEvent>(homeNavigateToUserInterfaceEvent);
    on<HomeNavigateToDriverInterfaceEvent>(homeNavigateToDriverInterfaceEvent);
    on<HomeNavigateToDriverDashboardEvent>(homeNavigateToDriverDashboardEvent);
  }

  FutureOr<void> homeNavigateToUserInterfaceEvent(HomeNavigateToUserInterfaceEvent event, Emitter<HomeBlocState> emit) {
    emit(HomeNavigateToUserInterfaceActionState());
  }

  FutureOr<void> homeNavigateToDriverInterfaceEvent(HomeNavigateToDriverInterfaceEvent event, Emitter<HomeBlocState> emit) {
    emit(HomeNavigateToDriverInterfaceActionState());
  }

  FutureOr<void> homeNavigateToDriverDashboardEvent(HomeNavigateToDriverDashboardEvent event, Emitter<HomeBlocState> emit) {
    emit(HomeNavigateToDriverDashBoardActionState());
  }
}