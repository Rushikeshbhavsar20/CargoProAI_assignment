import 'dart:convert';
import 'package:get/get.dart';
import '../data/models/object_model.dart';
import '../data/services/api_service.dart';

class ObjectController extends GetxController {
  final ApiService api;
  ObjectController(this.api);

  final objects = <ObjectModel>[].obs;
  final isLoading = false.obs;
  final error = RxnString();
  int _page = 1;
  final int _limit = 12;
  bool hasMore = true;

  @override
  void onReady() {
    super.onReady();
    loadInitial();
  }

  Future<void> loadInitial() async {
    objects.clear();
    _page = 1;
    hasMore = true;
    await loadMore();
  }

  Future<void> loadMore() async {
    if (!hasMore || isLoading.value) return;
    isLoading.value = true;
    error.value = null;
    try {
      final list = await api.fetchObjects(page: _page, limit: _limit);
      if (list.isEmpty || list.length < _limit) hasMore = false;
      objects.addAll(list);
      _page++;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<ObjectModel?> refreshDetail(String id) async {
    try {
      return await api.fetchDetail(id);
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return null;
    }
  }

  Future<ObjectModel?> create(String name, String jsonText) async {
    try {
      final data = json.decode(jsonText) as Map<String, dynamic>;
      final created = await api.createObject(name, data);
      objects.insert(0, created);
      Get.snackbar('Success', 'Created');
      return created;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return null;
    }
  }

  Future<ObjectModel?> updateObject(
      String id, String name, String jsonText) async {
    try {
      final data = json.decode(jsonText) as Map<String, dynamic>;
      final updated = await api.updateObject(id, name, data);
      final idx = objects.indexWhere((o) => o.id == id);
      if (idx != -1) objects[idx] = updated;
      Get.snackbar('Saved', 'Updated');
      return updated;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return null;
    }
  }

  Future<bool> remove(String id) async {
    final idx = objects.indexWhere((o) => o.id == id);
    ObjectModel? backup;
    if (idx != -1) {
      backup = objects[idx];
      objects.removeAt(idx);
    }
    try {
      await api.deleteObject(id);
      Get.snackbar('Deleted', 'Object removed');
      return true;
    } catch (e) {
      if (backup != null) objects.insert(idx, backup);
      Get.snackbar('Error', e.toString());
      return false;
    }
  }
}
