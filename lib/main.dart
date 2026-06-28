import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:rio_deep/app/app.dart';

import 'firebase_options.dart';

void main()async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  const accessToken = String.fromEnvironment('ACCESS_TOKEN');

  MapboxOptions.setAccessToken(accessToken);

  runApp(RioDeepApp());
}
