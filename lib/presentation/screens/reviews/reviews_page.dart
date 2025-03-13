import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'reviews_item.dart';
import 'write_review_page.dart';
import '../../../main.dart'; // Import the main.dart file to access the bottom navigation bar

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({Key? key}) : super(key: key);

  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  final List<ReviewItem> _reviews = [
    const ReviewItem(
      reviewerName: 'Stella Anne',
      reviewText:
          'I\'ve found so many stylish pieces at amazing prices! The app is easy to navigate, and the sellers are trustworthy. Definitely my go-to for secondhand shopping!',
      reviewTime: '2 mins ago',
      rating: 5.0,
    ),
    const ReviewItem(
      reviewerName: 'John Doe',
      reviewText:
          'Great app with a wide variety of products. The user interface is clean and easy to use. Highly recommend!',
      reviewTime: '10 mins ago',
      rating: 4.5,
      showImages: true,
    ),
    const ReviewItem(
      reviewerName: 'Jane Smith',
      reviewText:
          'I love the deals I find here! The customer service is also very responsive and helpful.',
      reviewTime: '30 mins ago',
      rating: 4.0,
      showImages: true,
    ),
  ];

  Future<String?> _getUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return doc.data()?['userName'] as String?;
    }
    return null;
  }

  void _addReview(String reviewerName, String reviewText, double rating, XFile? image) {
    setState(() {
      _reviews.add(
        ReviewItem(
          reviewerName: reviewerName,
          reviewText: reviewText,
          reviewTime: 'Just now',
          rating: rating,
          showImages: image != null,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Reviews',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hello,',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
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
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Container(
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
                        const Text(
                          '4.8',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          children: List.generate(5, (index) {
                            return const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 20,
                            );
                          }),
                        ),
                        const Text(
                          '450 Reviews',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
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
              ),
              const SizedBox(height: 16),
              Container(
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
              const SizedBox(height: 16),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: _reviews,
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WriteReviewPage(
                          onReviewSubmitted: _addReview,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Write Review',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: const MainBottomNavBar(), // Use the bottom navigation bar from main.dart
    );
  }

  Widget _buildRatingBar(int starCount, double percentage) {
    return Row(
      children: [
        Text(
          '$starCount',
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
        const SizedBox(width: 4),
        const Icon(Icons.star, color: Colors.amber, size: 16),
        const SizedBox(width: 4),
        Expanded(
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: Colors.grey[300],
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}