import 'dart:convert' as convert; // For base64 encoding/decoding
import 'dart:html' as html; // For handling file downloads in Flutter web
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firebase Firestore
import 'package:excel/excel.dart'; // For working with Excel files
import 'package:flutter/material.dart'; // For Flutter widgets and material design
import 'package:harsh/Model/ProductModel.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../Model/EntryModel.dart'; // Assuming you have this model for EntryData
import '../Utils/GlobalData.dart'; // Global data handling
import 'ProductForm.dart'; // Form for adding/editing ProductData

class ProductDataTableSource extends DataTableSource {
  final List<ProductModel> productList;
  final BuildContext context;

  ProductDataTableSource(this.productList, this.context);

  @override
  DataRow? getRow(int index) {
    if (index >= productList.length) return null;

    final product = productList[index];
    return DataRow(
      cells: [
        DataCell(Text(product.productName)),
        DataCell(Text(product.productStock.toString())),
        DataCell(Text("${(product.productStock ~/ product.qnt)}")),
        DataCell(Text(product.qnt.toString())),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductForm(productData: product),
                    ),
                  ).then((val) {
                    notifyListeners();
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  await FirebaseFirestore.instance.collection('ProductData').doc(product.id).delete();
                  // Remove the product from the list and refresh the table
                  productList.remove(product);
                  notifyListeners();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => productList.length;

  @override
  int get selectedRowCount => 0;
}

class ProductDataPage extends StatefulWidget {
  const ProductDataPage({Key? key}) : super(key: key);

  @override
  State<ProductDataPage> createState() => _ProductDataPageState();
}

class _ProductDataPageState extends State<ProductDataPage> {
  List<ProductModel> _productList = [];
  List<ProductModel> _filteredProductList = [];
  TextEditingController _searchController = TextEditingController();
  int _rowsPerPage = 5;
  ProductDataTableSource? _dataSource;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // Replace with your data fetching logic
    // await GlobalData.fetchProductData();
    setState(() {
      _productList = GlobalData.productData; // Populate with fetched data
      _filteredProductList = List.from(_productList);
      _dataSource = ProductDataTableSource(_filteredProductList, context);
    });
  }

  void _runSearch(String searchQuery) {
    setState(() {
      _applyFilters(searchQuery: searchQuery);
    });
  }

  void _applyFilters({String? searchQuery}) {
    List<ProductModel> filtered = _productList;
    if (searchQuery != null && searchQuery.isNotEmpty) {
      filtered = filtered.where((product) {
        return product.productName.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }
    setState(() {
      _filteredProductList = filtered;
      _dataSource = ProductDataTableSource(_filteredProductList, context);
    });
  }

  Future<void> _exportToExcel() async {
    var excel = Excel.createExcel();
    Sheet sheet = excel['Sheet1'];

    sheet.appendRow(['Product Name', 'Stock']);

    for (var product in _filteredProductList) {
      sheet.appendRow([product.productName, product.productStock]);
    }

    final bytes = await excel.save();
    final base64String = convert.base64Encode(bytes!);
    final blob = html.Blob([convert.base64Decode(base64String)]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "ProductData_${DateFormat('yyyy-MM-dd-HH-mm').format(DateTime.now())}.xlsx")
      ..style.display = 'none';
    html.document.body?.append(anchor);
    anchor.click();
    anchor.remove();
    html.Url.revokeObjectUrl(url);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data exported successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 150),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text('Product Data', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProductForm()),
                      ).then((_) {
                        setState(() {
                          fetchData();
                        });
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      color: Color.fromRGBO(143, 148, 251, 1),
                      child: Row(
                        children: [
                          Icon(Icons.add, color: Colors.white),
                          Text("Add Data", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  InkWell(
                    onTap: () {
                      _exportToExcel();
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      color: Color.fromRGBO(143, 148, 251, 1),
                      child: Row(
                        children: [
                          Icon(Icons.upload, color: Colors.white),
                          Text("Export Data", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search by Product Name',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () => _runSearch(_searchController.text),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            _productList.isEmpty
                ? Center(child: Text("No Data Found",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),)
                : Expanded(
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 1000, // Provide a width constraint
                    child: PaginatedDataTable(
                      rowsPerPage: _rowsPerPage,
                      availableRowsPerPage: [5, 10, 15, 20],
                      onRowsPerPageChanged: (rows) {
                        setState(() {
                          _rowsPerPage = rows!;
                        });
                      },
                      columns: [
                        DataColumn(label: Text('Product Name', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Stock', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Stock in Box', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Quantity in Box', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Actions', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold))),
                      ],
                      source: _dataSource!,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

