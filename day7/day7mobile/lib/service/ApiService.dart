import 'package:day7mobile/entities/contact.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static String url = "http://172.16.3.49:9999/api/contacts";
  static Future<List<Contact>> getContacts() async {
    final response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    List<Contact> cList = [];
    for (var item in data) {
      Contact contact = Contact(
        id: item['id'],
        name: item['name'],
        phone: item['phone'],
      );
      cList.add(contact);
      // cList.add(Contact.fromJson(item));
    }
    return cList;
  }

  static Future<Contact> addContact(Contact contact) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(contact.toJson()),
    );
    if (response.statusCode == 201) {
      return Contact.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add contact');
    }
  }

  static Future<bool> deleteContact(int id) async {
    final response = await http.delete(
      Uri.parse('$url/$id'),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Failed to delete contact');
    }
  }

  static Future<Contact> updateContact(Contact contact) async {
    final response = await http.put(
      Uri.parse('$url/${contact.id}'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(contact.toJson()),
    );
    if (response.statusCode == 200) {
      return Contact.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update contact');
    }
  }
}
