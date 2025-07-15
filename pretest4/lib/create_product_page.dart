import 'package:flutter/material.dart';
import 'product.dart';
import 'database_helper.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({Key? key}) : super(key: key);

  @override
  State<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void dispose() {
    _productNameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  String? _validateProductName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập tên sản phẩm';
    }
    if (value.length < 2) {
      return 'Tên sản phẩm phải có ít nhất 2 ký tự';
    }
    return null;
  }

  String? _validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập giá sản phẩm';
    }
    final price = int.tryParse(value);
    if (price == null) {
      return 'Giá phải là số nguyên';
    }
    if (price <= 0) {
      return 'Giá phải lớn hơn 0';
    }
    return null;
  }

  String? _validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập số lượng';
    }
    final quantity = double.tryParse(value);
    if (quantity == null) {
      return 'Số lượng phải là số';
    }
    if (quantity <= 0) {
      return 'Số lượng phải lớn hơn 0';
    }
    return null;
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        productName: _productNameController.text.trim(),
        price: int.parse(_priceController.text),
        quantity: double.parse(_quantityController.text),
      );

      try {
        await _databaseHelper.insertProduct(product);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Thêm sản phẩm thành công!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(
            context,
            true,
          ); // Trả về true để báo hiệu có thêm sản phẩm mới
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi khi thêm sản phẩm: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm sản phẩm mới'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _productNameController,
                decoration: const InputDecoration(
                  labelText: 'Tên sản phẩm',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.shopping_bag),
                ),
                validator: _validateProductName,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Giá (VNĐ)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: _validatePrice,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Số lượng',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.inventory),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: _validateQuantity,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Lưu sản phẩm',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
