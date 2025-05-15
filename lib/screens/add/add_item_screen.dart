import 'package:flutter/material.dart';

class AddItemScreen extends StatelessWidget {
  const AddItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text("إضافة منتج")),
      body: Center(
        child: Text(
          "هنا سيتم إضافة المنتجات لاحقًا",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
