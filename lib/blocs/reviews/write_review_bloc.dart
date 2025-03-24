import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';


// --- STATE ---

abstract class WriteReviewState extends Equatable {
  const WriteReviewState();
  @override
  List<Object?> get props => [];
}

class WriteReviewInitial extends WriteReviewState {}

class WriteReviewLoading extends WriteReviewState {}

class WriteReviewSuccess extends WriteReviewState {}

class WriteReviewError extends WriteReviewState {
  final String error;
  const WriteReviewError(this.error);
  @override
  List<Object?> get props => [error];
}

class ImagePicked extends WriteReviewState {
  final File image;
  const ImagePicked(this.image);
  @override
  List<Object?> get props => [image];
}


// --- EVENT ---

abstract class WriteReviewEvent extends Equatable {
  const WriteReviewEvent();
  @override
  List<Object?> get props => [];
}

class SubmitReviewEvent extends WriteReviewEvent {
  final String? reviewId;
  final String reviewText;
  final double rating;
  final File? image;
  final String? existingImage;

  const SubmitReviewEvent({
    required this.reviewText,
    required this.rating,
    this.image,
    this.reviewId,
    this.existingImage,
  });

  @override
  List<Object?> get props => [reviewId, reviewText, rating, image, existingImage];
}

class PickImageEvent extends WriteReviewEvent {}


// --- BLOC ---

class WriteReviewBloc extends Bloc<WriteReviewEvent, WriteReviewState> {
  WriteReviewBloc() : super(WriteReviewInitial()) {
    on<SubmitReviewEvent>(_onSubmitReview);
    on<PickImageEvent>(_onPickImage);
  }

  Future<void> _onPickImage(
    PickImageEvent event,
    Emitter<WriteReviewState> emit,
  ) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      emit(ImagePicked(File(pickedFile.path)));
    }
  }

  Future<void> _onSubmitReview(
    SubmitReviewEvent event,
    Emitter<WriteReviewState> emit,
  ) async {
    emit(WriteReviewLoading());

    try {
      final user = FirebaseAuth.instance.currentUser;
      String userName = 'Anonymous';

      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        userName = doc.data()?['userName'] ?? 'Anonymous';
      }

      String imageUrl = event.existingImage ?? 'assets/images/table.jpeg';

      if (event.image != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('review_images')
            .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(event.image!);
        imageUrl = await ref.getDownloadURL();
      }

      final reviewData = {
        'reviewerName': userName,
        'reviewText': event.reviewText,
        'rating': event.rating,
        'timestamp': Timestamp.now(),
        'imageUrl': imageUrl,
        'userId': user?.uid,
      };

      if (event.reviewId != null) {
        await FirebaseFirestore.instance
            .collection('reviews')
            .doc(event.reviewId)
            .update(reviewData);
      } else {
        await FirebaseFirestore.instance
            .collection('reviews')
            .add(reviewData);
      }

      emit(WriteReviewSuccess());
    } catch (e) {
      emit(WriteReviewError(e.toString()));
    }
  }
}
