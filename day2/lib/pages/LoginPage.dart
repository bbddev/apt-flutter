import 'package:day2/pages/HomePage.dart';
import 'package:flutter/material.dart';

class Loginpage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<Loginpage> {
  var formKey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPass = TextEditingController();
  bool valid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple, // Changed AppBar color
        title: const Text(
          'Login Page',
          style: TextStyle(fontWeight: FontWeight.bold), // Made title bold
        ),
        centerTitle: true, // Centered the title
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0), // Adjusted padding
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centered content vertically
            crossAxisAlignment: CrossAxisAlignment.stretch, // Stretched children horizontally
            children: [
              FlutterLogo(size: 100), // Added a Flutter logo
              SizedBox(height: 48.0), // Added spacing
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: txtEmail,
                  keyboardType: TextInputType.emailAddress, // Added keyboard type for email
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0), // Rounded corners for input field
                    ),
                    prefixIcon: Icon(Icons.email, color: Colors.deepPurple), // Added email icon
                    labelText: 'Enter your email',
                    hintText: 'Your Email',
                  ),
                  validator: (value) { // Added basic email validation
                    String reg = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                    RegExp regExp = RegExp(reg);
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!regExp.hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    valid = true; // Set valid to true if email is valid

                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: TextFormField(
                  controller: txtPass,
                  obscureText: true, // Masked password input
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0), // Rounded corners for input field
                    ),
                    prefixIcon: Icon(Icons.lock, color: Colors.deepPurple), // Added lock icon
                    labelText: 'Enter your password',
                    hintText: 'Your Password',
                  ),
                  validator: (value) { // Added basic password validation
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 3) {
                      return 'Password must be at least 3 characters';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 24.0), // Added spacing
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple, // Changed button color
                    padding: EdgeInsets.symmetric(vertical: 12.0), // Adjusted button padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0), // Rounded corners for button
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      valid = true;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Login Successful')),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    } else {
                      valid = false;
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Login Failed')));
                    }
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 18.0, color: Colors.white), // Styled button text
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
