import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../Model/SellsModel.dart';
import '../Utils/GlobalData.dart';
import 'SellsForm.dart';
import 'dart:html' as html;
import 'dart:convert' as convert;
import 'package:pdf/widgets.dart' as pw;

class SellsDataTableSource extends DataTableSource {
  final List<Sellsmodel> SellsList;
  final BuildContext context;

  SellsDataTableSource(this.SellsList, this.context);

  @override
  DataRow? getRow(int index) {
    if (index >= SellsList.length) return null;

    final Sells = SellsList[index];

    void printInvoice(Sellsmodel entry) async {
      final pdf = pw.Document();

      // Define your invoice details here
      final shopTitle = GlobalData.ShopName;
      final gstNo = GlobalData.gstno;
      final sellerName = entry.buyerName; // Use data from the entry model
      final date = DateFormat('yyyy-MM-dd').format(entry.date);
      final productName = entry.productName; // Assuming entry has product name field
      final productPrice = entry.productPrice.toString(); // Assuming entry has product price
      final quantity = entry.productQuantity.toString(); // Assuming entry has quantity field
      final quantityInBox = entry.boxes.toString(); // Assuming entry has box quantity field
      final paymentMode = entry.paymentMode; // Assuming entry has payment mode field
      final totalpayment = entry.totalPrice; // Assuming entry has payment mode field

      // Create the PDF content
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(24.0),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Center(
                    child: pw.Text(
                      shopTitle,
                      style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('GST No: $gstNo', style: pw.TextStyle(fontSize: 16)),
                      pw.Text('Date: $date', style: pw.TextStyle(fontSize: 16)),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text('Buyer Name: $sellerName', style: pw.TextStyle(fontSize: 16)),
                  pw.SizedBox(height: 10),
                  pw.Divider(),
                  pw.SizedBox(height: 10),
                  pw.Text('Product Details', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 10),

                  // Product Details in a Table
                  pw.Table(
                    border: pw.TableBorder.all(),
                    children: [
                      // Header Row
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text('Product Name', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text('Price', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text('Quantity', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text('Quantity in Box', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                          ),
                        ],
                      ),
                      // Data Row
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(productName, style: pw.TextStyle(fontSize: 16)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text('${productPrice}', style: pw.TextStyle(fontSize: 16)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(quantity, style: pw.TextStyle(fontSize: 16)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(quantityInBox, style: pw.TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text('Payment Mode: $paymentMode', style: pw.TextStyle(fontSize: 16)),
                  pw.SizedBox(height: 20),
                  pw.Text('Total Amount: $totalpayment', style: pw.TextStyle(fontSize: 18,fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 20),
                  pw.Divider(),
                  pw.SizedBox(height: 20),
                  // pw.Center(
                  //   child: pw.Text(
                  //     'Thank you!',
                  //     style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                  //   ),
                  // ),
                ],
              ),
            );
          },
        ),
      );

      // Print the PDF
      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
    }


    return DataRow(
      cells: [
        DataCell(
          SizedBox(
            width: 120,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text(Sells.productName),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 80,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text(Sells.productPrice.toString()),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 80,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text(Sells.productQuantity.toString()),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 80,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text(Sells.boxes.toString()),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 100,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text(Sells.totalPrice.toString()),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 120,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text(Sells.buyerName),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 120,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text(Sells.paymentMode),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 100,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text(DateFormat('yyyy-MM-dd').format(Sells.date)),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 200,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.print),
                  onPressed: () {
                    printInvoice(Sells);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SellsForm(sellsdata: Sells),
                      ),
                    ).then((val){
                      notifyListeners();
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await FirebaseFirestore.instance.collection('SellsData').doc(Sells.id).delete();
                    // Remove the Sells from the list and refresh the table
                    SellsList.remove(Sells);
                    notifyListeners();
                    GlobalData.sellsData.remove(Sells);
                    GlobalData.updateProductStock(Sells.productName, Sells.productQuantity);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => SellsList.length;

  @override
  int get selectedRowCount => 0;
}

class Sellsdata extends StatefulWidget {
  const Sellsdata({Key? key}) : super(key: key);

  @override
  State<Sellsdata> createState() => _SellsdataState();
}

class _SellsdataState extends State<Sellsdata> {
  List<Sellsmodel> _SellsList = [];
  List<Sellsmodel> _filteredSellsList = [];
  TextEditingController _searchController = TextEditingController();
  DateTime? _fromDate;
  DateTime? _toDate;
  int _rowsPerPage = 5;
  SellsDataTableSource? _dataSource;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await GlobalData.fetchEntries();
    setState(() {
      _SellsList = GlobalData.sellsData..sort((a, b) => b.date.compareTo(a.date));
      _filteredSellsList = List.from(_SellsList);
      _applyFilters();
    });
  }

  void _runSearch(String searchQuery) {
    setState(() {
      _applyFilters(searchQuery: searchQuery);
    });
  }

  void _applyFilters({String? searchQuery}) {
    List<Sellsmodel> filtered = _SellsList;
    if (searchQuery != null && searchQuery.isNotEmpty) {
      filtered = filtered.where((Sells) {
        return Sells.productName.toLowerCase().contains(searchQuery.toLowerCase()) ||
            Sells.buyerName.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }
    if (_fromDate != null && _toDate != null) {
      filtered = filtered.where((Sells) {
        return Sells.date.isAfter(_fromDate!.subtract(Duration(days: 1))) &&
            Sells.date.isBefore(_toDate!.add(Duration(days: 1)));
      }).toList();
    }
    setState(() {
      _filteredSellsList = filtered;
      _dataSource = SellsDataTableSource(_filteredSellsList, context);
    });
  }

  void _clearFilters() {
    setState(() {
      _fromDate = null;
      _toDate = null;
      _searchController.clear();
      _filteredSellsList = List.from(_SellsList);
      _dataSource = SellsDataTableSource(_filteredSellsList, context);
    });
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fromDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _fromDate) {
      setState(() {
        _fromDate = picked;
        _applyFilters(searchQuery: _searchController.text);
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _toDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _toDate) {
      setState(() {
        _toDate = picked;
        _applyFilters(searchQuery: _searchController.text);
      });
    }
  }

  Future<void> _exportToExcel() async {
    var excel = Excel.createExcel(); // Create a new Excel workbook
    Sheet sheet = excel['Sheet1']; // Create a new sheet

    // Set headers
    sheet.appendRow([
      'Product Name',
      'Price',
      'Quantity',
      'Boxes',
      'Total Price',
      'Seller Name',
      'Payment Mode',
      'Date',
    ]);

    // Add blank rows
    sheet.appendRow([]);
    sheet.appendRow([]);

    // Add rows with data
    for (var Sells in _filteredSellsList) {
      sheet.appendRow([
        Sells.productName,
        Sells.productPrice,
        Sells.productQuantity,
        Sells.boxes,
        Sells.totalPrice,
        Sells.buyerName,
        Sells.paymentMode,
        DateFormat('yyyy-MM-dd').format(Sells.date),
      ]);
    }

    // Save the file to bytes
    final bytes = await excel.save();

    // Convert bytes to base64
    final base64String = convert.base64Encode(bytes!);

    // Create a Blob from the base64 string
    final blob = html.Blob([convert.base64Decode(base64String)]);

    // Generate current date string
    final currentDate = DateFormat('yyyy-MM-dd-HH-mm').format(DateTime.now());

    // Create an anchor element
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "SellsData_$currentDate.xlsx")
      ..style.display = 'none'; // Hide the anchor element

    // Append the anchor to the document
    // html.document.body?.append(anchor);

    // Trigger a click on the anchor element
    // anchor.click();

    // Remove the anchor from the document
    // anchor.remove();

    // Clean up
    html.Url.revokeObjectUrl(url);

    // Notify user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data exported successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text('Sells Data', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SellsForm()),
                      ).then((_) {
                        setState(() {
                          _SellsList = GlobalData.sellsData..sort((a, b) => b.date.compareTo(a.date));
                          _filteredSellsList = _SellsList;
                          _dataSource = SellsDataTableSource(_filteredSellsList, context);
                          _dataSource = SellsDataTableSource(_filteredSellsList, context);
                          _dataSource?.notifyListeners();
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
                  SizedBox(width: 20,),
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
                  labelText: 'Search by Product Name or Seller Name',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () => _runSearch(_searchController.text),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _selectFromDate(context),
                      child: Text(_fromDate == null
                          ? 'Select From Date'
                          : 'From: ${DateFormat('yyyy-MM-dd').format(_fromDate!)}'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _selectToDate(context),
                      child: Text(_toDate == null
                          ? 'Select To Date'
                          : 'To: ${DateFormat('yyyy-MM-dd').format(_toDate!)}'),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _clearFilters,
                    child: Text('Clear Filters', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            _SellsList.isEmpty
                ? Center(child: Text("No Data Found",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),)
                : Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: PaginatedDataTable(
                  // header: Text('Entries Table'),
                  rowsPerPage: _rowsPerPage,
                  availableRowsPerPage: [5, 10, 50, 100, 500],
                  onRowsPerPageChanged: (rows) {
                    setState(() {
                      _rowsPerPage = rows!;
                    });
                  },
                  columns: [
                    DataColumn(label: Text('Product Name',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text('Price',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text('Quantity',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text('Boxes',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text('Total Price',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text('Buyer Name',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text('Payment Mode',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text('Date',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text('Actions',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),)),
                  ],
                  source: _dataSource!,
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
