import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:unilink/models/user.dart';
import 'package:unilink/navigation/routes.dart';
import 'package:unilink/providers/auth_provider.dart';
import 'package:unilink/providers/user_provider.dart' as user_provider;
import 'package:unilink/screens/edit_profile_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _editProfile(BuildContext context, WidgetRef ref, User? user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(initialUser: user),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(user_provider.userProfileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF5D4037),
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile ',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () => _editProfile(
              context,
              ref,
              userProfile.value,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await ref.read(authProvider.notifier).signOut();
              if (context.mounted) {
                context.go(Routes.login);
              }
            },
          ),
        ],
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF5F0EB),
              Color(0xFFE6DED7),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: userProfile.when(
          data: (user) {
            if (user == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Complete your profile ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5D4037),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5D4037),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => _editProfile(context, ref, null),
                      child: const Text('Complete Profile'),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  Hero(
                    tag: 'profile-avatar',
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: const Color(0xFF5D4037),
                      child: Text(
                        user.name.isNotEmpty
                            ? user.name[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3E2723),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    user.email,
                    style: const TextStyle(
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Card(
                    color: const Color(0xFFFFFBF5),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        _buildTile(Icons.badge, "SIC", user.sic),
                        const Divider(height: 1),
                        _buildTile(Icons.school, "Year", user.year),
                        const Divider(height: 1),
                        _buildTile(Icons.calendar_today, "Semester", user.semester),
                        const Divider(height: 1),
                        _buildTile(Icons.location_city, "College", user.college),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () =>
              const Center(child: CircularProgressIndicator()),
          error: (error, stack) =>
              Center(child: Text('Error: $error')),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: const Color(0xFF5D4037),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(Routes.home);
              break;
            case 1:
              context.go(Routes.notifications);
              break;
            case 2:
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildTile(IconData icon, String title, String value) {
    return ListTile(
      tileColor: const Color(0xFFFFFBF5),
      leading: Icon(
        icon,
        color: const Color(0xFF5D4037),
      ),
      title: Text(title),
      subtitle: Text(
        value.isNotEmpty ? value : "Not set",
        style: const TextStyle(
          color: Colors.black54,
        ),
      ),
    );
  }
}