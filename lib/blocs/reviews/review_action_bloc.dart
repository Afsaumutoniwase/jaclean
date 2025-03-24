import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

// ================= EVENTS =================

abstract class ReviewActionEvent extends Equatable {
  const ReviewActionEvent();

  @override
  List<Object?> get props => [];
}

class DeleteReviewEvent extends ReviewActionEvent {
  final String reviewId;

  const DeleteReviewEvent(this.reviewId);

  @override
  List<Object?> get props => [reviewId];
}

// ================= STATES =================

abstract class ReviewActionState extends Equatable {
  const ReviewActionState();

  @override
  List<Object?> get props => [];
}

class ReviewActionInitial extends ReviewActionState {}

class ReviewActionLoading extends ReviewActionState {}

class ReviewActionSuccess extends ReviewActionState {
  final String message;

  const ReviewActionSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class ReviewActionError extends ReviewActionState {
  final String error;

  const ReviewActionError({required this.error});

  @override
  List<Object?> get props => [error];
}

// ================= BLOC =================

class ReviewActionBloc extends Bloc<ReviewActionEvent, ReviewActionState> {
  ReviewActionBloc() : super(ReviewActionInitial()) {
    on<DeleteReviewEvent>(_onDeleteReview);
  }

  Future<void> _onDeleteReview(
    DeleteReviewEvent event,
    Emitter<ReviewActionState> emit,
  ) async {
    emit(ReviewActionLoading());

    try {
      await FirebaseFirestore.instance
          .collection('reviews')
          .doc(event.reviewId)
          .delete();

      emit(const ReviewActionSuccess(message: "Review deleted successfully"));
    } catch (e) {
      emit(ReviewActionError(error: e.toString()));
    }
  }
}
