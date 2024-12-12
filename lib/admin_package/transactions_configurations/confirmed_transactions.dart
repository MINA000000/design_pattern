import 'package:flutter/material.dart';
import '../../single_data_base.dart';
import 'transaction_factory.dart';  // Import the factory

class ConfirmedTransactions extends StatefulWidget {
  @override
  State<ConfirmedTransactions> createState() => _ConfirmedTransactionsState();
}

class _ConfirmedTransactionsState extends State<ConfirmedTransactions> {
  Future<List<Map>> fetchData() async {
    String sql = "SELECT * FROM transactions WHERE id_status=1";
    List<Map> data = await Database.database.readData(sql);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Confirmed Transactions"),
          centerTitle: true,
          backgroundColor: Colors.blueGrey,
        ),
        body: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Loading state
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}'); // Error state
            } else if (snapshot.hasData) {
              List<Map> mydata = snapshot.data!;
              return ListView.builder(
                itemCount: mydata.length,
                itemBuilder: (context, index) {
                  // Use the factory to create the transaction item
                  return TransactionFactory.createTransactionItem(mydata[index], () {});
                },
              );
            } else {
              return Text('No data available');
            }
          },
        ));
  }
}
