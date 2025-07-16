import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../database/database_helper.dart';

class AddEditEmployeeScreen extends StatefulWidget {
  final Employee? employee;
  final bool isEdit;

  const AddEditEmployeeScreen({Key? key, this.employee, this.isEdit = false})
    : super(key: key);

  @override
  State<AddEditEmployeeScreen> createState() => _AddEditEmployeeScreenState();
}

class _AddEditEmployeeScreenState extends State<AddEditEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _skillController = TextEditingController();

  String _selectedGender = 'Male';
  final List<String> _genders = ['Male', 'Female'];

  final DatabaseHelper _databaseHelper = DatabaseHelper();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.employee != null) {
      _nameController.text = widget.employee!.name;
      _skillController.text = widget.employee!.skill;
      _selectedGender = widget.employee!.gender;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  Future<void> _saveEmployee() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final employee = Employee(
          id: widget.isEdit ? widget.employee!.id : null,
          name: _nameController.text.trim(),
          gender: _selectedGender,
          skill: _skillController.text.trim(),
        );

        if (widget.isEdit) {
          await _databaseHelper.updateEmployee(employee);
        } else {
          await _databaseHelper.insertEmployee(employee);
        }

        if (mounted) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.isEdit
                    ? 'Employee updated successfully!'
                    : 'Employee added successfully!',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Employee' : 'Add Employee'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a name';
                            }
                            if (value.trim().length < 2) {
                              return 'Name must be at least 2 characters';
                            }
                            if (value.trim().length > 30) {
                              return 'Name must not exceed 30 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.people,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Gender',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: _genders.map((gender) {
                                  return Expanded(
                                    child: Row(
                                      children: [
                                        Radio<String>(
                                          value: gender,
                                          groupValue: _selectedGender,
                                          onChanged: (String? value) {
                                            setState(() {
                                              _selectedGender = value!;
                                            });
                                          },
                                          activeColor: Colors.blue,
                                        ),
                                        Text(
                                          gender,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _skillController,
                          decoration: InputDecoration(
                            labelText: 'Skill',
                            prefixIcon: const Icon(Icons.work),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a skill';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveEmployee,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          widget.isEdit ? 'Update Employee' : 'Add Employee',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
