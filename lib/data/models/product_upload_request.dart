// lib/data/models/product_upload_request.dart
import 'dart:io';

class ProductUploadRequest {
  final String name;
  final String description;
  final double price;
  final String weight;
  final File file;

  ProductUploadRequest({
    required this.name,
    required this.description,
    required this.price,
    required this.weight,
    required this.file,
  });
}