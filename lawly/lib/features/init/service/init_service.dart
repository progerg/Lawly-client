import 'package:lawly/features/init/repository/i_init_reposioty.dart';

class InitService {
  final IInitRepository _initRepository;

  InitService(this._initRepository);

  bool get isFirstLaunch => _initRepository.isFirstLaunch;

  Future<void> setFirstLaunch(bool value) async {
    await _initRepository.setFirstLaunch(value);
  }
}
