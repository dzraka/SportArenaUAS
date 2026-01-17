import 'package:final_project/data/server/model/user.dart';
import 'package:final_project/data/server/repository/auth_repository.dart';
import 'package:final_project/data/service/http_service.dart';
import 'package:final_project/presentation/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';

class UserIndex extends StatefulWidget {
  final User user;
  const UserIndex({super.key, required this.user});

  @override
  State<UserIndex> createState() => _UserIndexState();
}

class _UserIndexState extends State<UserIndex> {
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
              Text(
                'Daftar Customer',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 24),

              Expanded(
                child: _isLoading
                    ? LoadingIndicator()
                    : _userList.isEmpty
                    ? const Center(child: Text('Tidak ada data customer'))
                    : RefreshIndicator(
                        onRefresh: _loadUserData,
                        child: ListView.builder(
                          itemCount: _userList.length,
                          itemBuilder: (context, index) {
                            final customer = _userList[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text(customer.name[0].toUpperCase()),
                                ),
                                title: Text(customer.name),
                                subtitle: Text(customer.email),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
