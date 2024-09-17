import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harsh/Model/EntryModel.dart';
import 'package:harsh/Model/SellsModel.dart';
import 'package:harsh/Utils/GlobalData.dart';

import '../Model/ProductModel.dart';

class SellsForm extends StatefulWidget {
  final Sellsmodel? sellsdata;
  const SellsForm({super.key, this.sellsdata});

  @override
  State<SellsForm> createState() => _SellsFormState();
}

class _SellsFormState extends State<SellsForm> {
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _productPriceController = TextEditingController();
  TextEditingController _productQuantityController = TextEditingController();
  TextEditingController _totalPriceController = TextEditingController();
  TextEditingController _sellerNameController = TextEditingController();
  TextEditingController _dateController = TextEditingController(text: _formatDate(DateTime.now()));
  TextEditingController _timeController = TextEditingController(text: _formatTime(TimeOfDay.now()));
  TextEditingController _boxController = TextEditingController();
  String _paymentMode = 'Cash'; // Default value for Payment Mode dropdown
  String? _entryId;
  String? _selectedProductName;
  int selectedqnt = 0;
  List<ProductModel> _productList = [];

  @override
  void dispose() {
    _productNameController.dispose();
    _productPriceController.dispose();
    _productQuantityController.dispose();
    _totalPriceController.dispose();
    _sellerNameController.dispose();
    _dateController.dispose();
    _boxController.dispose();
    super.dispose();
  }

  void _populateFields(Sellsmodel entry) {
    setState(() {
      _selectedProductName = entry.productName;
      _productNameController.text = entry.productName;
      _productPriceController.text = entry.productPrice.toString();
      _productQuantityController.text = entry.productQuantity.toString();
      _boxController.text = entry.boxes.toString();
      _totalPriceController.text = entry.totalPrice.toString();
      _sellerNameController.text = entry.buyerName;
      _dateController.text = _formatDate(entry.date);
      _paymentMode = entry.paymentMode;
      _entryId = entry.id; // Store the ID of the entry being edited

      ProductModel? selectedProduct = _productList.firstWhere(
            (product) => product.productName == entry.productName, // Explicitly cast null to ProductModel?
      );
      if (selectedProduct != null) {
        selectedqnt = selectedProduct.productStock;
      }

    });

  }

  @override
  void initState() {
    super.initState();
    _fetchProductList();
    if (widget.sellsdata != null) {
      _populateFields(widget.sellsdata!);
    }
  }

  Future<void> _fetchProductList() async {
    try {
      // QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Products').get();
      setState(()  {
        _productList = GlobalData.productData;
      });
    } catch (e) {
      print('Error fetching product list: $e');
    }
  }

  static String _formatDate(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}';
  }

  static String _formatTime(TimeOfDay timeOfDay) {
    return '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        _dateController.text = _formatDate(pickedDate);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _timeController.text = _formatTime(pickedTime);
      });
    }
  }

  Future<void> insertdata() async {
    String productName = _productNameController.text;
    double productPrice = double.tryParse(_productPriceController.text) ?? 0.0;
    int productQuantity = int.tryParse(_productQuantityController.text) ?? 0;
    int boxes = int.tryParse(_boxController.text) ?? 0;
    double totalPrice = double.tryParse(_totalPriceController.text) ?? 0.0;
    String sellerName = _sellerNameController.text;

    if (_productNameController.text.isEmpty ||
        _productPriceController.text.isEmpty ||
        _productQuantityController.text.isEmpty ||
        _totalPriceController.text.isEmpty ||
        _sellerNameController.text.isEmpty ||
        _boxController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all data'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    DateTime selectedDate = DateTime.parse(_dateController.text.split('-').reversed.join('-'));
    TimeOfDay selectedTime = TimeOfDay(
      hour: int.parse(_timeController.text.split(':')[0]),
      minute: int.parse(_timeController.text.split(':')[1]),
    );

    // Combine date and time into a single DateTime object
    DateTime dateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    DocumentReference newDocRef = FirebaseFirestore.instance.collection('DataEntry').doc();

    Sellsmodel newEntry = Sellsmodel(
      productName: productName,
      productPrice: productPrice,
      productQuantity: productQuantity,
      totalPrice: totalPrice,
      buyerName: sellerName,
      paymentMode: _paymentMode,
      date: dateTime, // Use the combined date and time
      id: newDocRef.id,
      boxes: boxes
    );

    GlobalData.sellsData.add(newEntry);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16.0),
                Text('Submitting...'),
              ],
            ),
          ),
        );
      },
    );

    try {
      await newDocRef.set(newEntry.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Entry submitted successfully'),
          duration: Duration(seconds: 2),
        ),
      );

      _productNameController.clear();
      _productPriceController.clear();
      _productQuantityController.clear();
      _totalPriceController.clear();
      _sellerNameController.clear();
      _boxController.clear();
      _dateController.text = _formatDate(DateTime.now());
      _timeController.text = _formatTime(TimeOfDay.now());
      setState(() {
        _paymentMode = 'Cash';
      });
    } catch (e) {
      print('Error adding entry to Firestore: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit entry'),
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      Navigator.of(context).pop();
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context, true);
      });
    }
  }

  Future<void> saveData() async {
    String productName = _selectedProductName ?? "";
    double productPrice = double.tryParse(_productPriceController.text) ?? 0.0;
    int productQuantity = int.tryParse(_productQuantityController.text) ?? 0;
    int boxes = int.tryParse(_boxController.text) ?? 0;
    double totalPrice = double.tryParse(_totalPriceController.text) ?? 0.0;
    String sellerName = _sellerNameController.text;

    if (_selectedProductName == null ||
        _productPriceController.text.isEmpty ||
        _productQuantityController.text.isEmpty ||
        _totalPriceController.text.isEmpty ||
        _sellerNameController.text.isEmpty ||
        _boxController.text.isEmpty
    ) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all data'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if(productQuantity > selectedqnt){

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('There are only ${selectedqnt} products left to sell'),
          duration: Duration(seconds: 2),
        ),
      );

      return;
    }

    DateTime selectedDate = DateTime.parse(_dateController.text.split('-').reversed.join('-'));
    TimeOfDay selectedTime = TimeOfDay(
      hour: int.parse(_timeController.text.split(':')[0]),
      minute: int.parse(_timeController.text.split(':')[1]),
    );

    // Combine date and time into a single DateTime object
    DateTime dateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16.0),
                Text('Submitting...'),
              ],
            ),
          ),
        );
      },
    );

    try {
      // Determine whether to insert or update
      if (_entryId == null) {
        // Insert new entry
        DocumentReference newDocRef = FirebaseFirestore.instance.collection('SellsData').doc();
        Sellsmodel newEntry = Sellsmodel(
          productName: productName,
          productPrice: productPrice,
          productQuantity: productQuantity,
          totalPrice: totalPrice,
          buyerName: sellerName,
          paymentMode: _paymentMode,
          date: dateTime,
          id: newDocRef.id,
          boxes: boxes
        );

        GlobalData.sellsData.add(newEntry);



        await newDocRef.set(newEntry.toMap());

        await GlobalData.updateProductStock(productName, -(productQuantity));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Entry submitted successfully'),
            duration: Duration(seconds: 2),
          ),
        );

        _entryId = newDocRef.id; // Update _entryId with the new document ID
      } else {
        // Update existing entry
        DocumentReference docRef = FirebaseFirestore.instance.collection('SellsData').doc(_entryId);

        Sellsmodel updatedEntry = Sellsmodel(
          productName: productName,
          productPrice: productPrice,
          productQuantity: productQuantity,
          totalPrice: totalPrice,
          buyerName: sellerName,
          paymentMode: _paymentMode,
          date: dateTime,
          id: _entryId!,
          boxes: boxes
        );

        await docRef.update(updatedEntry.toMap());

        final index = GlobalData.sellsData.indexWhere((e) => e.id == _entryId);
        if (index != -1) {
          GlobalData.sellsData[index] = updatedEntry;
        }

        int oldstock = widget.sellsdata?.productQuantity ?? 0;
        int newstock = productQuantity;
        int finalstock;


        print("Old Stock : ${oldstock}");
        print("New Stock : ${newstock}");

        if(newstock > oldstock){

          finalstock = newstock - oldstock;
          print("Final Stock : ${finalstock}");
          await GlobalData.updateProductStock(productName, -finalstock);

        }else{

          finalstock = oldstock - newstock;
          print("Final Stock : ${finalstock}");
          await GlobalData.updateProductStock(productName, finalstock);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Entry updated successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      }

      // Clear form and reset state
      _productNameController.clear();
      _productPriceController.clear();
      _productQuantityController.clear();
      _totalPriceController.clear();
      _sellerNameController.clear();
      _boxController.clear();
      _dateController.text = _formatDate(DateTime.now());
      _timeController.text = _formatTime(TimeOfDay.now());
      setState(() {
        _paymentMode = 'Cash';
      });

    } catch (e) {
      print('Error saving entry to Firestore: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save entry'),
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      Navigator.of(context).pop();
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context, true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Change the background color if needed
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Sells Data',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                SizedBox(height: 30,),
              DropdownSearch<String>(
                popupProps: PopupProps.dialog(
                  showSearchBox: true,
                  containerBuilder: (context, popupWidget) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0), // Adjust padding as needed
                      child: popupWidget,
                    );
                  },
                ),
                items: _productList.map((product) => product.productName).toList(),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Select Product",
                    border: OutlineInputBorder(),
                  ),
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedProductName = newValue;

                    // Find the selected product based on the name
                    ProductModel? selectedProduct = _productList.firstWhere(
                          (product) => product.productName == newValue, // Explicitly cast null to ProductModel?
                    );
                    if (selectedProduct != null) {
                      selectedqnt = selectedProduct.productStock;
                    }
                  });
                },
                selectedItem: _selectedProductName,
              ),

              // DropdownButtonFormField<String>(
                //   value: _selectedProductName,
                //   onChanged: (newValue) {
                //     setState(() {
                //       _selectedProductName = newValue;
                //     });
                //   },
                //   items: _productList.map<DropdownMenuItem<String>>((ProductModel product) {
                //     return DropdownMenuItem<String>(
                //       value: product.productName,
                //       child: Text(product.productName),
                //     );
                //   }).toList(),
                //   decoration: InputDecoration(
                //     labelText: 'Select Product',
                //     border: OutlineInputBorder(),
                //   ),
                // ),
                // TextField(
                //   controller: _productNameController,
                //   decoration: InputDecoration(
                //     labelText: 'Product Name',
                //     border: OutlineInputBorder(),
                //   ),
                // ),
                SizedBox(height: 16.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _productPriceController,
                        onChanged: (val){
                          if(_productPriceController != null && _productQuantityController != null){
                            _totalPriceController.text = "${int.parse(_productPriceController.text) * int.parse(_productQuantityController.text)}";
                          }
                        },
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly, // Allows only digits
                        ],
                        decoration: InputDecoration(
                          labelText: 'Product Price',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: TextField(
                        controller: _productQuantityController,
                        onChanged: (val){
                          if(_productPriceController != null && _productQuantityController != null){
                            _totalPriceController.text = "${int.parse(_productPriceController.text) * int.parse(_productQuantityController.text)}";
                          }
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly, // Allows only digits
                        ],
                        decoration: InputDecoration(
                          labelText: 'Product Quantity',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _boxController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter Box Count',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    // Automatically calculate quantity based on boxes
                    if (_boxController.text.isNotEmpty) {
                      ProductModel selectedProduct = _productList.firstWhere((product) => product.productName == _selectedProductName);
                      int quantityPerBox = selectedProduct.qnt;
                      _productQuantityController.text = (int.parse(val) * quantityPerBox).toString();
                      _totalPriceController.text = (int.parse(_productQuantityController.text) * double.parse(_productPriceController.text)).toString();
                    }else{
                      _boxController.text = "0";
                    }
                  },
                ),
                SizedBox(height: 16.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _totalPriceController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly, // Allows only digits
                        ],
                        decoration: InputDecoration(
                          labelText: 'Total Price',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: TextField(
                        controller: _sellerNameController,
                        decoration: InputDecoration(
                          labelText: 'Buyer Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _paymentMode,
                        onChanged: (newValue) {
                          setState(() {
                            _paymentMode = newValue!;
                          });
                        },
                        items: <String>['Cash', 'Online'].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Payment Mode',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: TextField(
                            controller: _dateController,
                            decoration: InputDecoration(
                              labelText: 'Date (dd-mm-yyyy)',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () => _selectTime(context),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _timeController,
                      decoration: InputDecoration(
                        labelText: 'Time (hh:mm)',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.access_time),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(143, 148, 251, 1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextButton(
                    onPressed: () {
                      saveData();
                      // TODO: Implement form submission logic
                      String productName = _productNameController.text;
                      double productPrice = double.tryParse(_productPriceController.text) ?? 0.0;
                      int productQuantity = int.tryParse(_productQuantityController.text) ?? 0;
                      double totalPrice = double.tryParse(_totalPriceController.text) ?? 0.0;
                      String sellerName = _sellerNameController.text;
                      String date = _dateController.text;

                      // You can process or submit the data here
                      print('Product Name: $productName');
                      print('Product Price: $productPrice');
                      print('Product Quantity: $productQuantity');
                      print('Total Price: $totalPrice');
                      print('Seller Name: $sellerName');
                      print('Payment Mode: $_paymentMode');
                      print('Date: $date');
                    },
                    child: Text(
                      widget.sellsdata != null ? 'Update' : 'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
