import 'package:cargoproai/app/routes/app_pages.dart';
import 'package:cargoproai/app/ui/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/object_controller.dart';
import '../../theme/app_theme.dart';
import '../../utils/validators.dart';
import '../widgets/common.dart';

class EditPage extends StatelessWidget {
  const EditPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ObjectController>();
    final args = Get.arguments as Map<String, dynamic>?;

    final id = args?['id'] as String?;
    final nameCtrl =
        TextEditingController(text: (args?['name'] as String?) ?? '');
    final dataCtrl = TextEditingController(
      text: (args?['data'] as String?) ?? '{\n  "key": "value"\n}',
    );
    final formKey = GlobalKey<FormState>();

    return GradientScaffold(
      appBar: AppBar(
        title: Text(id == null ? 'Create Object' : 'Edit Object'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;
            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
                  child: Card(
                    color: Colors.black.withValues(alpha: 0.25),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AppTextField(
                              label: 'Name',
                              controller: nameCtrl,
                              validator: (v) =>
                                  Validators.notEmpty(v, field: 'Name'),
                              keyboardType: TextInputType.text,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: dataCtrl,
                              validator: Validators.dataFlexible,
                              minLines: 8,
                              maxLines: null,
                              textInputAction: TextInputAction.newline,
                              style: const TextStyle(fontFamily: 'monospace'),
                              decoration: InputDecoration(
                                labelText: 'Data (JSON only)',
                                helperText:
                                    'Tip: paste full JSON object only valid for now).',
                                filled: true,
                                fillColor: Colors.white.withValues(alpha: 0.05),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                            const SizedBox(height: 16),
                            GradientButton(
                              text: id == null ? 'Create' : 'Save',
                              icon: id == null ? Icons.add : Icons.save,
                              colors: const [
                                Color(0xFF1E1E2C),
                                Color(0xFF3A2C4E)
                              ],
                              onPressed: () async {
                                if (!formKey.currentState!.validate()) return;

                                if (id == null) {
                                  final created = await ctrl.create(
                                      nameCtrl.text.trim(), dataCtrl.text);
                                  if (created != null) {
                                    Get.offAllNamed(Routes.home);
                                  }
                                } else {
                                  final updated = await ctrl.updateObject(
                                      id, nameCtrl.text.trim(), dataCtrl.text);
                                  if (updated != null) {
                                    Get.offAllNamed(Routes.home);
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
