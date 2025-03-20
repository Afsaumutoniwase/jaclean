import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileAccount extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String? gender;
  final String? phone;
  final String? email;
  final DateTime? dob;
  final String? avatarUrl;

  const ProfileAccount({
    super.key,
    required this.firstName,
    required this.lastName,
    this.phone = '09122334455',
    this.dob,
    this.gender,
    this.email,
    this.avatarUrl,
  });

  @override
  State<ProfileAccount> createState() => _ProfileAccountState();
}

class _ProfileAccountState extends State<ProfileAccount> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _dateController;

  DateTime? _selectedDate;
  String? _selectedGender;
  bool _isLoading = false;

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.firstName);
    _lastNameController = TextEditingController(text: widget.lastName);
    _phoneController = TextEditingController(text: widget.phone ?? '');
    _emailController = TextEditingController(text: widget.email ?? '');
    _selectedGender = widget.gender;

    _dateController = TextEditingController(
      text: widget.dob != null ? _formatDate(widget.dob!) : '',
    );

    _selectedDate = widget.dob;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  // Validate form before submission
  bool _validateForm() {
    if (_firstNameController.text.isEmpty) {
      _showErrorMessage('First name is required');
      return false;
    }

    if (_lastNameController.text.isEmpty) {
      _showErrorMessage('Last name is required');
      return false;
    }

    if (_emailController.text.isNotEmpty && !_isValidEmail(_emailController.text)) {
      _showErrorMessage('Please enter a valid email address');
      return false;
    }

    return true;
  }

  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _updateProfile() async {
    // Validate form first
    if (!_validateForm()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Get current user
      final User? user = _auth.currentUser;

      if (user == null) {
        _showErrorMessage('User not authenticated');
        return;
      }

      // Prepare data to update
      final Map<String, dynamic> userData = {
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'phone': _phoneController.text,
      };

      // Only add these fields if they have values
      if (_emailController.text.isNotEmpty) {
        userData['email'] = _emailController.text;
      }

      if (_selectedGender != null) {
        userData['gender'] = _selectedGender;
      }

      if (_selectedDate != null) {
        userData['dob'] = Timestamp.fromDate(_selectedDate!);
      }

      // Update Firestore document in the users collection
      await _firestore.collection('users').doc(user.uid).update(userData);

      // If email was changed, update Firebase Auth email
      if (_emailController.text.isNotEmpty && _emailController.text != user.email) {
        await user.verifyBeforeUpdateEmail(_emailController.text);
      }

      // Update local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('firstName', _firstNameController.text);
      await prefs.setString('lastName', _lastNameController.text);

      if (_phoneController.text.isNotEmpty) {
        await prefs.setString('phone', _phoneController.text);
      }

      if (_emailController.text.isNotEmpty) {
        await prefs.setString('email', _emailController.text);
      }

      if (_selectedGender != null) {
        await prefs.setString('gender', _selectedGender!);
      }

      if (_selectedDate != null) {
        await prefs.setString('dob', _formatDate(_selectedDate!));
      }

      _showSuccessMessage('Profile updated successfully!');
    } catch (e) {
      _showErrorMessage('Error updating profile: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xff1FC776),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Account"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: widget.avatarUrl != null ? AssetImage(widget.avatarUrl!) : null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "${widget.firstName} ${widget.lastName}",
                      style: const TextStyle(
                        color: Color(0xff181D27),
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (widget.email != null && widget.email!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          widget.email!,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              const Text(
                "Personal Information",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              // First Name Field
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: "First Name",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),

              const SizedBox(height: 20),

              // Last Name Field
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: "Last Name",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),

              const SizedBox(height: 20),

              // Gender Dropdown
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(
                  labelText: "Gender",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.people_outline),
                ),
                items: ["Male", "Female", "Other", "Prefer not to say"]
                    .map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
                hint: const Text("Select Gender"),
              ),

              const SizedBox(height: 20),

              // Date of Birth Picker
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  border: const OutlineInputBorder(),
                  hintText: 'Select your date of birth',
                  prefixIcon: const Icon(Icons.calendar_today_outlined),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_month),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                onTap: () => _selectDate(context),
              ),

              const SizedBox(height: 32),
              const Text(
                "Contact Information",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              // Phone Number Input
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
              ),

              const SizedBox(height: 20),

              // Email Field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),

              const SizedBox(height: 32),

              // Update Profile Button
              Center(
                child: ElevatedButton(
                  onPressed: _updateProfile,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: const Color(0xff1FC776),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Update Profile",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}