import 'package:flutter/material.dart';
import 'package:demoprovider/providers/product_provider.dart';
import 'package:demoprovider/providers/tabindex_provider.dart';
import 'package:provider/provider.dart';
//stateless->khong cap nhat trang thai
//satatefull->cap nhat lai trang thai.count=0 setState(count++)


class ProductList extends StatelessWidget {
  const ProductList({super.key});
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context,listen: true);
    final tabIndexProvider =
        Provider.of<TabIndexProvider>(context, listen: false);
    productProvider.fetchProducts();
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        final products = productProvider.products;
        if (products.isEmpty) {
          return const Center(child: Text('No products available.'));
        }
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          child: ListView.separated(
            itemCount: products.length,
            separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.grey),
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                elevation: 3.0,
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColorLight,
                    child: Text(
                      product.name.isNotEmpty ? product.name[0].toUpperCase() : 'P',
                      style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  subtitle: Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.grey[700], fontSize: 14.0),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                          title: const Text('Confirm Deletion'),
                          content: Text('Are you sure you want to delete "${product.name}"? This action cannot be undone.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                            ),
                            TextButton(
                              onPressed: () => {
                                productProvider.deleteProduct(product.id),
                                Navigator.pop(context, 'OK')
                              },
                              child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  onTap: () { // Changed from onLongPress to onTap for selecting product
                    productProvider.setSelectedProduct(product);
                    tabIndexProvider.setIndex(1);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
