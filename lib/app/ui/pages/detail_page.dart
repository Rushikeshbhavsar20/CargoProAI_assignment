import 'dart:convert';
import 'package:cargoproai/app/ui/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/object_controller.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_pages.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ObjectController>();
    final objId = (Get.arguments as String?) ?? '';

    return GradientScaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () async {
              final obj = await ctrl.refreshDetail(objId);
              if (obj == null) return;
              Get.toNamed(Routes.edit, arguments: {
                'id': obj.id,
                'name': obj.name,
                'data':
                    const JsonEncoder.withIndent('  ').convert(obj.data ?? {}),
              });
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (c) => AlertDialog(
                  title: const Text('Delete?'),
                  content: const Text(
                      'Are you sure you want to delete this object?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(c, false),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    GradientButton(
                      text: 'Delete',
                      icon: Icons.delete_outline,
                      colors: const [Color(0xFFB00020), Color(0xFFE53935)],
                      onPressed: () => Navigator.pop(c, true),
                    ),
                  ],
                ),
              );
              if (ok == true) {
                await ctrl.remove(objId);
                Get.offAllNamed(Routes.home);
              }
            },
            icon: const Icon(Icons.delete),
          )
        ],
      ),
      body: FutureBuilder(
        future: ctrl.refreshDetail(objId),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snap.hasData) return const Center(child: Text('Not found'));
          final obj = snap.data!;
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Card(
                color: Colors.black.withOpacity(0.25),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: SelectableText(
                      const JsonEncoder.withIndent('  ').convert(
                          {'id': obj.id, 'name': obj.name, 'data': obj.data}),
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
