import 'package:elementary/elementary.dart';
import 'package:lawly/api/data_sources/local/token_local_data_source.dart';
import 'package:lawly/features/app/bloc/auth_bloc/auth_bloc.dart';
import 'package:lawly/features/auth/service/save_user_service.dart';

class TemplatesScreenModel extends ElementaryModel {
  final AuthBloc authBloc;
  final TokenLocalDataSource tokenLocalDataSource;
  final SaveUserService saveUserService;

  TemplatesScreenModel({
    required this.authBloc,
    required this.tokenLocalDataSource,
    required this.saveUserService,
  });
}
