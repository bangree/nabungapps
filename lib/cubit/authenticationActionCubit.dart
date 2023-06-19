import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabung/cubit/baseState.dart';
import 'package:nabung/model/userModel.dart';
import 'package:nabung/repository/authenticationRepository.dart';

class AuthenticationActionCubit extends Cubit<BaseState<UserModel>> {
  final AuthenticationRepository authenticationRepository;

  AuthenticationActionCubit({
    required this.authenticationRepository,
  }) : super(const InitializedState());

  void login({
    required String email,
    required String password,
  }) async {
    emit(const LoadingState());

    // check user login
    Either<UserModel, String> result = await authenticationRepository.login(
      email: email,
      password: password,
    );

    BaseState<UserModel> resultState = result.fold(
      (l) => SuccessState(data: l),
      (r) => ErrorState(message: r),
    );

    emit(resultState);
  }

  void register({
    required String username,
    required String email,
    required String password,
  }) async {
    emit(const LoadingState());

    // check user login
    Either<String, String> result = await authenticationRepository.register(
      email: email,
      password: password,
      username: username,
    );

    BaseState<UserModel> resultState = result.fold(
      (l) => SuccessState(message: l),
      (r) => ErrorState(message: r),
    );

    emit(resultState);
  }

  void logout() async {
    emit(const LoadingState());

    await authenticationRepository.logout();

    emit(const SuccessState(message: 'Logout Success'));
  }

  void changePassword({
    required String email,
    required String oldPassword,
    required String newPassword,
  }) async {
    emit(const LoadingState());

    // check user login
    Either<String, String> result =
        await authenticationRepository.changePassword(
      email: email,
      oldPassword: oldPassword,
      newPassword: newPassword,
    );

    BaseState<UserModel> resultState = result.fold(
      (l) => SuccessState(message: l),
      (r) => ErrorState(message: r),
    );

    emit(resultState);
  }

  void deleteAccount({
    required String email,
    required String password,
  }) async {
    emit(const LoadingState());

    // check user login
    Either<String, String> result =
        await authenticationRepository.deleteAccount(
      email: email,
      password: password,
    );

    BaseState<UserModel> resultState = result.fold(
      (l) => SuccessState(message: l),
      (r) => ErrorState(message: r),
    );

    emit(resultState);
  }
}
