// lib/screens/add/add_item_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../cubit/add_product/product_add_cubit.dart';
import '../../../cubit/add_product/product_add_state.dart';
import '../../../data/models/product_upload_request.dart';
import '../auth/login_screen_.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();

  File? _pickedFile;

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _pickedFile = File(result.files.single.path!);
      });
    }
  }

  void _onSubmit() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('Saved token:> ${prefs.getString('token')}');

    if (token == null) {
      _showLoginDialog();
      return;
    }

    if (!_formKey.currentState!.validate() || _pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء تعبئة جميع الحقول واختيار صورة')),
      );
      return;
    }

    final request = ProductUploadRequest(
      name: _nameCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      price: double.parse(_priceCtrl.text.trim()),
      weight: _weightCtrl.text.trim(),
      file: _pickedFile!,
    );

    context.read<ProductAddCubit>().addProduct(request: request, token: token);
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تسجيل الدخول مطلوب'),
        content: const Text('الرجاء تسجيل الدخول للمتابعة في رفع المنتج.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('رجوع'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: const Text('تسجيل الدخول'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductAddCubit, ProductAddState>(
      listener: (context, state) {
        if (state is ProductAddSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم رفع المنتج بنجاح')),
          );
          Navigator.pop(context);
        } else if (state is ProductAddFailure) {
          print('خطأ: ${state.error}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('خطأ: ${state.error}')),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('إضافة منتج')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(labelText: 'اسم المنتج'),
                    validator: (value) =>
                    value!.isEmpty ? 'هذا الحقل مطلوب' : null,
                  ),
                  TextFormField(
                    controller: _descCtrl,
                    decoration: const InputDecoration(labelText: 'الوصف'),
                    validator: (value) =>
                    value!.isEmpty ? 'هذا الحقل مطلوب' : null,
                  ),
                  TextFormField(
                    controller: _priceCtrl,
                    decoration: const InputDecoration(labelText: 'السعر'),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                    value!.isEmpty ? 'هذا الحقل مطلوب' : null,
                  ),
                  TextFormField(
                    controller: _weightCtrl,
                    decoration: const InputDecoration(labelText: 'الوزن'),
                    validator: (value) =>
                    value!.isEmpty ? 'هذا الحقل مطلوب' : null,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.file_upload),
                    label: Text(_pickedFile == null
                        ? 'اختيار صورة'
                        : 'تم اختيار صورة'),
                  ),
                  const SizedBox(height: 24),
                  state is ProductAddLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                    onPressed: _onSubmit,
                    child: const Text('رفع المنتج'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }
}
