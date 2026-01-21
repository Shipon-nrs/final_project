import 'package:flutter/material.dart';
import '../models/lost_item.dart';
import '../services/database_service.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _nameController = TextEditingController();
  final _placeController = TextEditingController();
  final _timeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dbService = DatabaseService();

  String selectedCategory = "Electronics";
  bool _isLoading = false;

  final Map<String, String> categoryImages = {
    "Electronics": "assets/phone.jpg",
    "Accessories": "assets/accessories.png",
    "Books": "assets/books.png",
    "Other": "assets/other.jpg",
  };

  Future<void> saveItem() async {
    if (_nameController.text.isEmpty ||
        _placeController.text.isEmpty ||
        _timeController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }


    setState(() {
      _isLoading = true;
    });

    try {

      final newItem = LostItem(
        name: _nameController.text.trim(),
        place: _placeController.text.trim(),
        time: _timeController.text.trim(),
        category: selectedCategory,
        image: categoryImages[selectedCategory]!,
        description: _descriptionController.text.trim(),
        phone: _phoneController.text.trim(),
      );


      await _dbService.addItem(newItem);


      if (!mounted) return;


      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Item added successfully!"),
          backgroundColor: Colors.green,
        ),
      );


      Navigator.pop(context);
    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to add item: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {

    _nameController.dispose();
    _placeController.dispose();
    _timeController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(title: const Text("Add Lost Item")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [

            TextField(
              controller: _nameController,
              enabled: !_isLoading,
              decoration: const InputDecoration(
                labelText: "Item Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _placeController,
              enabled: !_isLoading,
              decoration: const InputDecoration(
                labelText: "Place",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _timeController,
              enabled: !_isLoading,
              decoration: const InputDecoration(
                labelText: "Time",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              initialValue: selectedCategory,
              decoration: const InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(),
              ),
              items: categoryImages.keys.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: _isLoading ? null : (value) {
                if (value != null) {
                  setState(() {
                    selectedCategory = value;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            Center(
              child: Image.asset(
                categoryImages[selectedCategory]!,
                height: 140,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _descriptionController,
              enabled: !_isLoading,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _phoneController,
              enabled: !_isLoading,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : saveItem,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        "Submit",
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
