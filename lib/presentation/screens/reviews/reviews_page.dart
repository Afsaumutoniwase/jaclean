import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'write_review_page.dart';
import 'reviews_item.dart';
import '../../../blocs/reviews/review_page_bloc.dart'; // Adjust path if needed
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({Key? key}) : super(key: key);

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  String _selectedFilter = 'Newest';

  @override
  void initState() {
    super.initState();
    context.read<ReviewPageBloc>().add(LoadReviewsEvent());
  }

  String timeSince(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min(s) ago';
    if (diff.inHours < 24) return '${diff.inHours} hour(s) ago';
    return '${diff.inDays} day(s) ago';
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            const Text(
              "Sort Reviews By",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Newest'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedFilter = 'Newest');
                context.read<ReviewPageBloc>().add(FilterReviewsEvent('Newest'));
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Oldest'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedFilter = 'Oldest');
                context.read<ReviewPageBloc>().add(FilterReviewsEvent('Oldest'));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Reviewer Name'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedFilter = 'Reviewer Name');
                context.read<ReviewPageBloc>().add(FilterReviewsEvent('Reviewer Name'));
              },
            ),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewPageBloc, ReviewPageState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text('Reviews', style: TextStyle(color: Colors.black)),
            centerTitle: true,
          ),
          body: state is ReviewPageLoading
              ? const Center(child: CircularProgressIndicator())
              : state is ReviewPageLoaded
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Hello,", style: TextStyle(fontSize: 16, color: Colors.black)),
                          FutureBuilder<String?>(
                            future: _getUserName(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                );
                              }
                              return Text(
                                snapshot.data ?? "User",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Reviews',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),

                          // Rating Summary Section (UI only)
                          _ratingSummary(),

                          const SizedBox(height: 16),

                          GestureDetector(
                            onTap: _showFilterOptions,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Filter',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Reviews List
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.reviews.length,
                            itemBuilder: (context, index) {
                              final review = state.reviews[index];
                              return ReviewItem(
                                reviewerName: review.reviewerName,
                                reviewText: review.reviewText,
                                reviewTime: timeSince(review.timestamp),
                                rating: review.rating,
                                showImages: true,
                                imageUrl: review.imageUrl,
                                canEdit: review.canEdit,
                                onEdit: review.canEdit
                                    ? () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => WriteReviewPage(
                                              reviewId: review.id,
                                              existingText: review.reviewText,
                                              existingRating: review.rating,
                                              existingImage: review.imageUrl,
                                            ),
                                          ),
                                        ).then((_) {
                                          context.read<ReviewPageBloc>().add(LoadReviewsEvent());
                                        });
                                      }
                                    : null,
                                onDelete: review.canEdit
                                    ? () => _confirmDelete(review.id)
                                    : null,
                              );
                            },
                          ),

                          const SizedBox(height: 16),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                              ),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const WriteReviewPage()),
                                );
                                context.read<ReviewPageBloc>().add(LoadReviewsEvent());
                              },
                              child: const Text('Write Review', style: TextStyle(fontSize: 16, color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Center(child: Text('Something went wrong')),
        );
      },
    );
  }

  Future<void> _confirmDelete(String reviewId) async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Review'),
        content: const Text('Are you sure you want to delete this review?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await FirebaseFirestore.instance.collection('reviews').doc(reviewId).delete();
      context.read<ReviewPageBloc>().add(LoadReviewsEvent());
    }
  }

  Widget _ratingSummary() {
    return Container(
      padding: const EdgeInsets.all(16.0),
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
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('4.8', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
              Row(
                children: List.generate(5, (index) {
                  return const Icon(Icons.star, color: Colors.amber, size: 20);
                }),
              ),
              const Text('450 Reviews', style: TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: [
                _buildRatingBar(5, 0.8),
                _buildRatingBar(4, 0.6),
                _buildRatingBar(3, 0.4),
                _buildRatingBar(2, 0.2),
                _buildRatingBar(1, 0.1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int stars, double percent) {
    return Row(
      children: [
        Text('$stars', style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 4),
        const Icon(Icons.star, size: 16, color: Colors.amber),
        const SizedBox(width: 4),
        Expanded(
          child: LinearProgressIndicator(
            value: percent,
            backgroundColor: Colors.grey[300],
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Future<String?> _getUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      return doc.data()?['userName'] as String?;
    }
    return null;
  }
}
