import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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

  await GlobalData.fetchEntries();
  await GlobalData.fetchProducts();
  await GlobalData.fetchSells();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      // home: const Dashboard(),
      home: const LoginPage(),
    );
  }
}

