import 'package:elementary/elementary.dart';
import 'package:lawly/api/data_sources/local/save_user_local_data_source.dart';
import 'package:lawly/api/data_sources/local/token_local_data_source.dart';
import 'package:lawly/features/app/bloc/auth_bloc/auth_bloc.dart';
import 'package:lawly/features/app/bloc/sub_bloc/sub_bloc.dart';
import 'package:lawly/features/auth/service/auth_service.dart';

class SettingsScreenModel extends ElementaryModel {
  final AuthBloc authBloc;
  final SubBloc subBloc;
  final TokenLocalDataSource tokenLocalDataSource;
  final SaveUserLocalDataSource saveUserLocalDataSource;
  final AuthService _authService;

  SettingsScreenModel({
    required this.authBloc,
    required this.subBloc,
    required this.tokenLocalDataSource,
    required this.saveUserLocalDataSource,
    required AuthService authService,
  }) : _authService = authService;

  Future<void> logout({required String deviceId}) async {
    await _authService.logout(deviceId: deviceId);
  }
}
