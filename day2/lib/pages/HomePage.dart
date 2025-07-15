import 'package:day2/services/StudentService.dart';
import 'package:flutter/material.dart';
import 'package:day2/pages/AddStudentPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[700], // Dark, professional purple color
        title: const Text(
          'Student Management',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        elevation: 4.0, // Subtle shadow for depth
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0, // Increased padding for better spacing
            vertical: 20.0,  // Increased padding for better spacing
          ),
          color: Colors.purple[50], // Light purple background for contrast
          child: Column(
            children: StudentService.getStudents().map((std) {
              return Card(
                elevation: 2.0, // Subtle shadow for cards
                margin: const EdgeInsets.symmetric(vertical: 8.0), // Spacing between cards
                child: ListTile(
                  leading: CircleAvatar( // More visually appealing than plain text for ID
                    backgroundColor: Colors.deepPurple[400],
                    child: Text(
                      std.id.toString(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    std.name.toString(),
                    style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.redAccent[700]), // Clear action color for icon
                    onPressed: () {
                      StudentService.deleteStudent(std.id!);
                      setState(() {});
                    },
                  ),
                ),
              );
            }).toList(),
          )
        )
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Student',
        onPressed: () async {
          final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddStudentPage()));
          // Nếu trang AddStudent trả về true thì cập nhật lại UI
          if (result == true) {
            setState(() {});
          }
        },
        backgroundColor: Colors.deepPurple[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
