import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final primaryColor = const Color(0xFF00BF63);
  String? _userName;
  String? _selectedAvatar;
  String? _selectedLocation;
  String? _selectedCenter;
  bool _acceptedTerms = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildWelcomePage(user?.email),
                  _buildAvatarPage(),
                  _buildLocationPage(),
                  _buildCenterPage(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Text('Back'),
                    ),
                  ElevatedButton(
                    onPressed: _canProgress() ? _nextPage : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      _currentPage == 3 ? 'Finish' : 'Next',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage(String? email) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome to JaClean!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          SizedBox(height: 16),
         
          if (email != null)
            Text(
              'Thank you for joining our eco-friendly community $email, let/s grab some details to get started.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          SizedBox(height: 32),
          TextField(
            onChanged: (value) => setState(() => _userName = value),
            decoration: InputDecoration(
              labelText: 'Your Name',
              hintText: 'Enter your full name',
              prefixIcon: Icon(Icons.person_outline, color: primaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarPage() {
    final List<String> avatars = [
      'assets/images/avatar1.png',
      'assets/images/avatar2.png',
      'assets/images/avatar3.png',
      'assets/images/avatar4.png',
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Text(
            'Choose your avatar',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          SizedBox(height: 32),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: avatars.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => setState(() => _selectedAvatar = avatars[index]),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedAvatar == avatars[index]
                            ? primaryColor
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Image.asset(
                      avatars[index],
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.person, size: 64, color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationPage() {
    final List<String> locations = [
      'Lagos',
      'Abuja',
      'Port Harcourt',
      'Kano',
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Text(
            'Select your location',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          SizedBox(height: 32),
          Expanded(
            child: ListView.builder(
              itemCount: locations.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(locations[index]),
                  leading: Radio<String>(
                    value: locations[index],
                    groupValue: _selectedLocation,
                    onChanged: (value) {
                      setState(() {
                        _selectedLocation = value;
                      });
                    },
                    activeColor: primaryColor,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterPage() {
    final List<String> centers = [
      'Center 1',
      'Center 2',
      'Center 3',
      'Center 4',
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Text(
            'Choose recycling center',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          SizedBox(height: 32),
          Expanded(
            child: ListView.builder(
              itemCount: centers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(centers[index]),
                  leading: Radio<String>(
                    value: centers[index],
                    groupValue: _selectedCenter,
                    onChanged: (value) {
                      setState(() {
                        _selectedCenter = value;
                      });
                    },
                    activeColor: primaryColor,
                  ),
                );
              },
            ),
          ),
          Spacer(),
          CheckboxListTile(
            value: _acceptedTerms,
            onChanged: (value) => setState(() => _acceptedTerms = value!),
            title: Text('I accept the terms and conditions'),
          ),
        ],
      ),
    );
  }

  bool _canProgress() {
    switch (_currentPage) {
      case 0:
        return _userName?.isNotEmpty ?? false;
      case 1:
        return _selectedAvatar != null;
      case 2:
        return _selectedLocation != null;
      case 3:
        return _selectedCenter != null && _acceptedTerms;
      default:
        return false;
    }
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submitOnboardingData();
    }
  }

  Future<void> _submitOnboardingData() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'userName': _userName,
        'selectedAvatar': _selectedAvatar,
        'selectedLocation': _selectedLocation,
        'selectedCenter': _selectedCenter,
        'acceptedTerms': _acceptedTerms,
      });
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }
}