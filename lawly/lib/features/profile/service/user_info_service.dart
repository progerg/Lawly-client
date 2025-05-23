import 'package:lawly/features/profile/domain/entities/user_info_entity.dart';
import 'package:lawly/features/profile/repository/user_info_repository.dart';

class UserInfoService {
  final IUserInfoRepository _userInfoRepository;

  UserInfoService({required IUserInfoRepository userInfoRepository})
      : _userInfoRepository = userInfoRepository;

  Future<UserInfoEntity> getUserInfo() async {
    return await _userInfoRepository.getUserInfo();
  }

  Future<void> updateFcmToken({
    required String fcmToken,
    required String deviceId,
  }) async {
    return await _userInfoRepository.updateFcmToken(
      fcmToken: fcmToken,
      deviceId: deviceId,
    );
  }
}
