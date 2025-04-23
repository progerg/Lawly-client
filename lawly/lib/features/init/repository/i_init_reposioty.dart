abstract class IInitRepository {
  bool get isFirstLaunch;

  Future<void> setFirstLaunch(bool value);
}
