import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/surah_controller.dart';
import 'views/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quran Audio in Bangla',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SolaimanLipi',  
      ),
      initialBinding: BindingsBuilder(() {
        Get.put(SurahController());
      }),
      home: const HomePage(),
    );
  }
}