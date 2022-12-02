import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'ui/main_page.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

class MyApp extends GetMaterialApp {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GeaDatasource Test Tool',
        defaultTransition: Transition.cupertino,
        navigatorObservers: [
          routeObserver,
        ],
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: MainPage.name,
        getPages: [
          GetPage(
            name: MainPage.name,
            page: () => MainPage(),
            binding: BindingsBuilder(
              () {},
            ),
          ),
        ],
      );
}
