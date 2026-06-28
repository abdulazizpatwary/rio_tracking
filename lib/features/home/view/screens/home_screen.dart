import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rio_deep/features/auth/domain/entities/driver.dart';
import 'package:rio_deep/features/auth/view/screens/register_driver_screen.dart';
import 'package:rio_deep/features/home/bloc/home_bloc.dart';
import 'package:rio_deep/features/home/bloc/home_bloc_event.dart';
import 'package:rio_deep/features/home/bloc/home_bloc_state.dart';
import 'package:rio_deep/features/map/view/screens/map_screen.dart';
import 'package:rio_deep/features/driver/view/screens/driver_dashboard_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, });



  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Driver? driver;
  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Rio Tracking",
        ),
      ),

      body: BlocListener<HomeBloc,HomeBlocState>(
        listener: (context,state)async{
          if(state is HomeBlocActionState){
            if(state is HomeNavigateToUserInterfaceActionState){
              Navigator.push(

                context,

                MaterialPageRoute(
                  builder: (_) =>
                  const MapScreen(),
                ),
              );
            }
            if(state is HomeNavigateToDriverInterfaceActionState){
              driver =
                  await Navigator.push(

                context,

                MaterialPageRoute(

                  builder: (_) =>
                  const RegisterDriverScreen(),
                ),
              );

            }
            if(state is HomeNavigateToDriverDashBoardActionState){
              if(driver!=null){
                Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (_) =>
                        DriverDashboard(
                          currentDriver:
                          driver!,
                        ),
                  ),
                );
              }

            }
          }
        },
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(

      padding:
      const EdgeInsets.all(20),

      child: Column(

        mainAxisAlignment:
        MainAxisAlignment.center,

        children: [

          SizedBox(

            width: double.infinity,

            child: ElevatedButton(

              onPressed: (){
                context.read<HomeBloc>().add(HomeNavigateToUserInterfaceEvent());


              },

              child: const Text(
                "User Interface",
              ),
            ),
          ),

          const SizedBox(
            height:20,
          ),

          SizedBox(

            width: double.infinity,

            child: ElevatedButton(

              onPressed: () async {

                context.read<HomeBloc>().add(HomeNavigateToDriverInterfaceEvent());

                if(driver!=null){


                  context.read<HomeBloc>().add(HomeNavigateToDriverDashboardEvent());


                }
              },

              child: const Text(
                "Driver Interface",
              ),
            ),
          ),

          const SizedBox(
            height:20,
          ),


        ],
      ),
    );
  }
}