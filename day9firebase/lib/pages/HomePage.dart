import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final dbRef = FirebaseDatabase.instance.ref("items");
  final TextEditingController _txtNameController = TextEditingController();
  final TextEditingController _updateNameController = TextEditingController();
  Map<String, dynamic> items = {};

  void addItem(String value) {
    dbRef.push().set(value);
    _txtNameController.clear();
  }

  void deleteItem(String key) {
    dbRef.child(key).remove();
  }

  void updateItem(String key, String value) {
    dbRef.child(key).set(value);
    _updateNameController.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbRef.onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      setState(() {
        items = data != null
            ? data.map((key, value) => MapEntry(key, value.toString()))
            : {};
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: Text(
          'Item Management',
          style: TextStyle(color: Colors.black, fontSize: 28),
        ),
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.all(16)),
          TextField(
            controller: _txtNameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter Item Name',
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.add_circle,
                  color: Colors.blueAccent,
                  size: 32,
                ),
                onPressed: () {
                  addItem(_txtNameController.text);
                },
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(items.values.elementAt(index)),
                  subtitle: Text(items.keys.elementAt(index)),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      deleteItem(items.keys.elementAt(index));
                    },
                  ),
                  onTap: () {
                    _updateNameController.text = items.values.elementAt(index);
                    Dialog alert = Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: _updateNameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Update Item Name',
                              ),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                updateItem(items.keys.elementAt(index), _updateNameController.text);
                                Navigator.of(context).pop();
                              },
                              child: Text('Update'),
                            ),
                          ],
                        ),
                      ),
                    );
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      });
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}