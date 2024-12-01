import 'package:design_pattern/home_page.dart';
import 'package:design_pattern/profile_page.dart';
import 'package:design_pattern/search_page.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  int id_customer;
  HomeScreen({required this.id_customer});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    ProfilePage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome ${widget.id_customer}",style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold,color: Colors.amber),),centerTitle: true,backgroundColor: Colors.blue,),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );

  }
}
