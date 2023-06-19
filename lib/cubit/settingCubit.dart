import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabung/model/settingModel.dart';

class SettingCubit extends Cubit<SettingModel> {
  SettingCubit() : super(const SettingModel());

  void changeOverBudget() {
    emit(
      state.copyWith(
        isOverBudget: !state.isOverBudget,
      ),
    );
  }

  void changeAutoPlay() {
    emit(
      state.copyWith(
        isAutoPlay: !state.isAutoPlay,
      ),
    );
  }
}
