import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabung/cubit/baseState.dart';
import 'package:nabung/model/userModel.dart';
import 'package:nabung/repository/authenticationRepository.dart';

class AuthenticationDataCubit extends Cubit<BaseState<UserModel>> {
  final AuthenticationRepository authenticationRepository;

  AuthenticationDataCubit({
    required this.authenticationRepository,
  }) : super(const InitializedState());

  void init() async {
    emit(const LoadingState());

    // check user login
    Either<UserModel?, String> result =
        await authenticationRepository.hasLoggedIn();

    BaseState<UserModel> resultState = result.fold(
      (l) => l != null
          ? AuthenticatedState(data: l)
          : const UnAuthenticationState(),
      (r) => ErrorState(message: r),
    );

    // delay 2s
    await Future.delayed(const Duration(seconds: 2));

    emit(resultState);
  }

  void update({UserModel? userModel}) {
    if (userModel != null) {
      emit(AuthenticatedState(data: userModel));
    } else {
      emit(const UnAuthenticationState());
    }
  }
}
