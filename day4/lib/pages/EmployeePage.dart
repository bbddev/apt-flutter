import 'package:flutter/material.dart';

import '../models/employee.dart';
import '../services/EmployeeService.dart';
import 'HomePage.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  State<StatefulWidget> createState() => EmployeePageState();
}

class EmployeePageState extends State<EmployeePage> {
  final formKey = GlobalKey<FormState>();
  final txtName = TextEditingController();
  final txtSalary = TextEditingController();
  final txtLevel = TextEditingController();

  @override
  void dispose() {
    txtName.dispose();
    txtLevel.dispose();
    txtSalary.dispose();
    super.dispose();
  }

  Future<void> createEmployee() async {
    if (formKey.currentState!.validate()) {
      Employee e = Employee(
        name: txtName.text,
        level: int.parse(txtLevel.text),
        salary: int.parse(txtSalary.text),
      );
      await EmployeeService.addEmployee(e);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Add New Employee',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 25),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: txtName,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: txtLevel,
                decoration: InputDecoration(
                  labelText: 'Level',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter a level' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: txtSalary,
                decoration: InputDecoration(
                  labelText: 'Salary',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter a salary' : null,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: createEmployee,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text('Create Employee', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text('Cancel', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}