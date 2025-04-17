import 'package:lawly/api/data_sources/local/init_local_data_source.dart';
import 'package:lawly/features/init/repository/i_init_reposioty.dart';

class InitRepository implements IInitRepository {
  final InitLocalDataSource _initLocalDataSource;

  InitRepository(this._initLocalDataSource);

  @override
  bool get isFirstLaunch => _initLocalDataSource.isFirstLaunch;

  @override
  Future<void> setFirstLaunch(bool value) async {
    await _initLocalDataSource.setFirstLaunch(value);
  }
}
