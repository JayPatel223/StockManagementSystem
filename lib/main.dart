import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Dashboard.dart';
import 'Homepage.dart';
import 'LoginPage.dart';
import 'Utils/GlobalData.dart';

Future<void> main() async {

  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyAcczofgMAi1dD4gaBcJyiFXUkAKgua3jI",
        authDomain: "stock-management-8e154.firebaseapp.com",
        projectId: "stock-management-8e154",
        storageBucket: "stock-management-8e154.appspot.com",
        messagingSenderId: "343722663440",
        appId: "1:343722663440:web:4d74046ca92993a01d7495",
        measurementId: "G-G5KWESJMZ9"
    ),
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  await GlobalData.fetchRemoteConfigData();
  await GlobalData.fetchEntries();
  await GlobalData.fetchProducts();
  await GlobalData.fetchSells();

  runApp(MyApp(isLoggedIn: isLoggedIn,));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Management System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isLoggedIn ? Dashboard() : LoginPage(),
    );
  }
}

