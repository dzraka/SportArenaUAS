import 'package:final_project/data/server/model/user.dart';
import 'package:final_project/data/server/repository/auth_repository.dart';
import 'package:final_project/data/service/http_service.dart';
import 'package:final_project/presentation/Setting/setting_page.dart';
import 'package:final_project/presentation/admin/booking/admin_booking_index_page.dart';
import 'package:final_project/presentation/Home/home_page.dart';
import 'package:final_project/presentation/admin/user/user_index_page.dart';
import 'package:final_project/presentation/customer/booking/booking_history_page.dart';
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

            List<Widget> pages;
            List<BottomNavigationBarItem> navItems;

            if (activeUser.role == 'admin') {
              pages = [
                HomePage(user: activeUser),
                UserIndexPage(user: activeUser),
                AdminBookingIndexPage(),
                SettingPage(user: activeUser),
              ];

              navItems = const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),

                BottomNavigationBarItem(
                  icon: Icon(Icons.people_outline),
                  activeIcon: Icon(Icons.people),
                  label: 'User',
                ),

                BottomNavigationBarItem(
                  icon: Icon(Icons.receipt_outlined),
                  activeIcon: Icon(Icons.receipt),
                  label: 'Booking',
                ),

                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined),
                  activeIcon: Icon(Icons.settings),
                  label: 'Setting',
                ),
              ];
            } else {
              pages = [
                HomePage(user: activeUser),
                BookingHistoryPage(),
                SettingPage(user: activeUser),
              ];

              navItems = const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),

                BottomNavigationBarItem(
                  icon: Icon(Icons.receipt_outlined),
                  activeIcon: Icon(Icons.receipt),
                  label: 'History',
                ),

                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined),
                  activeIcon: Icon(Icons.settings),
                  label: 'Setting',
                ),
              ];
            }
            if (_currentIndex >= pages.length) {
              _currentIndex = 0;
            }

            return Scaffold(
              body: pages[_currentIndex],
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (value) => setState(() => _currentIndex = value),
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: true,
                items: navItems,
              ),
            );
          }
          return const Center(child: Text('Failed to load'));
        },
      ),
    );
  }
}
