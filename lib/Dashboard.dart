import 'package:flutter/material.dart';
import 'package:harsh/Sells/SellsData.dart';
import 'package:harsh/Sells/SellsForm.dart';

import 'Entry/EntryData.dart';
import 'Entry/EntryForm.dart';
import 'Homepage.dart';
import 'Product/ProductData.dart';
import 'Product/ProductForm.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  bool menu = false;
  int selectedIndex = 0;

  List<Widget> screens = [
    Homepage(),
    Entrydata(),
    Sellsdata(),
    ProductDataPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: AppBar(
              centerTitle: true,
              title: Text("Stock Management System",style: TextStyle(color: Colors.white),),
              leading: IconButton(
                  onPressed: (){
                    setState(() {
                      menu = !menu;
                    });
                  }, icon: Icon(menu ? Icons.close : Icons.menu,color: Colors.white,)),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(143, 148, 251, 1),
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: screens[selectedIndex],
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 250),
                left: menu ? 0 : -250, // animate left to right and vice versa
                top: 3,
                bottom: 0,
                child: Container(
                  width: 250,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(143, 148, 251, 1),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: selectedIndex == 0 ? Colors.black.withOpacity(0.3) : Colors.transparent,
                          border: Border(
                            bottom: BorderSide(
                              color:  Colors.white, // Set the bottom border color to white
                              width: 1.0, // Set the width of the bottom border
                            ),
                          ),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.dashboard,color: Colors.white,),
                          title: Text("Dashboard",style: TextStyle(color: Colors.white),),
                          onTap: (){
                            setState(() {
                              selectedIndex = 0;
                              menu = false;
                            });
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: selectedIndex == 1 ? Colors.black.withOpacity(0.3) : Colors.transparent,
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.white, // Set the bottom border color to white
                              width: 1.0, // Set the width of the bottom border
                            ),
                          ),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.add,color: Colors.white,),
                          title: Text("Stock Entry",style: TextStyle(color: Colors.white),),
                          onTap: (){
                            setState(() {
                              selectedIndex = 1;
                              menu = false;
                            });
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: selectedIndex == 2 ? Colors.black.withOpacity(0.3) : Colors.transparent,
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.white, // Set the bottom border color to white
                              width: 1.0, // Set the width of the bottom border
                            ),
                          ),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.shopping_cart,color: Colors.white,),
                          title: Text("Stock Sells",style: TextStyle(color: Colors.white),),
                          onTap: (){
                            setState(() {
                              selectedIndex = 2;
                              menu = false;
                            });
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: selectedIndex == 3 ? Colors.black.withOpacity(0.3) : Colors.transparent,
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.white, // Set the bottom border color to white
                              width: 1.0, // Set the width of the bottom border
                            ),
                          ),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.sell,color: Colors.white,),
                          title: Text("Products",style: TextStyle(color: Colors.white),),
                          onTap: (){
                            setState(() {
                              selectedIndex = 3;
                              menu = false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }

}
