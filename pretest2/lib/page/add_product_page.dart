import 'package:flutter/material.dart';
import '../service/product_service.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final ProductService _productService = ProductService();

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _clearFields() {
    _idController.clear();
    _nameController.clear();
    _priceController.clear();
  }

  Future<void> _createProduct() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _productService.createProduct(
          _idController.text,
          _nameController.text,
          _priceController.text,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          _clearFields();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error: ${e.toString().replaceAll('Exception: ', '')}',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Add New Product',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Product ID Field (Optional)
            TextFormField(
              controller: _idController,
              decoration: const InputDecoration(
                labelText: 'Product ID',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.tag),
                // helperText: 'Leave empty for auto-generated ID',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null && value.trim().isNotEmpty) {
                  int? id = int.tryParse(value.trim());
                  if (id == null) {
                    return 'ID must be a valid number';
                  }
                  if (id <= 0) {
                    return 'ID must be greater than zero';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Product Name Field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Product Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.shopping_bag),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Product name cannot be blank';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Price Field
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Price cannot be blank';
                }
                int? price = int.tryParse(value.trim());
                if (price == null) {
                  return 'Price must be a valid number';
                }
                if (price <= 0) {
                  return 'Price must be greater than zero';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),

            // Create Button
            ElevatedButton(
              onPressed: _createProduct,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('CREATE', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 10),

            // Clear Button
            OutlinedButton(
              onPressed: _clearFields,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text('CLEAR', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
