import 'package:flutter/material.dart';
import 'package:demoprovider/models/product.dart';
import 'package:demoprovider/providers/product_provider.dart';
import 'package:demoprovider/providers/tabindex_provider.dart';
import 'package:provider/provider.dart';

class FormProduct extends StatefulWidget {
  const FormProduct({super.key});
  @override
  State<FormProduct> createState() => _FormProductState();
}

class _FormProductState extends State<FormProduct> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final selectedProduct = productProvider.selectedProduct;
    if (selectedProduct != null) {
      _nameController.text = selectedProduct.name;
      _priceController.text = selectedProduct.price.toString();
      _descriptionController.text = selectedProduct.description;
    }
    return Container(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'Enter name',
                labelText: 'Name',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter product name';
                }
                return null;
              },
              controller: _nameController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'Enter price',
                labelText: 'Price',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter price';
                }
                final priceValue = double.tryParse(value);
                if (priceValue == null) {
                  return 'Please enter a number';
                }
                if (priceValue <= 0) {
                  return 'Price must be greater than zero';
                }
                return null;
              },
              controller: _priceController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'Enter description',
                labelText: 'Description',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter description';
                }
                if (value.length <= 5) {
                  return 'description must be greater than 5 character';
                }
                return null;
              },
              controller: _descriptionController,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final name = _nameController.text;
                  final price = double.parse(_priceController.text);
                  final description = _descriptionController.text;
                  final product = Product(
                      id: selectedProduct?.id ?? DateTime.now().millisecondsSinceEpoch,
                      name: name,
                      price: price,
                      description: description);
                  // // Submit data
                  // ignore: unnecessary_null_comparison
                  if (selectedProduct?.id != null) {
                    productProvider.updateDatabase(product);
                    productProvider.selectedProduct = null;
                  } else {
                    productProvider.addProduct(product);
                  }
                  // ignore: use_build_context_synchronously
                  Provider.of<TabIndexProvider>(context, listen: false)
                      .setIndex(0);
                }
              },
              child: Text(selectedProduct != null ? 'Update' : 'Add'),
            )
          ],
        ),
      ),
    );
  }
}
