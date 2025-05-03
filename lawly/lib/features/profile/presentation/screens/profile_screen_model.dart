import 'package:elementary/elementary.dart';
import 'package:lawly/api/data_sources/local/token_local_data_source.dart';
import 'package:lawly/features/app/bloc/auth_bloc/auth_bloc.dart';
import 'package:lawly/features/auth/service/auth_service.dart';
import 'package:lawly/features/auth/service/save_user_service.dart';
import 'package:lawly/features/profile/domain/entities/user_info_entity.dart';
import 'package:lawly/features/profile/service/user_info_service.dart';

class ProfileScreenModel extends ElementaryModel {
  final AuthBloc authBloc;
  final TokenLocalDataSource tokenLocalDataSource;
  final AuthService _authService;
  final UserInfoService _userInfoService;
  final SaveUserService saveUserService;

  ProfileScreenModel({
    required this.authBloc,
    required this.tokenLocalDataSource,
    required this.saveUserService,
    required AuthService authService,
    required UserInfoService userInfoService,
  })  : _authService = authService,
        _userInfoService = userInfoService;

  Future<void> logout({required String deviceId}) async {
    await _authService.logout(deviceId: deviceId);
  }

  Future<UserInfoEntity> getUserInfo() async {
    return await _userInfoService.getUserInfo();
  }
}
