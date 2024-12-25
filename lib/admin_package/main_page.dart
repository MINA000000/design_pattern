import 'package:design_pattern/admin_package/InventoryAndStatisticsMonitoring/mainInventory.dart';
import 'package:design_pattern/admin_package/books_configurations/books_configuration.dart';
import 'package:design_pattern/admin_package/categories_configurations/categories_configuration.dart';
import 'package:design_pattern/admin_package/transactions_configurations/confirmed_transactions.dart';
import 'package:design_pattern/admin_package/transactions_configurations/transactions_configuration.dart';
import 'package:design_pattern/login_singup/first_screen.dart';
import 'package:flutter/material.dart';

class MainAdminPage extends StatefulWidget {
  @override
  State<MainAdminPage> createState() => _MainAdminPageState();
}

class _MainAdminPageState extends State<MainAdminPage> {
  int _currentIndex = 0;
   List<Widget> _pages=[
     TransactionsConfiguration(),
     ConfirmedTransactions(),
     Maininventory(),
     BooksConfiguration(),
     CategoriesPage()
   ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Side"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: Icon(Icons.logout,color: Colors.red,),
            onPressed: () {
              // Navigate to the target screen and remove all other screens
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => FirstScreen()),
                    (route) => false, // Remove all routes
              );
            },
          ),
        ],
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
            icon: Icon(Icons.transform),
            label: 'transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.transit_enterexit),
            label: 'confirmed transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Books',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Cagegories',
          ),

        ],
        selectedItemColor: Colors.blue, // Color for the selected item
        unselectedItemColor: Colors.grey, // Color for unselected items
        backgroundColor: Colors.white, // Background color of the BottomNavigationBar
      ),
    );
  }
}
