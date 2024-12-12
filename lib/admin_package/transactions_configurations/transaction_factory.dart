import 'package:design_pattern/admin_package/items/confirmed_transaction_item.dart';
import 'package:design_pattern/admin_package/items/transaction_item.dart';
import 'package:flutter/material.dart';

// Factory class to create the appropriate transaction item
class TransactionFactory {
  // Factory method to create different types of transaction items based on status
  static Widget createTransactionItem(Map transaction, Function() onMessageChanged) {
    if (transaction['id_status'] == 1) {
      // If status is 1, it's a confirmed transaction
      return ConfirmedTransactionItem(transaction: transaction);
    } else {
      // If status is 2, it's an unconfirmed transaction
      return TransactionItem(transaction: transaction, onMessageChanged: onMessageChanged);
    }
  }
}
