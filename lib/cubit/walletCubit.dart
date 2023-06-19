import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabung/cubit/baseState.dart';
import 'package:nabung/model/walletModel.dart';
import 'package:nabung/repository/walletRepository.dart';
import 'package:uuid/uuid.dart';

class WalletCubit extends Cubit<BaseState<List<WalletModel>>> {
  final WalletRepository walletRepository;

  WalletCubit({
    required this.walletRepository,
  }) : super(const InitializedState());

  late StreamSubscription<List<WalletModel>> streamSubscription;

  void init({required String userId}) async {
    if (state is InitializedState) {
      emit(const LoadingState());
    }
    streamSubscription = walletRepository.watch(userId: userId).listen(
          (data) => emit(LoadedState(data: data)),
        );
  }

  void reInit() {
    emit(const InitializedState());
  }

  void createOrUpdate({
    required String userId,
    String? id,
    required String name,
    required String balance,
    required String budgetPlan,
    required String goal,
    required String color,
  }) async {
    WalletModel wallet = WalletModel(
      id: id ?? const Uuid().v1(),
      name: name,
      balance: int.tryParse(balance.replaceAll('.', '')) ?? 0,
      budgetPlan: int.tryParse(budgetPlan.replaceAll('.', '')) ?? 0,
      goal: int.tryParse(goal.replaceAll('.', '')) ?? 0,
      color: color,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    await walletRepository.createOrUpdate(
      userId: userId,
      walletModel: wallet,
    );
  }

  void addTransaction({
    required String userId,
    required String walletId,
    required int amount,
  }) async {
    final List<WalletModel> wallets = state.data ?? [];

    // get wallet
    WalletModel? wallet = wallets.firstWhereOrNull(
      (element) => element.id == walletId,
    );

    if (wallet != null) {
      await walletRepository.createOrUpdate(
        userId: userId,
        walletModel: wallet.copyWith(
          balance: (wallet.balance ?? 0) + amount,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    }
  }

  void delete({
    required String userId,
    required String walletId,
  }) async {
    await walletRepository.delete(
      userId: userId,
      walletId: walletId,
    );
  }

  @override
  Future<void> close() {
    streamSubscription.cancel();
    return super.close();
  }
}
