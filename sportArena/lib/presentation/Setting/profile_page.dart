import 'dart:io';

import 'package:final_project/data/server/model/user.dart';
import 'package:final_project/data/server/repository/auth_repository.dart';
import 'package:final_project/data/service/http_service.dart';
import 'package:final_project/presentation/storage_helper.dart';
import 'package:final_project/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late AuthRepository _authRepository;

  late TextEditingController _nameCtr;
  late TextEditingController _phoneCtr;
  late TextEditingController _emailCtr;

  User? userData;
  bool _isLoading = false;
  bool _isSaving = false;

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final httpService = HttpService();
    _authRepository = AuthRepository(httpService);

    userData = widget.user;
    _nameCtr = TextEditingController(text: userData?.name ?? '');
    _phoneCtr = TextEditingController(text: userData?.phoneNumber ?? '');
    _emailCtr = TextEditingController(text: userData?.email ?? '');

    _loadProfile();
  }

  @override
  void dispose() {
    _nameCtr.dispose();
    _phoneCtr.dispose();
    _emailCtr.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final response = await _authRepository.getUserProfile();

      if (mounted) {
        setState(() {
          userData = response.data;
          _nameCtr.text = userData!.name;
          _phoneCtr.text = userData!.phoneNumber;
          _emailCtr.text = userData!.email;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _takePicture() async {
    try {
      final pickImage = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        imageQuality: 80,
      );

      if (pickImage != null) {
        final saveImage = await StorageHelper.saveImg(
          File(pickImage.path),
          'photo',
        );

        setState(() {
          _imageFile = saveImage;
        });
      }
    } catch (e) {
      print('Error camera: $e');
    }
  }

  Future<void> _takeFromFile() async {
    try {
      final imagePicker = ImagePicker();
      final pickImage = await imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        imageQuality: 80,
      );

      if (pickImage != null) {
        final saveImage = File(pickImage.path);
        setState(() {
          _imageFile = saveImage;
        });
      }
    } catch (e) {
      print('Error galery: $e');
    }
  }

  Future<void> _showImagePickerSheet() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Ambil dari Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _takeFromFile();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Ambil Foto'),
                onTap: () {
                  Navigator.pop(context);
                  _takePicture();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveProfile() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final Map<String, String> data = {
        'name': _nameCtr.text,
        'phone_number': _phoneCtr.text,
        'email': _emailCtr.text,
        'profile_photo_path': _imageFile!.path,
      };
      final success = await _authRepository.updateProfile(data, _imageFile);

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profil berhasil diperbarui'),
              backgroundColor: Colors.green,
            ),
          );

          _loadProfile();

          setState(() {
            _imageFile = null;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: ${e.toString()}')),
        );
        print(e);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  InkWell(
                    onTap: _showImagePickerSheet,
                    borderRadius: BorderRadius.circular(75),
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: ClipOval(child: _buildProfileImage()),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),

            _buildTextField(
              controller: _nameCtr,
              label: 'Nama Lengkap',
              icon: Icons.person_outline,
            ),

            _buildTextField(
              controller: _phoneCtr,
              label: 'Nomor Telepon',
              icon: Icons.phone_android_outlined,
              keyboardType: TextInputType.phone,
            ),

            _buildTextField(
              controller: _emailCtr,
              label: 'Email',
              icon: Icons.email_outlined,
              isReadOnly: true,
            ),

            const SizedBox(height: 32),

            PrimaryButton(
              text: 'Simpan perubahan',
              isLoading: _isSaving,
              onPressed: _saveProfile,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    if (_imageFile != null) {
      return Image.file(_imageFile!, fit: BoxFit.cover);
    }

    if (userData?.profilePhotoPath != null &&
        userData!.profilePhotoPath!.isNotEmpty) {
      String imageUrl = userData!.profilePhotoPath!;
      if (!imageUrl.startsWith('http')) {
        imageUrl = 'http://10.0.2.2:8000/storage/$imageUrl';
      }
      print("[image profile] $imageUrl");

      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          print("$error");
          return _buildProfileDefault();
        },
      );
    }

    return _buildProfileDefault();
  }

  Widget _buildProfileDefault() {
    return Container(
      color: Colors.blue[100],
      alignment: Alignment.center,
      child: Text(
        (userData?.name.isNotEmpty ?? false)
            ? userData!.name[0].toUpperCase()
            : '?',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 48,
          color: Colors.blue[900],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isReadOnly = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: isReadOnly,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue),
          filled: true,
          fillColor: isReadOnly ? Colors.grey[200] : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }
}
