import 'package:elementary/elementary.dart';
import 'package:lawly/api/data_sources/local/token_local_data_source.dart';
import 'package:lawly/features/app/bloc/auth_bloc/auth_bloc.dart';
import 'package:lawly/features/app/bloc/sub_bloc/sub_bloc.dart';
import 'package:lawly/features/auth/service/save_user_service.dart';
import 'package:lawly/features/profile/domain/entities/subscribe_entity.dart';
import 'package:lawly/features/profile/service/subscribe_service.dart';
import 'package:lawly/features/templates/service/template_service.dart';

class TemplatesScreenModel extends ElementaryModel {
  final AuthBloc authBloc;
  final SubBloc subBloc;
  final TokenLocalDataSource tokenLocalDataSource;
  final SaveUserService saveUserService;
  final TemplateService templateService;
  final SubscribeService _subscribeService;

  TemplatesScreenModel({
    required this.authBloc,
    required this.subBloc,
    required this.tokenLocalDataSource,
    required this.saveUserService,
    required this.templateService,
    required SubscribeService subscribeService,
  }) : _subscribeService = subscribeService;

  Future<SubscribeEntity> getSubscribe() async {
    return await _subscribeService.getSubscribe();
  }
}
