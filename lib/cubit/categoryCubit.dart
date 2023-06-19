import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabung/cubit/baseState.dart';
import 'package:nabung/model/categoryModel.dart';
import 'package:nabung/repository/categoryRepository.dart';

class CategoryCubit extends Cubit<BaseState<List<CategoryModel>>> {
  final CategoryRepository categoryRepository;

  CategoryCubit({
    required this.categoryRepository,
  }) : super(const InitializedState());

  late StreamSubscription<List<CategoryModel>> streamSubscription;

  void init({required String userId}) async {
    if (state is InitializedState) {
      emit(const LoadingState());
    }
    streamSubscription = categoryRepository.watch(userId: userId).listen(
          (data) => emit(LoadedState(
            data: [...CategoryModel.expense, ...CategoryModel.income, ...data],
          )),
        );
  }

  void reInit() {
    emit(const InitializedState());
  }

  void create({
    required String userId,
    required String icon,
    required String label,
    required String type,
  }) async {
    CategoryModel category = CategoryModel(
      icon: icon,
      label: label,
      type: type,
    );

    await categoryRepository.create(
      userId: userId,
      categoryModel: category,
    );
  }

  void delete({
    required String userId,
    required String label,
  }) async {
    await categoryRepository.delete(
      userId: userId,
      label: label,
    );
  }

  @override
  Future<void> close() {
    streamSubscription.cancel();
    return super.close();
  }
}
