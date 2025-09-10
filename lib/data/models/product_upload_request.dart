// lib/data/models/product_upload_request.dart
import 'dart:io';

class ProductUploadRequest {
  final String name;
  final String description;
  final double price;
  final String weight;
  // Backwards compatibility: either provide a single file or multiple files
  final File? file;
  final List<File> files;

  ProductUploadRequest({
    required this.name,
    required this.description,
    required this.price,
    required this.weight,
    this.file,
    this.files = const [],
  });
}
