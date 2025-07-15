import 'package:flutter/material.dart';
import 'product.dart';
import 'services/services.dart';

class UpdateProductPage extends StatefulWidget {
  final Product product;

  const UpdateProductPage({Key? key, required this.product}) : super(key: key);

  @override
  State<UpdateProductPage> createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _productNameController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;
  final ProductService _productService = ProductService();

  @override
  void initState() {
    super.initState();
    _productNameController = TextEditingController(
      text: widget.product.productName,
    );
    _priceController = TextEditingController(
      text: widget.product.price?.toString() ?? '',
    );
    _quantityController = TextEditingController(
      text: widget.product.quantity?.toString() ?? '',
    );
  }

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

  Future<void> _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      final updatedProduct = Product(
        id: widget.product.id,
        productName: _productNameController.text.trim(),
        price: int.parse(_priceController.text),
        quantity: double.parse(_quantityController.text),
      );

      try {
        await _productService.updateProduct(updatedProduct);
        if (mounted) {
          UtilsService.showSuccessMessage(
            context,
            'Cập nhật sản phẩm thành công!',
          );
          Navigator.pop(context, true); // Trả về true để báo hiệu có cập nhật
        }
      } catch (e) {
        if (mounted) {
          UtilsService.showErrorMessage(
            context,
            'Lỗi khi cập nhật sản phẩm: $e',
          );
        }
      }
    }
  }

  Future<void> _deleteProduct() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text(
            'Bạn có chắc chắn muốn xóa sản phẩm "${widget.product.productName}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      try {
        await _productService.deleteProduct(widget.product.id!);
        if (mounted) {
          UtilsService.showSuccessMessage(context, 'Xóa sản phẩm thành công!');
          Navigator.pop(context, true); // Trả về true để báo hiệu có thay đổi
        }
      } catch (e) {
        if (mounted) {
          UtilsService.showErrorMessage(context, 'Lỗi khi xóa sản phẩm: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cập nhật sản phẩm'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteProduct,
            tooltip: 'Xóa sản phẩm',
          ),
        ],
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
                onPressed: _updateProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Cập nhật sản phẩm',
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
