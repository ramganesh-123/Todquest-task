import 'package:Todquest_task/approuter.dart';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todquest-Task',
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: "/",
      navigatorObservers: [routeObserver],
      getPages: AppRouter.routers,
    ),
  );
}
