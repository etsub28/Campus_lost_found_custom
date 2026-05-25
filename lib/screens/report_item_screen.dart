import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unilink/models/lost_found_item.dart';
import 'package:unilink/providers/lost_found_provider.dart';
import 'package:unilink/providers/notification_provider.dart';

class ReportItemScreen extends ConsumerStatefulWidget {
  const ReportItemScreen({super.key});

  @override
 ConsumerState<ReportItemScreen> createState() => _ReportItemScreenState();
}

class _ReportItemScreenState extends ConsumerState<ReportItemScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  String _type = 'lost';
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final item = LostFoundItem(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        location: _locationController.text.trim(),
        type: _type,
        status: 'active',
      );

      final createdItem =
          await ref.read(lostFoundServiceProvider).createItem(item);

      if (!mounted) return;

      await NotificationService().createNotification(
        userId: ref.read(lostFoundServiceProvider).getCurrentUserId(),
        title: 'New ${_type.toUpperCase()} Item Reported',
        message: _titleController.text,
        type: _type,
        itemId: createdItem.id,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item reported successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  InputDecoration _inputDecoration(
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Color(0xFF5D4037),
      ),
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF5D4037),
      ),
      filled: true,
      fillColor: const Color(0xFFF8F5F2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFF5D4037),
          width: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF5D4037),
        title: Text(
          'Report ${_type.toUpperCase()} Item',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
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

        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'lost',
                      label: Text('Lost'),
                      icon: Icon(Icons.search),
                    ),
                    ButtonSegment(
                      value: 'found',
                      label: Text('Found'),
                      icon: Icon(Icons.find_in_page),
                    ),
                  ],
                  selected: {_type},
                  style: ButtonStyle(
                    foregroundColor: WidgetStatePropertyAll(
                      Color(0xFF5D4037),
                    ),
                  ),
                  onSelectionChanged: (Set<String> selection) {
                    setState(() => _type = selection.first);
                  },
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: _titleController,
                  style: const TextStyle(
                    color: Colors.black87,
                  ),
                  decoration: _inputDecoration(
                    'Title',
                    Icons.title,
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: _descriptionController,
                  maxLines: 4,
                  style: const TextStyle(
                    color: Colors.black87,
                  ),
                  decoration: _inputDecoration(
                    'Description',
                    Icons.description,
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: _locationController,
                  style: const TextStyle(
                    color: Colors.black87,
                  ),
                  decoration: _inputDecoration(
                    'Location',
                    Icons.location_on,
                  ),
                ),

                const SizedBox(height: 28),

                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5D4037),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}