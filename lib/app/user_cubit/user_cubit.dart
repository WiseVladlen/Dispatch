import 'dart:async';

import 'package:dispatch/app/user_cubit/user_state.dart';
import 'package:dispatch/domain/model/user_model.dart';
import 'package:dispatch/domain/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<UserState> {
  late final StreamSubscription<UserModel> _userStreamSubscription;

  UserCubit({
    required UserModel user,
    required IUserRepository userRepository,
  }) : super(UserState(user: user)) {
    _userStreamSubscription = userRepository.getUserStream(email: user.email).listen((user) {
      emit(state.copyWith(user: user));
    });
  }

  @override
  Future<void> close() {
    _userStreamSubscription.cancel();
    return super.close();
  }
}
