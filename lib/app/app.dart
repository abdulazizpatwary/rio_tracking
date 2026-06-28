import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rio_deep/features/driver/bloc/driverdashboard_bloc.dart';
import 'package:rio_deep/features/home/bloc/home_bloc.dart';
import 'package:rio_deep/features/home/view/screens/home_screen.dart';
import 'package:rio_deep/features/tracking/bloc/tracking_bloc.dart';
import 'package:rio_deep/features/tracking/data/repository/tracking_repository_implementation.dart';
import 'package:rio_deep/features/vehicle/data/repository/vehicle_repository.dart';


class RioDeepApp extends StatelessWidget {
  const RioDeepApp({super.key});

  @override
  Widget build(BuildContext context) {
    final trackingRepository= TrackingRepositoryImplementation();
    final vehicleRepository= VehicleRepository();
    //final trackingRepository=SimulatedTrackingRepository();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => TrackingBloc(trackingRepository),),
        BlocProvider(create: (BuildContext context) => DriverDashboardBloc(vehicleRepository),),
        BlocProvider(create: (BuildContext context) => HomeBloc(),),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),

        theme: ThemeData(
          appBarTheme: AppBarThemeData(
            backgroundColor: Colors.amberAccent
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amberAccent,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              )
            )
          )
        ),
      ),
    );
  }
}
