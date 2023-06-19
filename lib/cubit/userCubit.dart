import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabung/cubit/baseState.dart';
import 'package:nabung/model/userModel.dart';
import 'package:nabung/repository/userRepository.dart';

class UserCubit extends Cubit<BaseState<UserModel>> {
  final UserRepository userRepository;

  UserCubit({
    required this.userRepository,
  }) : super(const InitializedState());

  late StreamSubscription<UserModel?> streamSubscription;

  void init({required UserModel user}) async {
    emit(LoadedState(data: user));

    streamSubscription = userRepository.watch(userId: user.id!).listen(
          (data) => data != null
              ? emit(LoadedState(data: data))
              : emit(const InitializedState()),
        );
  }

  void reInit() {
    emit(const InitializedState());
  }

  void update({required UserModel user}) {
    userRepository.update(user: user);
  }

  @override
  Future<void> close() {
    streamSubscription.cancel();
    return super.close();
  }
}
