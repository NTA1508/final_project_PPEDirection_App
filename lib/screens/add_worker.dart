import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ppe_detection/firebase_auth_implementmethod/firebase_auth_services.dart';
import 'package:ppe_detection/auth//login.dart';
import 'package:ppe_detection/widgets/form_container_widget.dart';
import 'package:ppe_detection/global/common/toast.dart';
import 'package:firebase_database/firebase_database.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _positionController = TextEditingController();
  TextEditingController _buildingController = TextEditingController();
  TextEditingController _floorController = TextEditingController();

  bool isSigningUp = false;

  @override
  void dispose() {
    _firstnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _positionController.dispose();
    _buildingController.dispose();
    _floorController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign Up",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              FormContainerWidget(
                controller: _firstnameController,
                hintText: "First name",
                isPasswordField: false,
              ),
              SizedBox(height: 10),
              FormContainerWidget(
                controller: _lastNameController,
                hintText: "Last Name",
                isPasswordField: false,
              ),
              SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _emailController,
                hintText: "Email",
                isPasswordField: false,
              ),
              SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _passwordController,
                hintText: "Password",
                isPasswordField: true,
              ),
              SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _ageController,
                hintText: "Age",
                isPasswordField: false,
              ),
              SizedBox(height: 10),
              FormContainerWidget(
                controller: _positionController,
                hintText: "Position",
                isPasswordField: false,
              ),
              SizedBox(height: 10),
              FormContainerWidget(
                controller: _buildingController,
                hintText: "Building",
                isPasswordField: false,
              ),
              SizedBox(height: 10),
              FormContainerWidget(
                controller: _floorController,
                hintText: "Floor",
                isPasswordField: false,
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap:  (){
                  _signUp();

                },
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child: isSigningUp ? CircularProgressIndicator(color: Colors.white,):Text(
                        "Sign Up",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?"),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                                (route) => false);
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    setState(() {
      isSigningUp = true;
    });

    String firstName = _firstnameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String age = _ageController.text.trim();
    String position = _positionController.text.trim();
    String building = _buildingController.text.trim();
    String floor = _floorController.text.trim();

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    setState(() {
      isSigningUp = false;
    });

    if (user != null) {
      final uid = user.uid;
      final dbRef = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: 'https://finalprj-92f33-default-rtdb.asia-southeast1.firebasedatabase.app/',
      ).ref();

      final userRef = dbRef.child("users").child(uid);
      await userRef.set({
        "firstName": firstName,
        "email": email,
        "lastName": lastName,
        "age": age,
        "position": position,
        "building": building,
        "floor": floor,
      });

      showToast(message: "User is successfully created");
      Navigator.pushNamed(context, "/home");
    } else {
      showToast(message: "Some error happened");
    }
  }
}