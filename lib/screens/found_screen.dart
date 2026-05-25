import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:unilink/navigation/routes.dart';
import 'package:unilink/providers/lost_found_provider.dart';
import 'package:unilink/widgets/items_list.dart';

class FoundScreen extends ConsumerWidget {
  const FoundScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foundItems = ref.watch(foundItemsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF5D4037),
        title: const Text(
          'Found Items ',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
        child: ItemsList(
          items: foundItems,
          provider: foundItemsProvider,
          emptyMessage:
              'No found items reported yet.\nBe the first to report one!',
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF5D4037),
        foregroundColor: Colors.white,
        onPressed: () => context.push(Routes.report),
        child: const Icon(Icons.add),
      ),
    );
  }
}