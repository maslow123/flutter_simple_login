import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_login/presentation/sign_in/sign_in_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(  
        title: 'Flutter Demo',
        getPages: [
          GetPage(name: '/', page: () => SignInPage()),             
        ],
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
    ); 
  }
}