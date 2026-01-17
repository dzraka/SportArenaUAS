import 'dart:io';
import 'dart:math';

import 'package:final_project/data/server/model/field.dart';
import 'package:final_project/data/server/repository/field_repository.dart';
import 'package:final_project/data/server/usecase/request/add_field_request.dart';
import 'package:final_project/data/service/http_service.dart';
import 'package:final_project/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditFieldPage extends StatefulWidget {
  final Field field;

  const EditFieldPage({super.key, required this.field});

  @override
  State<EditFieldPage> createState() => _EditFieldPageState();
}

class _EditFieldPageState extends State<EditFieldPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtr;
  late TextEditingController _priceCtr;

  String? _selectedType;
  final List<String> _categories = ['futsal', 'badminton', 'basket'];
  bool _isAvailable = true;
  File? _newImageFile;

  late FieldRepository _fieldRepository;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final httpService = HttpService();
    _fieldRepository = FieldRepository(httpService);

    _nameCtr = TextEditingController(text: widget.field.name);
    _priceCtr = TextEditingController(text: widget.field.price.toString());
    _isAvailable = widget.field.isAvailable;

    if (_categories.contains(widget.field.category)) {
      _selectedType = widget.field.category;
    } else if (_categories.contains(widget.field.category.toLowerCase())) {
      _selectedType = widget.field.category.toLowerCase();
    } else {
      _selectedType = _categories.first;
    }
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
        _newImageFile = File(pickedFile.path);
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
          image: _newImageFile,
        );

        final isSuccess = await _fieldRepository.updateField(
          request,
          widget.field.id,
        );

        if (isSuccess) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Berhasil memperbarui data'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          }
        } else {
          throw Exception('Gagal mengupdate data');
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

  void _delete() async {
    final bool? confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Lapangan'),
        content: Text(
          'Apakah anda yakin ingin menghapus lapangan? ${widget.field.name}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmDelete != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final isSuccess = await _fieldRepository.deleteField(widget.field.id);

      if (isSuccess) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Berhasil menghapus data'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        } else {
          throw Exception('Gagal menghapus data');
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Lapangan")),
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
                      image: _getImageProvider(),
                    ),
                    child:
                        (_newImageFile == null && widget.field.imageUrl == null)
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                size: 40,
                                color: Colors.grey,
                              ),
                              Text('Ubah gambar'),
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    prefixIcon: const Icon(Icons.stadium),
                  ),
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
                  decoration: InputDecoration(
                    labelText: 'Kategori Lapangan',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    prefixIcon: const Icon(Icons.category),
                  ),
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _priceCtr,
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Harga wajib diisi'
                      : null,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Harga per Jam (Rp)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    prefixIcon: const Icon(Icons.monetization_on),
                  ),
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
                    subtitle: Text(_isAvailable ? 'Aktif' : 'Maintenance'),
                    secondary: Icon(
                      _isAvailable ? Icons.check_circle : Icons.cancel,
                      color: _isAvailable ? Colors.green : Colors.red,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                PrimaryButton(
                  text: 'Update lapangan',
                  isLoading: _isLoading,
                  onPressed: _submitForm,
                ),

                const SizedBox(height: 16),

                PrimaryButton(
                  text: 'Hapus lapangan',
                  isLoading: _isLoading,
                  onPressed: _delete,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DecorationImage? _getImageProvider() {
    if (_newImageFile != null) {
      return DecorationImage(
        image: FileImage(_newImageFile!),
        fit: BoxFit.cover,
      );
    } else if (widget.field.imageUrl != null) {
      return DecorationImage(
        image: NetworkImage(widget.field.imageUrl!),
        fit: BoxFit.cover,
      );
    }
    return null;
  }
}
