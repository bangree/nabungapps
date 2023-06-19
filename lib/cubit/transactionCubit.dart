import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabung/cubit/baseState.dart';
import 'package:nabung/model/transactionModel.dart';
import 'package:nabung/repository/transactionRepository.dart';
import 'package:uuid/uuid.dart';

class TransactionCubit extends Cubit<BaseState<List<TransactionModel>>> {
  final TransactionRepository transactionRepository;

  TransactionCubit({
    required this.transactionRepository,
  }) : super(const InitializedState());

  late StreamSubscription<List<TransactionModel>> streamSubscription;

  void init({required String userId}) async {
    if (state is InitializedState) {
      emit(const LoadingState());
    }
    streamSubscription = transactionRepository.watch(userId: userId).listen(
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
    required String amount,
    required String categoryName,
    required String categoryIcon,
    required String categoryType,
    required String date,
    required String walletId,
  }) async {
    TransactionModel transaction = TransactionModel(
      id: id ?? const Uuid().v1(),
      name: name,
      amount: int.tryParse(amount.replaceAll('.', '')) ?? 0,
      categoryName: categoryName,
      categoryIcon: categoryIcon,
      type: categoryType,
      date: date,
      walletId: walletId,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    await transactionRepository.createOrUpdate(
      userId: userId,
      transactionModel: transaction,
    );
  }

  void delete({
    required String userId,
    required String transactionId,
  }) async {
    await transactionRepository.delete(
      userId: userId,
      transactionId: transactionId,
    );
  }

  @override
  Future<void> close() {
    streamSubscription.cancel();
    return super.close();
  }
}
