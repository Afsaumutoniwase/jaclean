import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddProductPage extends StatefulWidget {
  final Map<String, dynamic>? product;

  const AddProductPage({super.key, this.product});

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
  String? _productId;

  final List<String> _defaultImages = [
    'assets/images/table.jpeg',
    'assets/images/fridge.jpeg',
    'assets/images/clothes4.jpeg',
    'assets/images/ewaste1.jpeg',
    'assets/images/gas.jpeg',
    'assets/images/pot.jpeg',
    'assets/images/vase.jpeg',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _productId = widget.product!['id'];
      _productNameController.text = widget.product!['name'];
      _productDescriptionController.text = widget.product!['description'];
      _priceController.text = widget.product!['price'];
      _itemState = widget.product!['itemState'] ?? 'New';
      _uploadSection = widget.product!['section'] ?? 'Sell';
    }
  }

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

  Future<void> _postProduct() async {
    if (_formKey.currentState!.validate()) {
      // Pick a random default image
      final random = Random();
      String imageUrl = _defaultImages[random.nextInt(_defaultImages.length)];

      if (_image != null) {
        // Upload image to Firebase Storage
        final storageRef = FirebaseStorage.instance.ref().child('product_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
        final uploadTask = storageRef.putFile(_image!);
        final snapshot = await uploadTask.whenComplete(() {});
        imageUrl = await snapshot.ref.getDownloadURL();
      }

      final product = {
        'name': _productNameController.text,
        'description': _productDescriptionController.text,
        'price': _priceController.text,
        'image': imageUrl,
        'section': _uploadSection,
        'userId': FirebaseAuth.instance.currentUser?.uid, // Add userId to the product
      };

      if (mounted) {
        if (_productId != null) {
          // Update existing product
          await FirebaseFirestore.instance.collection('products').doc(_productId).update(product);
        } else {
          // Add new product
          await FirebaseFirestore.instance.collection('products').add(product);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product uploaded successfully')),
        );
        Navigator.pop(context, product);
      }
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
      body: SafeArea(
        child: SingleChildScrollView(
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
                    key: Key("Post"),
                    onPressed: _postProduct,
                    child: const Text("Post", style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      )// bottomNavigationBar
    );
  }
}