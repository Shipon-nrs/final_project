import 'package:flutter/material.dart';
import '../models/lost_item.dart';
import 'package:intl/intl.dart';
import '../services/database_service.dart';
import '../services/supabase_config.dart';

class ItemDetailScreen extends StatefulWidget {
  final LostItem item;

  const ItemDetailScreen({super.key, required this.item});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  final _dbService = DatabaseService();
  bool _isDeleting = false;

  bool get _isOwner => widget.item.userId == SupabaseConfig.currentUser?.id;

  Future<void> _deleteItem() async {
    if (!_isOwner) return;

    setState(() {
      _isDeleting = true;
    });

    try {
      await _dbService.deleteItem(widget.item.id!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item deleted successfully')),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete item: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('MMM dd, yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name),
        actions: _isOwner
            ? [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _isDeleting ? null : _deleteItem,
                ),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Image.asset(
              widget.item.image,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 220,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported),
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    widget.item.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text("📍 Place: ${widget.item.place}"),

                  Text("⏰ Time: ${widget.item.time}"),

                  Text("📂 Category: ${widget.item.category}"),

                  if (widget.item.createdAt != null)
                    Text(
                      "📅 Posted: ${dateFormatter.format(widget.item.createdAt!)}",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),

                  const SizedBox(height: 15),

                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(widget.item.description),

                  const SizedBox(height: 15),

                  const Text(
                    "Contact Number",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    widget.item.phone,
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.call),
                      label: Text("Call Now (${widget.item.phone})"),
                      onPressed: () {

                      },
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
}
