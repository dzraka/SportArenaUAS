import 'package:final_project/core/navigation/sa_navigator.dart';
import 'package:final_project/data/server/repository/auth_repository.dart';
import 'package:final_project/data/server/usecase/request/login_request.dart';
import 'package:final_project/data/service/http_service.dart';
import 'package:final_project/presentation/auth/register_page.dart';
import 'package:final_project/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtr = TextEditingController();
  final _passwordCtr = TextEditingController();

  bool isObscure = true;
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
    _emailCtr.dispose();
    _passwordCtr.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final request = LoginRequest(
        email: _emailCtr.text,
        password: _passwordCtr.text,
      );

      final response = await _authRepository.login(request);

      if (response.data != null) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SaNavigator()),
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterPage()),
              );
            },
            child: Text('Daftar'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 40),

          Center(
            child: Image.asset(
              'assets/img/logo.png',
              height: 100,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 24.0),

          Text(
            'Masuk',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8.0),

          Text(
            'Selamat datang kembali. Silakan masuk untuk melanjutkan aktivitas Anda.',
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
                  controller: _emailCtr,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Email harus diisi';
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
                  controller: _passwordCtr,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Password harus diisi";
                    } else if (value.length < 8) {
                      return "Password minimal 8 karakter";
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                  obscureText: isObscure,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Masukkan password Anda',
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

                SizedBox(height: 24),

                PrimaryButton(
                  text: 'Masuk',
                  isLoading: _isLoading,
                  onPressed: () async => await _login(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
