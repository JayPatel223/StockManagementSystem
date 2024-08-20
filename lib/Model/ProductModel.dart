import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String productName;
  final int productStock;
  final String id;

  ProductModel({
    required this.productName,
    required this.productStock,
    required this.id,
  });

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return ProductModel(
      productName: data['productName'],
      productStock: data['productStock'],
      id: doc.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'productStock': productStock,
    };
  }

  ProductModel copyWith({
    String? id,
    String? productName,
    int? productStock,
  }) {
    return ProductModel(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      productStock: productStock ?? this.productStock,
    );
  }

}
