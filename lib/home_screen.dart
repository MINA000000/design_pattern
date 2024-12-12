import 'package:design_pattern/cart_page.dart';
import 'package:design_pattern/home_page.dart';
import 'package:design_pattern/profile/profile_page.dart';
import 'package:design_pattern/search_page.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final int id_customer;
  HomeScreen({required this.id_customer});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // Initialize _pages here since widget is available
    _pages = [
      HomePage(id_customer: widget.id_customer),
      SearchPage(id_Customer: widget.id_customer,),
      ProfilePage(customer_id: widget.id_customer,),
      CartPage( customer_id: 1,),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome ${widget.id_customer}",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.amber,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
        selectedItemColor: Colors.blue, // Color for the selected item
        unselectedItemColor: Colors.grey, // Color for unselected items
        backgroundColor: Colors.white, // Background color of the BottomNavigationBar
      ),
    );
  }
}
