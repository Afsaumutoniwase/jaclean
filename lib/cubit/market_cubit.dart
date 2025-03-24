import 'package:bloc/bloc.dart';

class MarketCubit extends Cubit<int> {
  MarketCubit() : super(0);

  void updateTab(int index) => emit(index);
}