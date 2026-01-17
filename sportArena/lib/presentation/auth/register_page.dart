import 'package:final_project/data/server/repository/auth_repository.dart';
import 'package:final_project/data/server/usecase/request/register_request.dart';
import 'package:final_project/data/service/http_service.dart';
import 'package:final_project/presentation/auth/login_page.dart';
import 'package:final_project/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtr = TextEditingController();
  final _emailCtr = TextEditingController();
  final _phoneCtr = TextEditingController();
  final _passwordCtr = TextEditingController();
  final _confirmCtr = TextEditingController();

  bool isObscure = true;
  bool isConfirmObscure = true;
  bool _isLoading = false;
  String? _errorMessage;
  late AuthRepository _authRepository;

  @override
  void initState() {
    super.initState();
    final httpService = HttpService();
    _authRepository = AuthRepository(httpService);
  }

  @override
  void dispose() {
    _nameCtr.dispose();
    _emailCtr.dispose();
    _phoneCtr.dispose();
    _passwordCtr.dispose();
    _confirmCtr.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final request = RegisterRequest(
        name: _nameCtr.text,
        email: _emailCtr.text,
        password: _passwordCtr.text,
        phoneNumber: _phoneCtr.text,
        passwordConfirmation: _confirmCtr.text,
      );

      final response = await _authRepository.register(request);

      if (response.status == 'success' ||
          response.message.toLowerCase().contains('success')) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful! Please login'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      } else {
        setState(() {
          _errorMessage = response.message;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Connection failed $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Masuk'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Center(
            child: Image.asset(
              'assets/img/logo.png',
              height: 100,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 24.0),

          Text(
            'Daftar',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8.0),

          Text(
            'Bergabunglah bersama kami. Daftarkan diri Anda untuk kemudahan akses venue.',
            style: TextStyle(fontSize: 14, height: 1.5),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 40),

          Form(
            key: _formKey,
            child: Column(
              children: [
                if (_errorMessage != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red[900]),
                      textAlign: TextAlign.center,
                    ),
                  ),

                TextFormField(
                  controller: _nameCtr,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Nama wajib diisi';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Nama Lengkap',
                    hintText: 'Masukkan nama Anda',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),

                SizedBox(height: 16),

                TextFormField(
                  controller: _emailCtr,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Email wajib diisi';
                    } else if (!value.contains('@') || !value.contains('.')) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Masukkan email Anda',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),

                SizedBox(height: 16),

                TextFormField(
                  controller: _phoneCtr,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Nomor telepon wajib diisi';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return "Nomor telepon hanya boleh berisi angka";
                    }
                    if (value.length < 10 || value.length > 13) {
                      return "Nomor telepon harus 10-13 digit";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  maxLength: 13,
                  decoration: InputDecoration(
                    labelText: 'Nomor Telepon',
                    hintText: 'Masukkan nomor telepon',
                    prefixIcon: Icon(Icons.phone_android),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    counterText: "",
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),

                SizedBox(height: 16),

                TextFormField(
                  controller: _passwordCtr,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Kata sandi wajib diisi";
                    } else if (value.length < 8) {
                      return "Kata sandi minimal 8 karakter";
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  obscureText: isObscure,
                  decoration: InputDecoration(
                    labelText: 'Kata Sandi',
                    hintText: 'Masukkan kata sandi',
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                      icon: Icon(
                        isObscure ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),

                SizedBox(height: 16),

                TextFormField(
                  controller: _confirmCtr,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Konfirmasi kata sandi wajib diisi";
                    } else if (value != _passwordCtr.text) {
                      return "Kata sandi tidak cocok";
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                  obscureText: isConfirmObscure,
                  decoration: InputDecoration(
                    labelText: 'Konfirmasi Kata Sandi',
                    hintText: 'Masukkan ulang kata sandi',
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isConfirmObscure = !isConfirmObscure;
                        });
                      },
                      icon: Icon(
                        isConfirmObscure
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),

                SizedBox(height: 24),

                PrimaryButton(
                  text: 'Daftar',
                  isLoading: _isLoading,
                  onPressed: _register,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
