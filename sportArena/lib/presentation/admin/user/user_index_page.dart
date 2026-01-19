import 'dart:math';

import 'package:final_project/data/server/model/user.dart';
import 'package:final_project/data/server/repository/auth_repository.dart';
import 'package:final_project/data/service/http_service.dart';
import 'package:final_project/presentation/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';

class UserIndexPage extends StatefulWidget {
  final User user;
  const UserIndexPage({super.key, required this.user});

  @override
  State<UserIndexPage> createState() => _UserIndexPageState();
}

class _UserIndexPageState extends State<UserIndexPage> {
  late AuthRepository _authRepository;
  List<User> _userList = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final httpService = HttpService();
    _authRepository = AuthRepository(httpService);
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _authRepository.getAllUser();
      for (var e in response.data) {
        print("${e.profilePhotoPath}");
      }

      if (mounted) {
        setState(() {
          _userList = response.data
              .where((user) => user.role == 'customer')
              .toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Daftar Customer',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  IconButton(
                    onPressed: _loadUserData,
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Refresh',
                  ),
                ],
              ),

              SizedBox(height: 24),

              Expanded(
                child: _isLoading
                    ? LoadingIndicator()
                    : _userList.isEmpty
                    ? const Center(child: Text('Tidak ada data customer'))
                    : ListView.builder(
                        itemCount: _userList.length,
                        itemBuilder: (context, index) {
                          final customer = _userList[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: ListTile(
                              leading: Builder(
                                builder: (context) {
                                  if (customer.profilePhotoPath == null) {
                                    return CircleAvatar(
                                      backgroundColor: Colors.blue[100],
                                      radius: 25,
                                      child: Text(
                                        customer.name[0].toUpperCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.blue[900],
                                        ),
                                      ),
                                    );
                                  } else {
                                    return SizedBox(
                                      width: 54,
                                      height: 54,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: Image.network(
                                          'http://10.0.2.2:8000/storage/users/${customer.profilePhotoPath!.split('/')[1]}',
                                          fit: BoxFit.cover,
                                          loadingBuilder:
                                              (
                                                context,
                                                child,
                                                loadingProgress,
                                              ) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              },
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                print("$error");
                                                return Text("$error");
                                              },
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                              title: Text(customer.name),
                              subtitle: Text(customer.email),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
