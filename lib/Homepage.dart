import 'dart:convert';
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:harsh/Utils/GlobalData.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 150),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40,),
              Text("Dashboard",style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),),
              SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(
                      child: Container(
                        height: 350,
                        // color: Colors.red,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color:  Color.fromRGBO(143, 148, 251, 1), // Set the bottom border color to white
                              width: 2.0, // Set the width of the bottom border
                          ),
                        ),
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Purchase Data",style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold),),
                            SizedBox(height: 20,),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    color: Color.fromRGBO(143, 148, 251, 1),
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Text("Total Amount",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                                        SizedBox(height: 10,),
                                        Text("${GlobalData.formattedEntryPrice}",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 20,),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    color: Color.fromRGBO(143, 148, 251, 1),
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Text("In Cash",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                                        SizedBox(height: 10,),
                                        Text("${GlobalData.formattedcashPaymentTotal}",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20,),
                                Expanded(
                                  child: Container(
                                    color: Color.fromRGBO(143, 148, 251, 1),
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Text("Online",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                                        SizedBox(height: 10,),
                                        Text("${GlobalData.formattedonlinePaymentTotal}",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                  ),
                  SizedBox(width: 30,),
                  Expanded(
                      child: Container(
                        height: 350,
                        // color: Colors.red,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:  Color.fromRGBO(143, 148, 251, 1), // Set the bottom border color to white
                            width: 2.0, // Set the width of the bottom border
                          ),
                        ),
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Selling Data",style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold),),
                            SizedBox(height: 20,),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    color: Color.fromRGBO(143, 148, 251, 1),
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Text("Total Amount",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                                        SizedBox(height: 10,),
                                        Text("${GlobalData.formattedSellsPrice}",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 20,),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    color: Color.fromRGBO(143, 148, 251, 1),
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Text("In Cash",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                                        SizedBox(height: 10,),
                                        Text("${GlobalData.SellsformattedcashPaymentTotal}",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20,),
                                Expanded(
                                  child: Container(
                                    color: Color.fromRGBO(143, 148, 251, 1),
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Text("Online",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                                        SizedBox(height: 10,),
                                        Text("${GlobalData.SellsformattedonlinePaymentTotal}",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                  ),
                ],
              )
            ],
          ),
        )
    );
  }
}
