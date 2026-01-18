import 'package:final_project/data/server/model/field.dart';
import 'package:final_project/data/server/model/user.dart';
import 'package:final_project/data/server/repository/field_repository.dart';
import 'package:final_project/data/service/http_service.dart';
import 'package:final_project/presentation/Setting/profile_page.dart';
import 'package:final_project/presentation/admin/field/create_field_page.dart';
import 'package:final_project/presentation/admin/field/edit_field_page.dart';
import 'package:final_project/presentation/customer/booking/booking_form_page.dart';
import 'package:final_project/presentation/widgets/field_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late FieldRepository _fieldRepository;
  List<Field> _allFields = [];
  List<Field> _filteredFields = [];

  bool _isLoading = true;
  String? _errorMessage;

  bool get _isAdmin => widget.user.role == 'admin';

  @override
  void initState() {
    super.initState();
    final httpService = HttpService();
    _fieldRepository = FieldRepository(httpService);
    _loadFields();
  }

  Future<void> _loadFields() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _fieldRepository.getAllFields();
      if (mounted) {
        setState(() {
          _allFields = response.data;
          _filteredFields = _allFields;
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

  void _searchFields(String keyword) {
    List<Field> result = [];
    if (keyword.isEmpty) {
      result = _allFields;
    } else {
      result = _allFields
          .where(
            (field) =>
                field.name.toLowerCase().contains(keyword.toLowerCase()) ||
                field.category.toLowerCase().contains(keyword.toLowerCase()),
          )
          .toList();
    }
    setState(() {
      _filteredFields = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _isAdmin
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateFieldPage(),
                  ),
                );
                _loadFields();
              },
              tooltip: 'Add new field',
              shape: CircleBorder(),
              child: Icon(Icons.add),
            )
          : null,

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadFields,
          child: ListView(
            padding: const EdgeInsets.all(24.0),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              _header(),

              const SizedBox(height: 24),

              SearchBar(
                hintText: 'Search fields',
                leading: Icon(Icons.search),
                onChanged: (value) => _searchFields(value),
              ),

              const SizedBox(height: 24),

              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_errorMessage != null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 50,
                          color: Colors.red,
                        ),
                        Text('Failed to load data: $_errorMessage'),
                        TextButton(
                          onPressed: _loadFields,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                )
              else if (_filteredFields.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _allFields.isEmpty
                              ? Icons.stadium_outlined
                              : Icons.search_off,
                          size: 80,
                          color: Colors.grey[300],
                        ),

                        const SizedBox(height: 16),

                        Text(
                          _allFields.isEmpty
                              ? 'Lapangan belum tersedia'
                              : 'Lapangan tidak ditemukan',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filteredFields.length,
                  itemBuilder: (context, index) {
                    final field = _filteredFields[index];
                    return FieldCard(
                      field: field,
                      onTap: () async {
                        if (_isAdmin) {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditFieldPage(field: field),
                            ),
                          );
                          _loadFields();
                        } else {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingFormPage(),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat datang',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            Text(
              widget.user.name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
            ),
          ],
        ),

        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(user: widget.user),
              ),
            );
          },
          borderRadius: BorderRadius.circular(50),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: CircleAvatar(
              backgroundColor: Colors.blue[100],
              radius: 25,
              child: Text(
                widget.user.name[0].toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.blue[900],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
