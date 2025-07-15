import 'package:flutter/material.dart';
import 'product.dart';
import 'database_helper.dart';

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
  final DatabaseHelper _databaseHelper = DatabaseHelper();

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

  Future<void> _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      final updatedProduct = Product(
        id: widget.product.id,
        productName: _productNameController.text.trim(),
        price: int.parse(_priceController.text),
        quantity: double.parse(_quantityController.text),
      );

      try {
        await _databaseHelper.updateProduct(updatedProduct);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cập nhật sản phẩm thành công!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true); // Trả về true để báo hiệu có cập nhật
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi khi cập nhật sản phẩm: $e'),
              backgroundColor: Colors.red,
            ),
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
        await _databaseHelper.deleteProduct(widget.product.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Xóa sản phẩm thành công!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true); // Trả về true để báo hiệu có thay đổi
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi khi xóa sản phẩm: $e'),
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
