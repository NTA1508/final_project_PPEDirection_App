import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/bottom_navbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late DatabaseReference _userRef;
  Map<String, dynamic>? _userData = {};
  String? uid;

  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();

    checkAdmin();

    final database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://finalprj-92f33-default-rtdb.asia-southeast1.firebasedatabase.app/',
    );

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      uid = user.uid;

      _userRef = database.ref('users/$uid');
      _loadUserData();
    }
  }

  Future<bool> isAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    final userEmail = prefs.getString('email') ?? '';
    //print("this is user email: " + userEmail);
    return userEmail == 'admin@gmail.com';
  }

  void checkAdmin() async {
    bool admin = await isAdmin();
    setState(() {
      _isAdmin = admin;
    });
  }


  void _loadUserData() {
    _userRef.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null && mounted) {
        setState(() {
          _userData = Map<String, dynamic>.from(data as Map);
        });
      }
    });
  }
  String encodeEmail(String email) {
    return email.replaceAll('.', ',');
  }

  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/detection');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/notifications');
        break;
      case 3:
        break;
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login'); // Đường dẫn về login, thay đổi nếu bạn có route khác
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _userData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!_isAdmin)
                  Text("First Name: ${_userData!['firstName'] ?? 'N/A'}", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                if (!_isAdmin)
                  Text("Last Name: ${_userData!['lastName'] ?? 'N/A'}", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                if (!_isAdmin)
                  Text("Email: ${_userData!['email'] ?? 'N/A'}", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                if (!_isAdmin)
                  Text("Age: ${_userData!['age'] ?? 'N/A'}", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                if (!_isAdmin)
                  Text("Position: ${_userData!['position'] ?? 'N/A'}", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                if (!_isAdmin)
                  Text("Building: ${_userData!['building'] ?? 'N/A'}", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                if (!_isAdmin)
                  Text("Floor: ${_userData!['floor'] ?? 'N/A'}", style: TextStyle(fontSize: 18)),
                if (_isAdmin)
                  Text("Position: Admin", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                if (_isAdmin)
                  Text("Email: admin@gmail.com", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                if (_isAdmin)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/add_worker');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Add Management'),
                  ),
                  SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _logout();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Logout'),
                ),

              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
