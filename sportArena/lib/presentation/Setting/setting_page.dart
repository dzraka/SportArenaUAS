import 'package:final_project/data/server/model/user.dart';
import 'package:final_project/presentation/Setting/profile_page.dart';
import 'package:final_project/presentation/auth/login_page.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  final User user;

  const SettingPage({super.key, required this.user});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingItem(
            context,
            title: 'Profil Saya',
            icon: Icons.person_outline,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(user: widget.user),
                ),
              );
            },
          ),

          _buildSettingItem(
            context,
            title: 'Keluar',
            icon: Icons.logout_outlined,
            isLogout: true,
            onTap: () async {
              final bool? confirm = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Konfirmasi"),
                  content: const Text("Apakah anda yakin ingin keluar?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text("Batal"),
                    ),

                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Ya, keluar"),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: isLogout
                    ? Colors.redAccent.withValues(alpha: 0.1)
                    : Colors.blueAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isLogout ? Colors.redAccent : Colors.blueAccent,
              ),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: isLogout ? Colors.redAccent : Colors.black,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
