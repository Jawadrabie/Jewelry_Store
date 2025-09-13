// lib/screens/add/add_item_screen.dart
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../cubit/add_product/product_add_cubit.dart';
import '../../../cubit/add_product/product_add_state.dart';
import '../../../data/models/product_upload_request.dart';
import '../../../core/dialogs.dart';
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
  final _weightCtrl = TextEditingController();

  File? _pickedFile;
  bool _isUploading = false;

  Future<void> _pickFromGallery() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false, // API expects single file only
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _pickedFile = File(result.files.first.path!);
      });
    }
  }

  Future<void> _pickFromCamera() async {
    final picker = ImagePicker();
    final xfile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (xfile != null) {
      setState(() {
        _pickedFile = File(xfile.path);
      });
    }
  }

  void _showPickSource() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('اختيار من المعرض'),
                onTap: () async {
                  Navigator.pop(ctx);
                  await _pickFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('التقاط عبر الكاميرا'),
                onTap: () async {
                  Navigator.pop(ctx);
                  await _pickFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _onSubmit() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      AppDialogs.showLoginRequiredDialog(
        context: context,
        onLoginPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        },
        content: 'الرجاء تسجيل الدخول للمتابعة في رفع المنتج.',
      );
      return;
    }

    if (!_formKey.currentState!.validate() || _pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء تعبئة جميع الحقول واختيار صورة')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    final request = ProductUploadRequest(
      name: _nameCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      price: 10.0,
      weight: _weightCtrl.text.trim(),
      file: _pickedFile,
    );

    await context.read<ProductAddCubit>().addProduct(
      request: request,
      token: token,
    );
    
    if (mounted) {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _clearForm() {
    _nameCtrl.clear();
    _descCtrl.clear();
    _weightCtrl.clear();
    setState(() {
      _pickedFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductAddCubit, ProductAddState>(
      listener: (context, state) {
        if (state is ProductAddSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('تم رفع المنتج بنجاح')));
          // Clear form after successful upload
          _clearForm();
        } else if (state is ProductAddFailure) {
          print('خطأ: ${state.error}');
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('خطأ: ${state.error}')));
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
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _weightCtrl,
                    decoration: const InputDecoration(labelText: 'الوزن'),
                    validator: (value) =>
                        value!.isEmpty ? 'هذا الحقل مطلوب' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _descCtrl,
                    decoration: const InputDecoration(labelText: 'الوصف'),
                    maxLines: 3,
                    validator: (value) =>
                        value!.isEmpty ? 'هذا الحقل مطلوب' : null,
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: _showPickSource,
                    icon: const Icon(Icons.upload_file),
                    label: const Text('رفع الصورة'),
                  ),

                  const SizedBox(height: 12),
                  // معاينة الصورة المختارة
                  if (_pickedFile != null)
                    SizedBox(
                      height: 100,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              _pickedFile!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _pickedFile = null;
                                });
                              },
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
                  _isUploading || state is ProductAddLoading
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : ElevatedButton.icon(
                          onPressed: _onSubmit,
                          icon: const Icon(Icons.cloud_upload_outlined),
                          label: const Text('رفع المنتج'),
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
    _weightCtrl.dispose();
    super.dispose();
  }
}
