import 'package:bloc/bloc.dart';

class AddCardCubit extends Cubit<bool> {
  AddCardCubit() : super(false);

  void setLoading(bool isLoading) => emit(isLoading);
}