import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/services/local_storage_service.dart';

class LocalStorageServiceImp extends LocalStorageService {
  late final HiveInterface _hive;

  @override
  Future<void> init() async {
    debugPrint('__Local storage service initialized__');
    _hive = Hive;
    _hive.init(await _getPath());
  }

  @override
  Future<String?> get(String key) async {
    final box = await _hive.openBox('tasks_db');
    return box.get(key);
  }

  @override
  Future<void> save(String key, String value) {
    return _hive.box('tasks_db').put(key, value);
  }

  @override
  Future<void> delete(String key) {
    return _hive.box('tasks_db').delete(key);
  }

  Future<String> _getPath() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    return appDocumentDir.path;
  }

  @override
  Future<void> deleteAll() {
    return _hive.deleteFromDisk();
  }
}
