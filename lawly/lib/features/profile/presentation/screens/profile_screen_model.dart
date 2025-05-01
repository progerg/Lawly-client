import 'package:elementary/elementary.dart';
import 'package:lawly/api/data_sources/local/token_local_data_source.dart';
import 'package:lawly/features/app/bloc/auth_bloc/auth_bloc.dart';
import 'package:lawly/features/auth/service/auth_service.dart';

class ProfileScreenModel extends ElementaryModel {
  final AuthBloc authBloc;
  final TokenLocalDataSource tokenLocalDataSource;
  final AuthService _authService;

  ProfileScreenModel({
    required this.authBloc,
    required this.tokenLocalDataSource,
    required AuthService authService,
  }) : _authService = authService;

  Future<void> logout({required String deviceId}) async {
    await _authService.logout(deviceId: deviceId);
  }
}
