import 'package:flutter/material.dart';

class ProfileAccount extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String? gender;
  final String? phone;
  final String? email;
  final DateTime? dob;

  const ProfileAccount({
    super.key,
    required this.firstName,
    required this.lastName,
    this.phone = '09122334455',
    this.dob,
    this.gender,
    this.email,
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

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.firstName);
    _lastNameController = TextEditingController(text: widget.lastName);
    _phoneController = TextEditingController(text: widget.phone ?? '');
    _emailController = TextEditingController(text: widget.email ?? '');
    _selectedGender = widget.gender;

    _dateController = TextEditingController(
      text: widget.dob != null ? '${widget.dob!.toLocal()}'.split(' ')[0] : '',
    );

    _selectedDate = widget.dob;
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
        _dateController.text = '${_selectedDate!.toLocal()}'.split(' ')[0];
      });
    }
  }

  void _updateProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile Updated Successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Account")),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[300],
                      child: const Icon(
                        Icons.person_outlined,
                        size: 50,
                        color: Colors.black12,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "${widget.firstName} ${widget.lastName}",
                      style: const TextStyle(
                        color: Color(0xff181D27),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // First Name Field
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: "First Name",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              // Last Name Field
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: "Last Name",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              // Gender Dropdown
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(
                  labelText: "Gender",
                  border: OutlineInputBorder(),
                ),
                items: ["Male", "Female", "Other"].map((String gender) {
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
              ),

              const SizedBox(height: 20),

              // Date of Birth Picker
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  border: const OutlineInputBorder(),
                  hintText: _selectedDate != null
                      ? '${_selectedDate!.toLocal()}'.split(' ')[0]
                      : 'Select your date of birth',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Phone Number Input (Simplified)
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Phone Number',
                  prefixText: '+234 | ', // Change this based on country
                ),
              ),

              const SizedBox(height: 20),

              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              // Update Profile Button
              Center(
                child: ElevatedButton(
                  onPressed: _updateProfile,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 11,
                      horizontal: 25,
                    ),
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
