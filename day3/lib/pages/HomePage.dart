import 'package:day3/services/SubjectService.dart';
import 'package:day3/models/subject.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Subject> allSubjects = [];
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _feeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    findAll();
  }

  Future<void> findAll() async {
    final loadSubjects = await SubjectService.getSubjects();
    setState(() {
      allSubjects = loadSubjects;
    });
  }

  Future<void> searchByName(String name) async {
    final result = await SubjectService.searchByName(name);
    setState(() {
      allSubjects = result;
    });
  }

  Future<void> addSubject() async {
    if (_codeController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _feeController.text.isEmpty)
      return;
    final subject = Subject(
      code: _codeController.text,
      name: _nameController.text,
      fee: double.tryParse(_feeController.text) ?? 0,
    );
    await SubjectService.saveSubject(subject);
    _codeController.clear();
    _nameController.clear();
    _feeController.clear();
    findAll();
  }

  Future<void> deleteSubject(String code) async {
    await SubjectService.deleteSubject(code);
    findAll();
  }

  Future<void> updateSubject(Subject subject) async {
    await SubjectService.updateSubject(subject);
    findAll();
  }

  Future<void> getSubjectByCode(String code) async {
    final subject = await SubjectService.getSubjectByCode(code);
    if (subject != null) {
      setState(() {
        allSubjects = [subject];
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Không tìm thấy môn học!')));
    }
  }

  Future<void> deleteAllSubjects() async {
    await SubjectService.deleteAllSubjects();
    findAll();
  }

  void showEditDialog(Subject subject) {
    _codeController.text = subject.code.toString();
    _nameController.text = subject.name.toString();
    _feeController.text = subject.fee.toString();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sửa môn học'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Tên'),
            ),
            TextField(
              controller: _feeController,
              decoration: const InputDecoration(labelText: 'Học phí'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final updated = Subject(
                code: subject.code,
                name: _nameController.text,
                fee: double.tryParse(_feeController.text) ?? 0,
              );
              updateSubject(updated);
              Navigator.pop(context);
            },
            child: const Text('Lưu'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
        ],
      ),
    );
  }

  void showAddDialog() {
    _codeController.clear();
    _nameController.clear();
    _feeController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm môn học mới'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: 'Mã'),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Tên'),
            ),
            TextField(
              controller: _feeController,
              decoration: const InputDecoration(labelText: 'Học phí'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              addSubject();
              Navigator.pop(context);
            },
            child: const Text('Thêm'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Hủy'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[700],
        title: const Text(
          'Home Page',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
        elevation: 4.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Xóa tất cả',
            onPressed: deleteAllSubjects,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Tìm kiếm theo tên',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => searchByName(_searchController.text),
                ),
                IconButton(icon: const Icon(Icons.refresh), onPressed: findAll),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: allSubjects.length,
              itemBuilder: (context, index) {
                final subject = allSubjects[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  elevation: 2.0,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepPurple[100],
                      child: Text(
                        subject.code![0].toUpperCase(),
                        style: TextStyle(
                          color: Colors.deepPurple[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      subject.name.toString(),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text('Code: ${subject.code}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '\$${subject.fee?.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () => showEditDialog(subject),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteSubject(subject.code!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        tooltip: 'Thêm môn học',
        child: const Icon(Icons.add),
      ),
    );
  }
}
