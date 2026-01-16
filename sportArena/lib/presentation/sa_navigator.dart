import 'package:final_project/data/server/model/user.dart';
import 'package:final_project/data/server/repository/auth_repository.dart';
import 'package:final_project/data/service/http_service.dart';
import 'package:final_project/presentation/booking/booking_index.dart';
import 'package:final_project/presentation/home/home_page.dart';
import 'package:final_project/presentation/profile.dart';
import 'package:flutter/material.dart';

class SaNavigator extends StatefulWidget {
  const SaNavigator({super.key});

  @override
  State<SaNavigator> createState() => _SaNavigatorState();
}

class _SaNavigatorState extends State<SaNavigator> {
  int _currentIndex = 0;
  late AuthRepository _authRepository;
  late Future<User?> _userFuture;

  @override
  void initState() {
    super.initState();
    final httpService = HttpService();
    _authRepository = AuthRepository(httpService);
    _userFuture = _getUserProfile();
  }

  Future<User?> _getUserProfile() async {
    final response = await _authRepository.getUserProfile();
    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData && snapshot.data != null) {
            final User activeUser = snapshot.data!;
            final List<Widget> pages = [HomePage(), BookingIndex(), Profile()];
            return pages[_currentIndex];
          }
          return const Center(child: Text('Failed to load'));
        },
      ),

      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) => setState(() => _currentIndex = value),
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
            activeIcon: Icon(Icons.home),
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_outlined),
            label: 'Booking',
            activeIcon: Icon(Icons.receipt),
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
            activeIcon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
