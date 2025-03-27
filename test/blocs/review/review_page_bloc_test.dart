import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:jaclean/blocs/reviews/review_page_bloc.dart';

void main() {
  group('ReviewPageBloc', () {
    late ReviewPageBloc reviewPageBloc;

    setUp(() {
      reviewPageBloc = ReviewPageBloc();
    });

    tearDown(() {
      reviewPageBloc.close();
    });

    test('initial state is ReviewPageLoading', () {
      expect(reviewPageBloc.state, isA<ReviewPageLoading>());
    });
  });
}