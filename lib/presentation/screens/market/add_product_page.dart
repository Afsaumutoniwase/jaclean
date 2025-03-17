import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productDescriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _itemState = 'New';
  File? _image;
  String _uploadSection = 'Sell'; // Default to "Sell"

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

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

  void _postProduct() {
    if (_formKey.currentState!.validate()) {
      final product = {
        'name': _productNameController.text,
        'description': _productDescriptionController.text,
        'price': _priceController.text,
        'image': _image?.path ?? '',
        'section': _uploadSection,
      };
      Navigator.pop(context, product);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0), // Add space above the "Hello" part
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Hello,",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(height: 4),
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
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {
              // Handle shopping cart action
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white, // Ensure the background is white
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text("Add a listing", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImage,
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: _image == null
                          ? const Icon(Icons.add, color: Colors.white, size: 30)
                          : ClipOval(
                              child: Image.file(
                                _image!,
                                fit: BoxFit.cover,
                                width: 50,
                                height: 50,
                              ),
                            ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Add photo",
                      style: TextStyle(fontSize: 16, color: Colors.green),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text("Product name", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
              TextFormField(
                controller: _productNameController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the product name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text("Product description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
              TextFormField(
                controller: _productDescriptionController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the product description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text("Item state", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
              DropdownButtonFormField<String>(
                value: _itemState,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                ),
                items: ['New', 'Fairly used', 'Mostly used', 'Newly used'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _itemState = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text("Price", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text("Upload Section", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text("Sell"),
                      value: "Sell",
                      groupValue: _uploadSection,
                      onChanged: (value) {
                        setState(() {
                          _uploadSection = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text("Charity Donation"),
                      value: "Charity Donation",
                      groupValue: _uploadSection,
                      onChanged: (value) {
                        setState(() {
                          _uploadSection = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Center(
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: _postProduct,
                    child: const Text("Post", style: TextStyle(fontSize: 16, color: Colors.white)),
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
}