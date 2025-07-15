import 'package:flutter/material.dart';

class UtilsService {
  // Format giá tiền với dấu phẩy
  static String formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  // Validate tên sản phẩm
  static String? validateProductName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập tên sản phẩm';
    }
    if (value.length < 2) {
      return 'Tên sản phẩm phải có ít nhất 2 ký tự';
    }
    return null;
  }

  // Validate giá
  static String? validatePrice(String? value) {
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

  // Validate số lượng
  static String? validateQuantity(String? value) {
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

  // Hiển thị thông báo thành công
  static void showSuccessMessage(context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  // Hiển thị thông báo lỗi
  static void showErrorMessage(context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
