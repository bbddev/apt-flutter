import 'package:flutter/material.dart';
import 'product.dart';
import 'create_product_page.dart';
import 'update_product_page.dart';
import 'services/services.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ProductService _productService = ProductService();
  final TextEditingController _searchController = TextEditingController();
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;

  // Sorting variables
  String _sortBy = 'name'; // 'name', 'price', 'quantity'
  bool _sortAscending = true;

  // Filter variables
  bool _showFilterOptions = false;
  Set<String> _selectedPriceRanges = <String>{};
  Set<String> _selectedQuantityRanges = <String>{};

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final products = await _productService.getAllProducts();
      setState(() {
        _products = products;
        _applyFiltersAndSort();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        UtilsService.showErrorMessage(context, 'Lỗi khi tải dữ liệu: $e');
      }
    }
  }

  void _applyFiltersAndSort() {
    final filtered = FilterService.applyFiltersAndSort(
      products: _products,
      searchText: _searchController.text,
      selectedPriceRanges: _selectedPriceRanges,
      selectedQuantityRanges: _selectedQuantityRanges,
      sortBy: _sortBy,
      sortAscending: _sortAscending,
    );

    setState(() {
      _filteredProducts = filtered;
    });
  }

  void _filterProducts(String keyword) {
    _applyFiltersAndSort();
  }

  void _changeSortOrder(String sortBy) {
    setState(() {
      if (_sortBy == sortBy) {
        _sortAscending = !_sortAscending;
      } else {
        _sortBy = sortBy;
        _sortAscending = true;
      }
      _applyFiltersAndSort();
    });
  }

  void _togglePriceFilter(String range, bool selected) {
    setState(() {
      if (selected) {
        _selectedPriceRanges.add(range);
      } else {
        _selectedPriceRanges.remove(range);
      }
      _applyFiltersAndSort();
    });
  }

  void _toggleQuantityFilter(String range, bool selected) {
    setState(() {
      if (selected) {
        _selectedQuantityRanges.add(range);
      } else {
        _selectedQuantityRanges.remove(range);
      }
      _applyFiltersAndSort();
    });
  }

  Future<void> _navigateToCreateProduct() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateProductPage()),
    );

    // Nếu có sản phẩm mới được thêm, reload danh sách
    if (result == true) {
      _loadProducts();
    }
  }

  Future<void> _navigateToUpdateProduct(Product product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateProductPage(product: product),
      ),
    );

    // Nếu có sản phẩm được cập nhật hoặc xóa, reload danh sách
    if (result == true) {
      _loadProducts();
    }
  }

  String _formatPrice(int price) {
    return UtilsService.formatPrice(price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách sản phẩm'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterProducts,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm sản phẩm...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterProducts('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Controls section
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.grey[100],
            child: Column(
              children: [
                // Sort and Filter row
                Row(
                  children: [
                    // Sort dropdown
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _sortBy,
                        decoration: const InputDecoration(
                          labelText: 'Sắp xếp theo',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'name',
                            child: Text('Tên sản phẩm'),
                          ),
                          DropdownMenuItem(value: 'price', child: Text('Giá')),
                          DropdownMenuItem(
                            value: 'quantity',
                            child: Text('Số lượng'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) _changeSortOrder(value);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Sort direction button
                    IconButton(
                      onPressed: () => _changeSortOrder(_sortBy),
                      icon: Icon(
                        _sortAscending
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                      ),
                      tooltip: _sortAscending ? 'Tăng dần' : 'Giảm dần',
                    ),
                    // Filter toggle button
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _showFilterOptions = !_showFilterOptions;
                        });
                      },
                      icon: Icon(
                        _showFilterOptions
                            ? Icons.filter_list_off
                            : Icons.filter_list,
                        color:
                            _selectedPriceRanges.isNotEmpty ||
                                _selectedQuantityRanges.isNotEmpty
                            ? Colors.blue
                            : null,
                      ),
                      tooltip: 'Bộ lọc',
                    ),
                  ],
                ),
                // Filter options
                if (_showFilterOptions) ...[
                  const SizedBox(height: 8),
                  const Divider(),
                  // Price filter
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Lọc theo giá:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Wrap(
                    children: FilterService.priceRanges.map((range) {
                      return FilterChip(
                        label: Text(range),
                        selected: _selectedPriceRanges.contains(range),
                        onSelected: (selected) =>
                            _togglePriceFilter(range, selected),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  // Quantity filter
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Lọc theo số lượng:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Wrap(
                    children: FilterService.quantityRanges.map((range) {
                      return FilterChip(
                        label: Text(range),
                        selected: _selectedQuantityRanges.contains(range),
                        onSelected: (selected) =>
                            _toggleQuantityFilter(range, selected),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
          // Product list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchController.text.isNotEmpty ||
                                  _selectedPriceRanges.isNotEmpty ||
                                  _selectedQuantityRanges.isNotEmpty
                              ? 'Không tìm thấy sản phẩm phù hợp'
                              : 'Chưa có sản phẩm nào',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadProducts,
                    child: ListView.builder(
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = _filteredProducts[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const Icon(
                                Icons.shopping_bag,
                                color: Colors.blue,
                              ),
                            ),
                            title: Text(
                              product.productName ?? 'N/A',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Giá: ${_formatPrice(product.price ?? 0)} VNĐ',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Số lượng: ${product.quantity ?? 0}',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              _navigateToUpdateProduct(product);
                            },
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateProduct,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
