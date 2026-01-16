import 'dart:io';

import 'package:final_project/data/server/repository/field_repository.dart';
import 'package:final_project/data/server/usecase/request/add_field_request.dart';
import 'package:final_project/data/service/http_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateFieldPage extends StatefulWidget {
  const CreateFieldPage({super.key});

  @override
  State<CreateFieldPage> createState() => _CreateFieldPageState();
}

class _CreateFieldPageState extends State<CreateFieldPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtr = TextEditingController();
  final _priceCtr = TextEditingController();

  String? _selectedType;
  final List<String> _categories = ['futsal', 'badminton', 'basket'];
  bool _isAvailable = true;
  File? _imageFile;

  late FieldRepository _fieldRepository;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final httpService = HttpService();
    _fieldRepository = FieldRepository(httpService);
  }

  @override
  void dispose() {
    _nameCtr.dispose();
    _priceCtr.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final request = AddFieldRequest(
          name: _nameCtr.text,
          category: _selectedType!,
          price: int.parse(_priceCtr.text),
          isAvailable: _isAvailable,
          image: _imageFile,
        );

        final isSuccess = await _fieldRepository.createField(request);

        if (isSuccess) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Berhasil menambahkan lapangan'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          } else {
            throw Exception('Gagal menyimpan data');
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error: ${e.toString().replaceAll('Exception:', '')}',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(16),
                      image: _imageFile != null
                          ? DecorationImage(
                              image: FileImage(_imageFile!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _imageFile == null
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                size: 40,
                                color: Colors.grey,
                              ),
                              Text('Tambah gambar'),
                            ],
                          )
                        : null,
                  ),
                ),

                const SizedBox(height: 24),

                TextFormField(
                  controller: _nameCtr,
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Nama lapangan wajib diisi'
                      : null,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Nama Lapangan',
                    hintText: 'Contoh: Futsal A',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    prefixIcon: Icon(Icons.stadium),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),

                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  initialValue: _selectedType,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedType = newValue;
                    });
                  },
                  items: _categories.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type.toUpperCase()),
                    );
                  }).toList(),
                  validator: (value) =>
                      (value == null) ? 'Kategori wajib dipilih' : null,
                  decoration: InputDecoration(
                    labelText: 'Kategori Lapangan',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    prefixIcon: Icon(Icons.category),
                  ),
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _priceCtr,
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Harga wajib diisi'
                      : null,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Harga per Jam (Rp)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    prefixIcon: Icon(Icons.monetization_on),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),

                const SizedBox(height: 16),

                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SwitchListTile(
                    value: _isAvailable,
                    onChanged: (bool value) {
                      setState(() {
                        _isAvailable = value;
                      });
                    },
                    title: const Text('Status'),
                    subtitle: Text(
                      _isAvailable
                          ? 'Lapangan aktif dan bisa dipesan'
                          : 'Lapangan sedang maintenance',
                    ),
                    secondary: Icon(
                      _isAvailable ? Icons.check_circle : Icons.cancel,
                      color: _isAvailable ? Colors.green : Colors.red,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    child: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Tambah Lapangan',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
