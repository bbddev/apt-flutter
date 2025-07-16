# 🔍 Hướng Dẫn Tạo Chức Năng Search trong Flutter

## 📋 Tổng quan

Chức năng search cho phép người dùng tìm kiếm nhân viên theo tên, giới tính hoặc kỹ năng trong thời gian thực (real-time search).

## 🚀 Cách hoạt động

Search sử dụng sự kiện `addListener()` trên `TextEditingController` để detect thay đổi ngay khi người dùng gõ vào ô tìm kiếm.

---

## 📝 Bước 1: Khai báo Variables và Controller

```dart
class _EmployeeListScreenState extends State<EmployeeListScreen> {
  // Controller để điều khiển TextField
  final TextEditingController _searchController = TextEditingController();

  // Danh sách gốc từ database
  List<Employee> _employees = [];

  // Danh sách đã được lọc để hiển thị
  List<Employee> _filteredEmployees = [];

  // Từ khóa tìm kiếm hiện tại
  String _searchQuery = '';

  bool _isLoading = true;
}
```

**Giải thích:**

- `_searchController`: Điều khiển TextField search
- `_employees`: Danh sách gốc lấy từ database
- `_filteredEmployees`: Danh sách sau khi lọc để hiển thị
- `_searchQuery`: Lưu từ khóa tìm kiếm hiện tại

---

## 📝 Bước 2: Thiết lập Listener trong initState

```dart
@override
void initState() {
  super.initState();
  _loadEmployees(); // Tải dữ liệu ban đầu

  // 🔑 CHÌA KHÓA: Lắng nghe mọi thay đổi của TextField
  _searchController.addListener(_onSearchChanged);
}
```

**Tại sao dùng `addListener()`?**

- Tự động detect mọi thay đổi trong TextField
- Không cần khai báo `onChanged` trong TextField
- Cho phép real-time search (tìm ngay khi gõ)

---

## 📝 Bước 3: Xử lý sự kiện Search Changed

```dart
void _onSearchChanged() {
  setState(() {
    // Lưu từ khóa người dùng vừa gõ
    _searchQuery = _searchController.text;
  });

  // Gọi hàm lọc dữ liệu
  _filterEmployees();
}
```

**Luồng hoạt động:**

1. User gõ vào TextField
2. `addListener()` tự động detect
3. `_onSearchChanged()` được gọi
4. Cập nhật `_searchQuery`
5. Gọi `_filterEmployees()`

---

## 📝 Bước 4: Logic Filter Employees

```dart
void _filterEmployees() async {
  if (_searchQuery.isEmpty) {
    // Không có từ khóa → Hiển thị tất cả
    setState(() {
      _filteredEmployees = _employees;
    });
  } else {
    // Có từ khóa → Tìm kiếm trong database
    try {
      final searchResults = await _databaseHelper.searchEmployees(_searchQuery);
      setState(() {
        _filteredEmployees = searchResults;
      });
    } catch (e) {
      // Xử lý lỗi
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error searching: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
```

**Logic:**

- Nếu search rỗng → hiển thị tất cả employees
- Nếu có từ khóa → query database và cập nhật filtered list
- Sử dụng `setState()` để rebuild UI

---

## 📝 Bước 5: Database Search Query

```dart
// Trong DatabaseHelper class
Future<List<Employee>> searchEmployees(String query) async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query(
    'employees',
    where: 'name LIKE ? OR gender LIKE ? OR skill LIKE ?',
    whereArgs: ['%$query%', '%$query%', '%$query%'],
  );
  return List.generate(maps.length, (i) {
    return Employee.fromMap(maps[i]);
  });
}
```

**SQL Query giải thích:**

- `LIKE '%keyword%'`: Tìm kiếm có chứa keyword
- `%` = wildcard (bất kỳ ký tự nào)
- `OR`: Tìm trong name HOẶC gender HOẶC skill
- `whereArgs`: Tham số an toàn, tránh SQL injection

---

## 📝 Bước 6: Tạo UI Search Bar

```dart
TextField(
  controller: _searchController, // Gắn controller
  decoration: InputDecoration(
    hintText: 'Search employees...',
    prefixIcon: const Icon(Icons.search),

    // Nút Clear xuất hiện khi có text
    suffixIcon: _searchQuery.isNotEmpty
        ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear(); // Xóa text
            },
          )
        : null,

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    filled: true,
    fillColor: Colors.white,
  ),
)
```

**UI Features:**

- Icon search ở đầu
- Nút clear ở cuối (chỉ hiện khi có text)
- Border bo tròn đẹp mắt
- Background trắng

---

## 📝 Bước 7: Hiển thị Kết Quả

```dart
Expanded(
  child: _isLoading
      ? const Center(child: CircularProgressIndicator())
      : _filteredEmployees.isEmpty
      ? Center(
          child: Text(
            _searchQuery.isNotEmpty
                ? 'No employees found for "$_searchQuery"'
                : 'No employees found',
          ),
        )
      : ListView.builder(
          itemCount: _filteredEmployees.length, // Dùng filtered list
          itemBuilder: (context, index) {
            return _buildEmployeeCard(_filteredEmployees[index]);
          },
        ),
)
```

**Logic hiển thị:**

1. Đang loading → CircularProgressIndicator
2. Không có kết quả → Thông báo "No employees found"
3. Có kết quả → ListView với filtered data

---

## 📝 Bước 8: Cleanup (Quan trọng!)

```dart
@override
void dispose() {
  _searchController.dispose(); // Giải phóng bộ nhớ
  super.dispose();
}
```

**Tại sao cần dispose?**

- Tránh memory leak
- Giải phóng listener
- Best practice trong Flutter

---

## 🔄 Luồng Hoạt Động Complete Flow

```
1. User gõ "John" vào search box
   ↓
2. addListener() detect thay đổi
   ↓
3. _onSearchChanged() được gọi
   ↓
4. _searchQuery = "John"
   ↓
5. _filterEmployees() được gọi
   ↓
6. Database query: WHERE name LIKE '%John%' OR ...
   ↓
7. Kết quả trả về: [John Doe]
   ↓
8. setState() → UI rebuild
   ↓
9. ListView hiển thị kết quả mới
```

---

## 💡 Những Điểm Quan Trọng

### **1. Tại sao dùng addListener() thay vì onChanged?**

```dart
// ❌ Cách cũ - phải khai báo trong TextField
TextField(
  onChanged: (value) {
    // Logic search
  },
)

// ✅ Cách mới - Listener linh hoạt hơn
_searchController.addListener(_onSearchChanged);
```

### **2. Tại sao cần 2 danh sách riêng biệt?**

- `_employees`: Giữ nguyên data gốc từ database
- `_filteredEmployees`: Data đã lọc để hiển thị
- Dễ dàng reset về trạng thái ban đầu khi clear search

### **3. setState() hoạt động như thế nào?**

```dart
setState(() {
  _filteredEmployees = searchResults;
});
// Flutter sẽ rebuild widget tree và cập nhật UI
```

### **4. LIKE operator trong SQL**

```sql
-- Tìm chính xác
WHERE name = 'John'

-- Tìm có chứa (khuyên dùng cho search)
WHERE name LIKE '%John%'
```

---

## 🎯 Performance Tips

### **1. Debouncing (Tùy chọn nâng cao)**

```dart
Timer? _debounce;

void _onSearchChanged() {
  if (_debounce?.isActive ?? false) _debounce!.cancel();
  _debounce = Timer(const Duration(milliseconds: 300), () {
    _filterEmployees();
  });
}
```

### **2. Pagination cho data lớn**

```dart
Future<List<Employee>> searchEmployees(String query, {int limit = 50}) async {
  // Thêm LIMIT trong SQL query
}
```

---

## 🚀 Tính Năng Mở Rộng

### **1. Search theo nhiều tiêu chí**

```dart
// Thêm dropdown filter
String _selectedGender = 'All';
String _selectedSkill = 'All';
```

### **2. Search history**

```dart
List<String> _searchHistory = [];
// Lưu vào SharedPreferences
```

### **3. Search suggestions**

```dart
// Auto-complete khi user gõ
List<String> _suggestions = [];
```

---

## 📱 Testing Search Feature

### **Test Cases:**

1. ✅ Search với từ khóa có kết quả
2. ✅ Search với từ khóa không có kết quả
3. ✅ Clear search button
4. ✅ Search rỗng hiển thị tất cả
5. ✅ Search với ký tự đặc biệt
6. ✅ Performance với data lớn

---

## 🔧 Troubleshooting

### **Lỗi thường gặp:**

**1. setState() called after dispose**

```dart
// ✅ Giải pháp
if (mounted) {
  setState(() {
    // Update state
  });
}
```

**2. Memory leak do không dispose controller**

```dart
// ✅ Luôn dispose trong dispose()
@override
void dispose() {
  _searchController.dispose();
  super.dispose();
}
```

**3. Search không hoạt động**

```dart
// ✅ Kiểm tra listener có được add chưa
_searchController.addListener(_onSearchChanged);
```

---

## 📚 Tài Liệu Tham Khảo

- [Flutter TextField Documentation](https://api.flutter.dev/flutter/material/TextField-class.html)
- [SQLite LIKE Operator](https://www.sqlite.org/lang_expr.html#like)
- [Flutter State Management](https://docs.flutter.dev/development/data-and-backend/state-mgmt)

---

**💡 Tip:** Luôn test search feature với data thật và nhiều test cases khác nhau để đảm bảo hoạt động ổn định!
