import 'package:flutter/material.dart';
import 'product.dart';
import 'services/services.dart';

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
  final ProductService _productService = ProductService();

  @override
  void dispose() {
    _productNameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  String? _validateProductName(String? value) {
    return UtilsService.validateProductName(value);
  }

  String? _validatePrice(String? value) {
    return UtilsService.validatePrice(value);
  }

  String? _validateQuantity(String? value) {
    return UtilsService.validateQuantity(value);
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        productName: _productNameController.text.trim(),
        price: int.parse(_priceController.text),
        quantity: double.parse(_quantityController.text),
      );

      try {
        await _productService.addProduct(product);
        if (mounted) {
          UtilsService.showSuccessMessage(context, 'Thêm sản phẩm thành công!');
          Navigator.pop(
            context,
            true,
          ); // Trả về true để báo hiệu có thêm sản phẩm mới
        }
      } catch (e) {
        if (mounted) {
          UtilsService.showErrorMessage(context, 'Lỗi khi thêm sản phẩm: $e');
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
