import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/image_fullscreen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late DatabaseReference _violationRef;
  int _itemsToShow = 7;
  bool _isLoadingMore = false;
  late ScrollController _scrollController;



  @override
  void initState() {
    super.initState();

    final database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://finalprj-92f33-default-rtdb.asia-southeast1.firebasedatabase.app/',
    );
    _violationRef = database.ref('violations');

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });

      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _itemsToShow += 7;
          _isLoadingMore = false;
        });
      });
    }
  }


  int _selectedIndex = 2;

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

        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Safety Violations"),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: _violationRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            final data = Map<String, dynamic>.from(
              snapshot.data!.snapshot.value as Map,
            );

            final violations = data.entries.toList()
              ..sort((a, b) => b.value['timestamp'].compareTo(a.value['timestamp']));
            return ListView.builder(
              controller: _scrollController,
              itemCount: (_itemsToShow > violations.length)
                  ? violations.length
                  : _itemsToShow + 1,
                itemBuilder: (context, index) {
                  if (index >= violations.length || index >= _itemsToShow) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final item = violations[index].value;
                  final List<dynamic> missingPPE = item['missing_ppe'] ?? [];
                  final String timestamp = item['timestamp'] ?? '';
                  final String imageUrl = item['image_url'] ?? '';

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      onTap: () {
                        if (imageUrl.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenImagePage(imageUrl: imageUrl),
                            ),
                          );
                        }
                      },
                      contentPadding: const EdgeInsets.all(12),
                      title: Text("Missing: ${missingPPE.join(', ')}", style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("Time: $timestamp"),
                      leading: imageUrl.isNotEmpty
                          ? Image.network(imageUrl, width: 60, height: 60, fit: BoxFit.cover)
                          : const Icon(Icons.warning, color: Colors.red),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          final violationKey = violations[index].key;
                          _violationRef.child(violationKey).remove();
                        },
                      ),
                    ),
                  );
                },
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text("Đã xảy ra lỗi."));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
