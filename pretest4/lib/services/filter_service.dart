import '../product.dart';

class FilterService {
  // Danh sách các khoảng giá
  static const List<String> priceRanges = [
    'Dưới 100,000',
    '100,000 - 500,000',
    '500,000 - 1,000,000',
    'Trên 1,000,000',
  ];

  // Danh sách các khoảng số lượng
  static const List<String> quantityRanges = [
    'Dưới 10',
    '10 - 50',
    '50 - 100',
    'Trên 100',
  ];

  // Lọc sản phẩm theo từ khóa tìm kiếm
  static List<Product> filterBySearch(
    List<Product> products,
    String searchText,
  ) {
    if (searchText.isEmpty) return products;

    return products
        .where(
          (product) => product.productName!.toLowerCase().contains(
            searchText.toLowerCase(),
          ),
        )
        .toList();
  }

  // Lọc sản phẩm theo khoảng giá
  static List<Product> filterByPriceRanges(
    List<Product> products,
    Set<String> selectedRanges,
  ) {
    if (selectedRanges.isEmpty) return products;

    return products.where((product) {
      final price = product.price ?? 0;
      return selectedRanges.any((range) {
        switch (range) {
          case 'Dưới 100,000':
            return price < 100000;
          case '100,000 - 500,000':
            return price >= 100000 && price <= 500000;
          case '500,000 - 1,000,000':
            return price >= 500000 && price <= 1000000;
          case 'Trên 1,000,000':
            return price > 1000000;
          default:
            return true;
        }
      });
    }).toList();
  }

  // Lọc sản phẩm theo khoảng số lượng
  static List<Product> filterByQuantityRanges(
    List<Product> products,
    Set<String> selectedRanges,
  ) {
    if (selectedRanges.isEmpty) return products;

    return products.where((product) {
      final quantity = product.quantity ?? 0;
      return selectedRanges.any((range) {
        switch (range) {
          case 'Dưới 10':
            return quantity < 10;
          case '10 - 50':
            return quantity >= 10 && quantity <= 50;
          case '50 - 100':
            return quantity >= 50 && quantity <= 100;
          case 'Trên 100':
            return quantity > 100;
          default:
            return true;
        }
      });
    }).toList();
  }

  // Sắp xếp sản phẩm
  static List<Product> sortProducts(
    List<Product> products,
    String sortBy,
    bool ascending,
  ) {
    List<Product> sorted = List.from(products);

    sorted.sort((a, b) {
      int comparison = 0;
      switch (sortBy) {
        case 'name':
          comparison = (a.productName ?? '').compareTo(b.productName ?? '');
          break;
        case 'price':
          comparison = (a.price ?? 0).compareTo(b.price ?? 0);
          break;
        case 'quantity':
          comparison = (a.quantity ?? 0).compareTo(b.quantity ?? 0);
          break;
      }
      return ascending ? comparison : -comparison;
    });

    return sorted;
  }

  // Áp dụng tất cả bộ lọc và sắp xếp
  static List<Product> applyFiltersAndSort({
    required List<Product> products,
    required String searchText,
    required Set<String> selectedPriceRanges,
    required Set<String> selectedQuantityRanges,
    required String sortBy,
    required bool sortAscending,
  }) {
    List<Product> filtered = List.from(products);

    // Áp dụng tìm kiếm
    filtered = filterBySearch(filtered, searchText);

    // Áp dụng lọc theo giá
    filtered = filterByPriceRanges(filtered, selectedPriceRanges);

    // Áp dụng lọc theo số lượng
    filtered = filterByQuantityRanges(filtered, selectedQuantityRanges);

    // Áp dụng sắp xếp
    filtered = sortProducts(filtered, sortBy, sortAscending);

    return filtered;
  }
}
