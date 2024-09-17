import 'package:cloud_firestore/cloud_firestore.dart';

class Sellsmodel {
  final String productName;
  final double productPrice;
  final int productQuantity;
  final int boxes;
  final double totalPrice;
  final String buyerName;
  final String paymentMode;
  final DateTime date;
  final String id;

  Sellsmodel({
    required this.productName,
    required this.productPrice,
    required this.productQuantity,
    required this.boxes,
    required this.totalPrice,
    required this.buyerName,
    required this.paymentMode,
    required this.date,
    required this.id,
  });

  factory Sellsmodel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Sellsmodel(
      productName: data['productName'],
      productPrice: data['productPrice'],
      productQuantity: data['productQuantity'],
      boxes: data['boxes'],
      totalPrice: data['totalPrice'],
      buyerName: data['buyerName'],
      paymentMode: data['paymentMode'],
      date: (data['date'] as Timestamp).toDate(),
      id: doc.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'productPrice': productPrice,
      'productQuantity': productQuantity,
      'boxes': boxes,
      'totalPrice': totalPrice,
      'buyerName': buyerName,
      'paymentMode': paymentMode,
      'date': Timestamp.fromDate(date),
    };
  }

}
