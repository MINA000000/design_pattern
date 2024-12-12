import 'package:flutter/material.dart';
import 'transaction_factory.dart';  // Import the factory
import '../../single_data_base.dart';

class TransactionsConfiguration extends StatefulWidget {
  @override
  State<TransactionsConfiguration> createState() => _TransactionsConfigurationState();
}

class _TransactionsConfigurationState extends State<TransactionsConfiguration> {
  late Future<List<Map>> transactionsFuture;

  @override
  void initState() {
    super.initState();
    transactionsFuture = fetchData();  // Initialize the future to load the transactions
  }

  Future<List<Map>> fetchData() async {
    String sql = "SELECT * FROM transactions WHERE id_status=2";
    List<Map> data = await Database.database.readData(sql);
    return data;
  }

  void refreshTransactions() {
    setState(() {
      transactionsFuture = fetchData(); // Refresh the future with updated data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transactions Configuration"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: FutureBuilder<List<Map>>(
        future: transactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Loading state
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Error state
          } else if (snapshot.hasData) {
            List<Map> mydata = snapshot.data!;
            return ListView.builder(
              itemCount: mydata.length,
              itemBuilder: (context, index) {
                // Use the factory to create the transaction item
                return TransactionFactory.createTransactionItem(mydata[index], refreshTransactions);
              },
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
