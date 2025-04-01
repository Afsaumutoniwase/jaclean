import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../blocs/reviews/write_review_bloc.dart';

class WriteReviewPage extends StatefulWidget {
  final String? reviewId;
  final String? existingText;
  final double? existingRating;
  final String? existingImage;

  const WriteReviewPage({
    Key? key,
    this.reviewId,
    this.existingText,
    this.existingRating,
    this.existingImage,
  }) : super(key: key);

  @override
  State<WriteReviewPage> createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 0.0;
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    _reviewController.text = widget.existingText ?? '';
    _rating = widget.existingRating ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WriteReviewBloc(),
      child: BlocConsumer<WriteReviewBloc, WriteReviewState>(
        listener: (context, state) {
          if (state is WriteReviewSuccess) {
            Navigator.pop(context);
          } else if (state is WriteReviewError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: ${state.error}")),
            );
          } else if (state is ImagePicked) {
            setState(() {
              _pickedImage = state.image;
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text('Write Review', style: TextStyle(color: Colors.black)),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Score:', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < _rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 32,
                          ),
                          onPressed: () {
                            setState(() => _rating = index + 1.0);
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _reviewController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Review',
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        context.read<WriteReviewBloc>().add(PickImageEvent());
                      },
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _pickedImage != null
                            ? Image.file(_pickedImage!, fit: BoxFit.cover)
                            : widget.existingImage != null &&
                                    widget.existingImage!.startsWith('http')
                                ? Image.network(widget.existingImage!,
                                    fit: BoxFit.cover)
                                : const Center(
                                    child: Icon(Icons.add, size: 50, color: Colors.grey),
                                  ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: state is WriteReviewLoading
                            ? null
                            : () {
                                context.read<WriteReviewBloc>().add(
                                      SubmitReviewEvent(
                                        reviewId: widget.reviewId,
                                        reviewText: _reviewController.text.trim(),
                                        rating: _rating,
                                        image: _pickedImage,
                                        existingImage: widget.existingImage,
                                      ),
                                    );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 24,
                          ),
                        ),
                        child: state is WriteReviewLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                widget.reviewId != null
                                    ? 'Update Review'
                                    : 'Post Review',
                                style: const TextStyle(fontSize: 16, color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
