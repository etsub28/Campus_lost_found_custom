import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unilink/models/user.dart';
import 'package:unilink/providers/user_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final User? initialUser;

  const EditProfileScreen({super.key, this.initialUser});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _sicController;
  late final TextEditingController _yearController;
  late final TextEditingController _semesterController;
  late final TextEditingController _collegeController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.initialUser?.name ?? '');
    _sicController =
        TextEditingController(text: widget.initialUser?.sic ?? '');
    _yearController =
        TextEditingController(text: widget.initialUser?.year ?? '');
    _semesterController =
        TextEditingController(text: widget.initialUser?.semester ?? '');
    _collegeController =
        TextEditingController(text: widget.initialUser?.college ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sicController.dispose();
    _yearController.dispose();
    _semesterController.dispose();
    _collegeController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = User(
        name: _nameController.text.trim(),
        sic: _sicController.text.trim(),
        year: _yearController.text.trim(),
        semester: _semesterController.text.trim(),
        college: _collegeController.text.trim(),
      );

      await ref.read(userServiceProvider).updateProfile(user);

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF5D4037),
        title: const Text(
          'Edit Profile ',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.save, color: Colors.white),
              onPressed: _saveProfile,
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

        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),

            children: [

              const SizedBox(height: 20),

              _buildField(
                controller: _nameController,
                label: "Name",
                icon: Icons.person,
              ),

              const SizedBox(height: 16),

              _buildField(
                controller: _sicController,
                label: "SIC",
                icon: Icons.badge,
              ),

              const SizedBox(height: 16),

              _buildField(
                controller: _yearController,
                label: "Year",
                icon: Icons.calendar_today,
              ),

              const SizedBox(height: 16),

              _buildField(
                controller: _semesterController,
                label: "Semester",
                icon: Icons.school,
              ),

              const SizedBox(height: 16),

              _buildField(
                controller: _collegeController,
                label: "College",
                icon: Icons.location_city,
              ),

              const SizedBox(height: 30),

              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5D4037),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isLoading ? null : _saveProfile,
                  child: const Text(
                    "SAVE PROFILE",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF5D4037)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF5D4037), width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter $label";
        }
        return null;
      },
    );
  }
}