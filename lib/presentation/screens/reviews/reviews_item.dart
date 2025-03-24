import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/reviews/review_action_bloc.dart'; // Adjust path if needed

class ReviewItem extends StatelessWidget {
  final String reviewerName;
  final String reviewText;
  final String reviewTime;
  final double rating;
  final bool showImages;
  final String imageUrl;

  final bool canEdit;
  final String? reviewId;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ReviewItem({
    super.key,
    required this.reviewerName,
    required this.reviewText,
    required this.reviewTime,
    required this.rating,
    this.showImages = false,
    this.imageUrl = 'assets/images/table.jpeg',
    this.canEdit = false,
    this.onEdit,
    this.reviewId,
    this.onDelete,
  });

  void _confirmDelete(BuildContext context) {
    if (reviewId == null) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Review"),
        content: const Text("Are you sure you want to delete this review?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Delete"),
            onPressed: () {
              context.read<ReviewActionBloc>().add(DeleteReviewEvent(reviewId!));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/vase.jpeg'),
                      radius: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      reviewerName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Text(
                  reviewTime,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Review text
            Text(
              reviewText,
              style: const TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 8),

            // Rating
            Row(
              children: [
                ...List.generate(5, (index) {
                  return Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 20,
                  );
                }),
                const SizedBox(width: 8),
                Text(
                  rating.toString(),
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),

            if (showImages) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(imageUrl, fit: BoxFit.cover),
              ),
            ],

            if (canEdit) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.green, size: 20),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                    onPressed: onDelete,
                    // onPressed: () => _confirmDelete(context),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
