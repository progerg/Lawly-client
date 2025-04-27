import 'package:elementary/elementary.dart';
import 'package:lawly/features/app/bloc/auth_bloc/auth_bloc.dart';

class ProfileScreenModel extends ElementaryModel {
  final AuthBloc authBloc;

  ProfileScreenModel({required this.authBloc});
}
