# Product Management App - Flutter SQLite

Ứng dụng quản lý sản phẩm được xây dựng bằng Flutter với SQLite database, hỗ trợ đầy đủ các chức năng CRUD (Create, Read, Update, Delete).

## 📱 Tính năng chính

- ✅ **Thêm sản phẩm** với ID tùy chọn hoặc auto-generated
- ✅ **Xem danh sách** sản phẩm với tính năng tìm kiếm
- ✅ **Chỉnh sửa** thông tin sản phẩm
- ✅ **Xóa sản phẩm** với dialog xác nhận
- ✅ **TabController** với 3 tabs: ADD, VIEW, EXIT
- ✅ **Validation** đầy đủ cho tất cả input
- ✅ **SQLite Database** lưu trữ dữ liệu local

## 🏗️ Kiến trúc ứng dụng

### 1. Cấu trúc thư mục

```
lib/
├── main.dart                  # Entry point của app
├── homepage.dart              # HomePage với TabController
├── model/
│   └── product.dart           # Product model class
├── db/
│   └── database_helper.dart   # SQLite database operations
├── service/
│   └── product_service.dart   # Business logic layer
└── page/
    ├── add_product_page.dart  # Trang thêm sản phẩm
    ├── view_product_page.dart # Trang xem/tìm kiếm
    └── edit_product_page.dart # Trang chỉnh sửa
```

### 2. Database Schema

```sql
CREATE TABLE Product (
  _id INTEGER PRIMARY KEY AUTOINCREMENT,
  _name TEXT NOT NULL,
  _price INTEGER NOT NULL
)
```

## 🛠️ Hướng dẫn xây dựng từ đầu

### Bước 1: Tạo project Flutter mới

```bash
flutter create product_management_app
cd product_management_app
```

### Bước 2: Thêm dependencies vào pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  sqflite: ^2.3.0 # SQLite database
  path: ^1.8.3 # Đường dẫn file
```

### Bước 3: Tạo Product Model (lib/model/product.dart)

```dart
class Product {
  int? id;
  String name;
  int price;

  Product({this.id, required this.name, required this.price});

  // Convert Product to Map for SQLite
  Map<String, dynamic> toMap() {
    return {'_id': id, '_name': name, '_price': price};
  }

  // Convert Map to Product
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['_id'],
      name: map['_name'],
      price: map['_price'],
    );
  }
}
```

### Bước 4: Tạo Database Helper (lib/db/database_helper.dart)

```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'ProductDB.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Product (
        _id INTEGER PRIMARY KEY AUTOINCREMENT,
        _name TEXT NOT NULL,
        _price INTEGER NOT NULL
      )
    ''');
  }

  // CRUD Operations
  Future<int> insertProduct(Product product) async { ... }
  Future<List<Product>> getAllProducts() async { ... }
  Future<List<Product>> searchProducts(String query) async { ... }
  Future<int> updateProduct(Product product) async { ... }
  Future<int> deleteProduct(int id) async { ... }
}
```

### Bước 5: Tạo Service Layer (lib/service/product_service.dart)

```dart
class ProductService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<bool> createProduct(String idText, String name, String priceText) async {
    // Validation logic
    // Database operations
  }

  Future<bool> updateProduct(String idText, String name, String priceText) async {
    // Update logic với validation
  }

  Future<bool> deleteProduct(int id) async {
    // Delete logic
  }

  Future<List<Product>> searchProducts(String query) async {
    // Search logic
  }
}
```

### Bước 6: Tạo UI Pages

#### Main App (lib/main.dart)

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product Management',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const MyHomePage(),
    );
  }
}
```

#### HomePage với TabController (lib/homepage.dart)

```dart
class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection); // Xử lý EXIT tab
  }

  void _handleTabSelection() {
    if (_tabController.index == 2 && _tabController.indexIsChanging) {
      _showExitDialog(); // Hiện dialog xác nhận thoát
      // Quay về tab trước
    }
  }
}
```

#### Add Product Page

- Form với 3 fields: ID (optional), Name, Price
- Validation đầy đủ
- CREATE và CLEAR buttons

#### View Product Page

- Search functionality
- ListView hiển thị products
- PopupMenuButton với Edit/Delete options
- Confirmation dialog trước khi delete

#### Edit Product Page

- Form tương tự Add nhưng ID read-only
- Pre-populate data từ product được chọn
- UPDATE và CANCEL buttons

## 🔧 Các tính năng kỹ thuật

### 1. **Database Operations**

- **Insert**: Hỗ trợ custom ID hoặc auto-increment
- **Select**: Lấy tất cả hoặc search theo tên
- **Update**: Cập nhật theo ID
- **Delete**: Xóa theo ID

### 2. **Validation**

- **ID**: Optional, phải là số dương
- **Name**: Không được trống
- **Price**: Không được trống, phải là số dương

### 3. **Error Handling**

- Try-catch cho tất cả database operations
- User-friendly error messages
- SnackBar notifications

### 4. **UI/UX Features**

- **TabController** với icons
- **AppBar** ẩn title (toolbarHeight: 0)
- **PopupMenuButton** cho actions
- **Confirmation dialogs**
- **Loading states**
- **Responsive design**

## 🚀 Cách chạy ứng dụng

### 1. Cài đặt dependencies

```bash
flutter pub get
```

### 2. Chạy ứng dụng

```bash
flutter run
```

### 3. Hoặc build APK

```bash
flutter build apk --release
```

## 📝 Các bước validation quan trọng

### 1. **Input Validation**

```dart
validator: (value) {
  if (value == null || value.trim().isEmpty) {
    return 'Field cannot be blank';
  }
  // Thêm validation logic khác
  return null;
}
```

### 2. **Database Constraint Handling**

```dart
try {
  await _databaseHelper.insertProduct(product);
} catch (e) {
  if (e.toString().contains('UNIQUE constraint failed')) {
    throw Exception('Product ID already exists');
  }
  rethrow;
}
```

### 3. **Safe Navigation**

```dart
if (mounted) {
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
```

## 🎯 Key Learning Points

1. **Flutter State Management**: StatefulWidget và setState()
2. **SQLite Integration**: sqflite package usage
3. **Form Validation**: Form + TextFormField + validators
4. **Navigation**: Navigator.push/pop với callbacks
5. **Async Programming**: Future, async/await
6. **Error Handling**: try-catch-finally blocks
7. **UI Components**: TabController, PopupMenuButton, AlertDialog
8. **Clean Architecture**: Model-Service-UI separation

## 🔍 Debugging Tips

1. **Database Issues**: Kiểm tra đường dẫn và schema
2. **Validation Errors**: Log input values trước khi validate
3. **State Issues**: Đảm bảo setState() được gọi đúng chỗ
4. **Navigation Issues**: Kiểm tra context và mounted state

## 📚 Tài liệu tham khảo

- [Flutter Documentation](https://docs.flutter.dev/)
- [SQLite Plugin](https://pub.dev/packages/sqflite)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [Material Design](https://material.io/design)

---

**Framework**: Flutter 3.8.1+  
**Database**: SQLite  
**Platform**: Android
