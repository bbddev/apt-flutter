import 'dart:io';

import 'package:day4/pages/EmployeePage.dart';
import 'package:flutter/material.dart';

import '../models/employee.dart';
import '../services/EmployeeService.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int minSalary = 2000;
  int maxSalary = 7000;
  List<Employee> employees = [];

  @override
  void initState() {
    super.initState();
    findAll();
  }

  Future<void> findAll() async{
    final list = await EmployeeService.getEmployees();
    setState(() {
      employees = list;
    });
  }

  Future<void> filterBySalary(int min, int max) async{
    final list = await EmployeeService.filterBySalary(min, max);
    setState(() {
      employees = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Employee Management',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.deepOrange,
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       Navigator.push(context, MaterialPageRoute(builder: (context) => const EmployeePage()));
        //     },
        //     icon: Icon(Icons.add, color: Colors.blueAccent, size: 35),
        //   ),
        // ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Divider(
              height: 1,
              thickness: 1,
            ),
            Padding(
              padding: EdgeInsets.only(top: 50, left: 40, bottom: 20),
              child: Text('Employee', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Add new', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const EmployeePage()));
              },
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('Search by Name', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const EmployeePage()));
              },
            ),
            Divider(
              height: 1,
              thickness: 3,
            ),
            ListTile(
              leading: Icon(Icons.close),
              title: Text('Close', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              onTap: () {
                exit(0);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.all(15)),
            RangeSlider(
              min: 2000, max: 7000, divisions: 10,
              labels: RangeLabels(minSalary.toString(), maxSalary.toString()),
              values: RangeValues(minSalary.toDouble(), maxSalary.toDouble()),
              onChanged: (value) {
                setState(() {
                  minSalary = value.start.toInt();
                  maxSalary = value.end.toInt();
                  filterBySalary(minSalary, maxSalary);
                });
              }
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(20),
                itemCount: employees.length,
                itemBuilder: (context, index){
                  return ListTile(
                    leading: Icon(Icons.person, size: 60),
                    title: Text(employees[index].name!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                    subtitle: Text('Salary: ${employees[index].salary}', style: TextStyle(fontSize: 20)),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red, size: 30),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirm Deletion'),
                              content: Text('Are you sure you want to delete ${employees[index].name}?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await EmployeeService.deleteEmployee(employees[index].id!);
                                    findAll();
                                    Navigator.of(context).pop();
                                    },
                                  child: Text('Delete', style: TextStyle(color: Colors.red)),
                                ),
                              ],);
                          });},
                    ),
                  );
                }
              )
            ),
          ],
        ),
      ),
    );
  }
}
