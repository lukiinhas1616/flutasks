abstract class LocalStorageService {
  Future<void> init();
  Future<void> save(String key, String value);
  Future<String?> get(String key);
  Future<void> delete(String key);
  Future<void> deleteAll();
}
