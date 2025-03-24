import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ======================= MODEL =======================

class ReviewModel {
  final String id;
  final String reviewerName;
  final String reviewText;
  final double rating;
  final DateTime timestamp;
  final String imageUrl;
  final String userId;
  final bool canEdit;

  ReviewModel({
    required this.id,
    required this.reviewerName,
    required this.reviewText,
    required this.rating,
    required this.timestamp,
    required this.imageUrl,
    required this.userId,
    required this.canEdit,
  });
}

// ======================= EVENTS =======================

abstract class ReviewPageEvent extends Equatable {
  const ReviewPageEvent();

  @override
  List<Object> get props => [];
}

class LoadReviewsEvent extends ReviewPageEvent {}

class FilterReviewsEvent extends ReviewPageEvent {
  final String filterType;

  const FilterReviewsEvent(this.filterType);

  @override
  List<Object> get props => [filterType];
}

// ======================= STATES =======================

abstract class ReviewPageState extends Equatable {
  const ReviewPageState();

  @override
  List<Object> get props => [];
}

class ReviewPageLoading extends ReviewPageState {}

class ReviewPageLoaded extends ReviewPageState {
  final List<ReviewModel> reviews;

  const ReviewPageLoaded(this.reviews);

  @override
  List<Object> get props => [reviews];
}

class ReviewPageError extends ReviewPageState {
  final String message;

  const ReviewPageError(this.message);

  @override
  List<Object> get props => [message];
}

// ======================= BLOC =======================

class ReviewPageBloc extends Bloc<ReviewPageEvent, ReviewPageState> {
  final List<String> defaultImages = [
    'assets/images/table.jpeg',
    'assets/images/fridge.jpeg',
    'assets/images/clothes4.jpeg',
    'assets/images/vase1.jpeg',
  ];

  List<ReviewModel> _allReviews = [];

  ReviewPageBloc() : super(ReviewPageLoading()) {
    on<LoadReviewsEvent>(_onLoadReviews);
    on<FilterReviewsEvent>(_onFilterReviews);
  }

  Future<void> _onLoadReviews(
    LoadReviewsEvent event,
    Emitter<ReviewPageState> emit,
  ) async {
    emit(ReviewPageLoading());

    try {
      final user = FirebaseAuth.instance.currentUser;
      final currentUserId = user?.uid;

      final snapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .orderBy('timestamp', descending: true)
          .get();

      _allReviews = snapshot.docs.map((doc) {
        final data = doc.data();
        final timestamp = data['timestamp'] as Timestamp?;
        final imageUrl = data['imageUrl']?.toString().startsWith('http') == true
            ? data['imageUrl']
            : defaultImages[Random().nextInt(defaultImages.length)];
        final reviewUserId = data['userId'];

        return ReviewModel(
          id: doc.id,
          reviewerName: data['reviewerName'] ?? 'Anonymous',
          reviewText: data['reviewText'] ?? '',
          rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
          timestamp: timestamp?.toDate() ?? DateTime.now(),
          imageUrl: imageUrl,
          userId: reviewUserId ?? '',
          canEdit: reviewUserId == currentUserId,
        );
      }).toList();

      emit(ReviewPageLoaded(_allReviews));
    } catch (e) {
      emit(ReviewPageError("Failed to load reviews"));
    }
  }

  void _onFilterReviews(
    FilterReviewsEvent event,
    Emitter<ReviewPageState> emit,
  ) {
    List<ReviewModel> sorted = List.from(_allReviews);

    if (event.filterType == 'Newest') {
      sorted.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } else if (event.filterType == 'Oldest') {
      sorted.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    } else if (event.filterType == 'Reviewer Name') {
      sorted.sort((a, b) => a.reviewerName.toLowerCase().compareTo(b.reviewerName.toLowerCase()));
    }

    emit(ReviewPageLoaded(sorted));
  }
}
