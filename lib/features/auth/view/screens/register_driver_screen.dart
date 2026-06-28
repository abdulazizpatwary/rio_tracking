import 'package:flutter/material.dart';
import 'package:rio_deep/features/auth/domain/entities/driver.dart';
import 'package:rio_deep/features/auth/data/repository/driver_repository.dart';

class RegisterDriverScreen
    extends StatefulWidget {

  const RegisterDriverScreen({
    super.key,
  });

  @override
  State<RegisterDriverScreen>
  createState() =>
      _RegisterDriverScreenState();
}

class _RegisterDriverScreenState
    extends State<RegisterDriverScreen>{

  final nameController =
  TextEditingController();

  final emailController =
  TextEditingController();

  final repository =
  DriverRepository();

  @override
  Widget build(BuildContext context){

    return Scaffold(

      appBar: AppBar(
        title: const Text(
            "Driver Register"),
      ),

      body: Padding(

        padding:
        const EdgeInsets.all(16),

        child: Column(

          children: [

            TextField(
              controller:
              nameController,
              decoration:
              const InputDecoration(
                labelText:"Name",
              ),
            ),

            const SizedBox(
                height: 10),

            TextField(
              controller:
              emailController,

              decoration:
              const InputDecoration(
                labelText:"Email",
              ),
            ),

            const SizedBox(
                height:20),

            ElevatedButton(

              onPressed: () async {

                if(nameController.text.isEmpty ||
                    emailController.text.isEmpty){

                  ScaffoldMessenger.of(context)
                      .showSnackBar(

                    const SnackBar(
                      content:
                      Text("Fill all fields"),
                    ),
                  );

                  return;
                }

                try{

                  final driver =
                  Driver(

                    id: DateTime.now()
                        .millisecondsSinceEpoch
                        .toString(),

                    name:
                    nameController.text,

                    email:
                    emailController.text,
                  );

                  await repository
                      .addDriver(driver);

                  Navigator.pop(
                    context,
                    driver,
                  );

                }catch(e){

                  ScaffoldMessenger.of(context)
                      .showSnackBar(

                    SnackBar(
                      content:
                      Text(e.toString()),
                    ),
                  );
                }
              },

              child: const Text(
                  "Register"),
            ),
          ],
        ),
      ),
    );
  }
}