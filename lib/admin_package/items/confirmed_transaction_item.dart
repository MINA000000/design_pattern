import 'package:flutter/material.dart';

import '../../single_data_base.dart';

class ConfirmedTransactionItem extends StatelessWidget {
  Map transaction;
  ConfirmedTransactionItem({required this.transaction});

  Future<List<Map>> fetchData() async {
    String sql = "SELECT * FROM books WHERE id_book=${transaction['id_book']}";
    List<Map> data = await Database.database.readData(sql);
    print(data);
    return data;
  }

  double calcTotalPrice(double priceOfOneBook) {
    double total = transaction['quantity'] * priceOfOneBook;
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Loading state
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Error state
        } else if (snapshot.hasData) {
          Map mydata = snapshot.data![0];
          return Padding(
            padding: EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blue,
              ),
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      Icons.shopping_cart,
                      color: Colors.amber,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(mydata['title']),
                  ),
                  Text(
                    "total : ${calcTotalPrice(mydata['price'])}",
                    style: TextStyle(
                        color: Colors.purple
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      onPressed: null,
                      child: Text(
                        "Confirmed",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.amber),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
          ;
        } else {
          return Text('No data available');
        }
      },
    );
  }
}
