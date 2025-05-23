import 'package:lawly/api/data_sources/remote/user_service/user_remote_data_source.dart';
import 'package:lawly/features/profile/domain/entities/user_info_entity.dart';

abstract class IUserInfoRepository {
  Future<UserInfoEntity> getUserInfo();

  Future<void> updateFcmToken({
    required String fcmToken,
    required String deviceId,
  });
}

class UserInfoRepository implements IUserInfoRepository {
  final UserRemoteDataSource _userRemoteDataSource;

  UserInfoRepository({required UserRemoteDataSource userRemoteDataSource})
      : _userRemoteDataSource = userRemoteDataSource;

  @override
  Future<UserInfoEntity> getUserInfo() async {
    return await _userRemoteDataSource.getUserInfo();
  }

  @override
  Future<void> updateFcmToken({
    required String fcmToken,
    required String deviceId,
  }) async {
    return await _userRemoteDataSource.updateFcmToken(
      fcmToken: fcmToken,
      deviceId: deviceId,
    );
  }
}
