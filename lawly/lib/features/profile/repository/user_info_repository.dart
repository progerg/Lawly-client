import 'package:lawly/api/data_sources/remote/user_remote_data_source.dart';
import 'package:lawly/features/profile/domain/entities/user_info_entity.dart';

abstract class IUserInfoRepository {
  Future<UserInfoEntity> getUserInfo();
}

class UserInfoRepository implements IUserInfoRepository {
  final UserRemoteDataSource _userRemoteDataSource;

  UserInfoRepository({required UserRemoteDataSource userRemoteDataSource})
      : _userRemoteDataSource = userRemoteDataSource;

  @override
  Future<UserInfoEntity> getUserInfo() async {
    return await _userRemoteDataSource.getUserInfo();
  }
}
