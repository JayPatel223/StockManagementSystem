import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Model/ProductModel.dart';
import '../Utils/GlobalData.dart';

class ProductForm extends StatefulWidget {
  final ProductModel? productData;
  const ProductForm({super.key, this.productData});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _productStockController = TextEditingController(text: "0");
  String? _productId;

  @override
  void dispose() {
    _productNameController.dispose();
    _productStockController.dispose();
    super.dispose();
  }

  void _populateFields(ProductModel product) {
    setState(() {
      _productNameController.text = product.productName;
      _productStockController.text = product.productStock.toString();
      _productId = product.id;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.productData != null) {
      _populateFields(widget.productData!);
    }
  }

  Future<void> saveData() async {
    String productName = _productNameController.text;
    int productStock = int.tryParse(_productStockController.text) ?? 0;

    if (_productNameController.text.isEmpty ||
        _productStockController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all data'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

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
      if (_productId == null) {
        // Insert new entry
        DocumentReference newDocRef = FirebaseFirestore.instance.collection('ProductData').doc();
        ProductModel newProduct = ProductModel(
          productName: productName,
          productStock: productStock,
          id: newDocRef.id,
        );

        GlobalData.productData.add(newProduct);

        await newDocRef.set(newProduct.toMap());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product submitted successfully'),
            duration: Duration(seconds: 2),
          ),
        );

        _productId = newDocRef.id;
      } else {
        // Update existing entry
        DocumentReference docRef = FirebaseFirestore.instance.collection('ProductData').doc(_productId);

        ProductModel updatedProduct = ProductModel(
          productName: productName,
          productStock: productStock,
          id: _productId!,
        );

        await docRef.update(updatedProduct.toMap());

        final index = GlobalData.productData.indexWhere((p) => p.id == _productId);
        if (index != -1) {
          GlobalData.productData[index] = updatedProduct;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product updated successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      }

      // Clear form and reset state
      _productNameController.clear();
      _productStockController.clear();
    } catch (e) {
      print('Error saving product to Firestore: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save product'),
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
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Product Data', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                SizedBox(height: 30),
                TextField(
                  controller: _productNameController,
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _productStockController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly, // Allows only digits
                  ],
                  decoration: InputDecoration(
                    labelText: 'Product Stock',
                    border: OutlineInputBorder(),
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
                      int productStock = int.tryParse(_productStockController.text) ?? 0;

                      // You can process or submit the data here
                      print('Product Name: $productName');
                      print('Product Stock: $productStock');
                    },
                    child: Text(
                      widget.productData != null ? 'Update' : 'Submit',
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
