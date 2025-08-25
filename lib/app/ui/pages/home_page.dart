import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/object_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/app_pages.dart';
import '../../theme/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  bool _isReadOnlyId(String id) => RegExp(r'^\d+$').hasMatch(id);

  String _summary(Map<String, dynamic>? data) {
    if (data == null || data.isEmpty) return '-';
    // show up to 3 key:value pairs
    return data.entries.take(3).map((e) => '${e.key}: ${e.value}').join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ObjectController>();
    final auth = Get.find<AuthController>();

    return GradientScaffold(
      appBar: AppBar(
        elevation: 6,
        centerTitle: true,
        title: const Text(
          '📦 CargoProAI',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1E1E2C),
                Color(0xFF2A2A3C),
                Color(0xFF3A2C4E),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border(
              bottom: BorderSide(
                color: Color(0xFF5A4A7A),
                width: 4,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            onPressed: auth.logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Obx(() {
          if (ctrl.error.value != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 42),
                  const SizedBox(height: 8),
                  Text(
                    ctrl.error.value!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: ctrl.loadInitial,
                    child: const Text('Retry'),
                  )
                ],
              ),
            );
          }

          if (ctrl.objects.isEmpty && ctrl.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (ctrl.objects.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('No objects yet'),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: ctrl.loadInitial,
                    child: const Text('Reload'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: ctrl.loadInitial,
            child: NotificationListener<ScrollNotification>(
              onNotification: (n) {
                if (n.metrics.pixels >= n.metrics.maxScrollExtent - 200) {
                  ctrl.loadMore();
                }
                return false;
              },
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: ctrl.objects.length + (ctrl.hasMore ? 1 : 0),
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  if (i >= ctrl.objects.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final obj = ctrl.objects[i];
                  final readOnly = _isReadOnlyId(obj.id);

                  return Card(
                    color: Colors.white.withOpacity(0.06),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      title: Text(
                        obj.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          'ID: ${obj.id}\n${_summary(obj.data)}',
                          style: const TextStyle(height: 1.2),
                        ),
                      ),
                      trailing: readOnly
                          ? const Tooltip(
                              message: 'Read-only sample item',
                              child: Icon(Icons.lock, size: 18),
                            )
                          : const Icon(Icons.chevron_right),
                      onTap: () =>
                          Get.toNamed(Routes.detail, arguments: obj.id),
                    ),
                  );
                },
              ),
            ),
          );
        }),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1E1E2C), Color(0xFF3A2C4E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => Get.toNamed(Routes.edit),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Create',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
