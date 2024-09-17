import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harsh/Model/SellsModel.dart';
import 'package:intl/intl.dart';

import '../Model/EntryModel.dart';
import '../Model/ProductModel.dart';

class GlobalData {
  static List<EntryModel> entryData = [];

  // Global variables to store the sums
  static double totalEntryPrice = 0.0;
  static double onlinePaymentTotal = 0.0;
  static double cashPaymentTotal = 0.0;

  static double totalSellsPrice = 0.0;
  static double sellsonlinePaymentTotal = 0.0;
  static double sellscashPaymentTotal = 0.0;

  static String formattedEntryPrice = NumberFormat.currency(
    locale: 'en_IN', // Use the Indian locale
    symbol: '₹', // Currency symbol
    decimalDigits: 0, // No decimal places
  ).format(GlobalData.totalEntryPrice);

  static String formattedonlinePaymentTotal = NumberFormat.currency(
    locale: 'en_IN', // Use the Indian locale
    symbol: '₹', // Currency symbol
    decimalDigits: 0, // No decimal places
  ).format(GlobalData.onlinePaymentTotal);

  static String formattedcashPaymentTotal = NumberFormat.currency(
    locale: 'en_IN', // Use the Indian locale
    symbol: '₹', // Currency symbol
    decimalDigits: 0, // No decimal places
  ).format(GlobalData.cashPaymentTotal);

  static String formattedSellsPrice = NumberFormat.currency(
    locale: 'en_IN', // Use the Indian locale
    symbol: '₹', // Currency symbol
    decimalDigits: 0, // No decimal places
  ).format(GlobalData.totalSellsPrice);

  static String SellsformattedonlinePaymentTotal = NumberFormat.currency(
    locale: 'en_IN', // Use the Indian locale
    symbol: '₹', // Currency symbol
    decimalDigits: 0, // No decimal places
  ).format(GlobalData.sellsonlinePaymentTotal);

  static String SellsformattedcashPaymentTotal = NumberFormat.currency(
    locale: 'en_IN', // Use the Indian locale
    symbol: '₹', // Currency symbol
    decimalDigits: 0, // No decimal places
  ).format(GlobalData.sellscashPaymentTotal);


  static Future<void> fetchEntries() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('DataEntry')
        .get();

    entryData = snapshot.docs.map((doc) => EntryModel.fromFirestore(doc)).toList();

    // Calculate the total prices after fetching entries
    calculateTotalPrices();

    print("Total Entry Price: $totalEntryPrice");
    print("Online Payment Total: $onlinePaymentTotal");
    print("Cash Payment Total: $cashPaymentTotal");
    print("${entryData.length}");
  }

  static void calculateTotalPrices() {
    // Reset totals to avoid accumulation during repeated fetches
    totalEntryPrice = 0.0;
    onlinePaymentTotal = 0.0;
    cashPaymentTotal = 0.0;

    for (var entry in entryData) {
      totalEntryPrice += entry.totalPrice ?? 0.0;

      if (entry.paymentMode == "Online") {
        onlinePaymentTotal += entry.totalPrice ?? 0.0;
      } else if (entry.paymentMode == "Cash") {
        cashPaymentTotal += entry.totalPrice ?? 0.0;
      }
    }
  }

  static void calculatesellsTotalPrices() {
    // Reset totals to avoid accumulation during repeated fetches
    totalSellsPrice = 0.0;
    sellsonlinePaymentTotal = 0.0;
    sellscashPaymentTotal = 0.0;

    for (var sells in sellsData) {
      totalSellsPrice += sells.totalPrice ?? 0.0;

      if (sells.paymentMode == "Online") {
        sellsonlinePaymentTotal += sells.totalPrice ?? 0.0;
      } else if (sells.paymentMode == "Cash") {
        sellscashPaymentTotal += sells.totalPrice ?? 0.0;
      }
    }
  }

  static List<Sellsmodel> sellsData = [];

  static Future<void> fetchSells() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('SellsData')
        .get();

    sellsData = snapshot.docs.map((doc) => Sellsmodel.fromFirestore(doc)).toList();

    calculatesellsTotalPrices();

    print("Total Sells Price: $totalSellsPrice");
    print("Online Payment Total: $sellsonlinePaymentTotal");
    print("Cash Payment Total: $sellscashPaymentTotal");
    print("${sellsData.length}");
  }

  static List<ProductModel> productData = [];

  static Future<void> fetchProducts() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('ProductData')
        .get();

    productData = snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();

    // print("Product ${productData[0].productName}");
    // print("${productData.length}");
  }

  static Future<void> updateProductStock(String productName, int stockChange) async {
    try {
      // Find the index of the product with the given name
      int productIndex = productData.indexWhere((product) => product.productName == productName);

      if (productIndex != -1) {
        ProductModel product = productData[productIndex];
        // Calculate the new stock value
        int newStock = product.productStock + stockChange;

        // Update the product stock in Firestore
        await FirebaseFirestore.instance
            .collection('ProductData')
            .doc(product.id) // Assuming 'id' is the document ID in Firestore
            .update({'productStock': newStock});

        // Create a new ProductModel with updated stock and replace the old one
        productData[productIndex] = product.copyWith(productStock: newStock);

        print('Product stock updated successfully: $productName -> $newStock');
      } else {
        print('Product not found: $productName');
      }
    } catch (e) {
      print('Error updating product stock: $e');
    }
  }
}
