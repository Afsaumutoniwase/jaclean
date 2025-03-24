import 'package:bloc/bloc.dart';

class TabCubit extends Cubit<int> {
  TabCubit() : super(0);

  void updateTab(int index) => emit(index);
}