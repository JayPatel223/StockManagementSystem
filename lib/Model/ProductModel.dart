import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String productName;
  final int productStock;
  final int qnt;
  final String id;

  ProductModel({
    required this.productName,
    required this.productStock,
    required this.qnt,
    required this.id,
  });

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return ProductModel(
      productName: data['productName'],
      productStock: data['productStock'],
      qnt: data['qnt'],
      id: doc.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'productStock': productStock,
      'qnt': qnt,
    };
  }

  ProductModel copyWith({
    String? id,
    String? productName,
    int? productStock,
    int? qnt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      productStock: productStock ?? this.productStock,
      qnt: qnt ?? this.qnt,
    );
  }

}
