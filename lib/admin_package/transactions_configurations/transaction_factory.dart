import 'package:design_pattern/admin_package/items/confirmed_transaction_item.dart';
import 'package:design_pattern/admin_package/items/transaction_item.dart';
import 'package:flutter/material.dart';

// Abstract base class or interface for transaction items
abstract class TransactionItemWidget extends StatelessWidget {
  const TransactionItemWidget({Key? key}) : super(key: key);
}

// Factory class to create the appropriate transaction item
class TransactionFactory {
  // Factory method to create different types of transaction items based on status
  static Widget createTransactionItem({
    required Map transaction,
    Function()? onMessageChanged,
  }) {
    final int status = transaction['id_status'] ?? 0;

    switch (status) {
      case TransactionStatus.confirmed:
        return ConfirmedTransactionItem(transaction: transaction);
      case TransactionStatus.unconfirmed:
        return TransactionItem(transaction: transaction, onMessageChanged: onMessageChanged!);
      default:
        throw Exception('Unsupported transaction status: $status');
    }
  }
}

// Status constants or enum for better readability
class TransactionStatus {
  static const int confirmed = 1;
  static const int unconfirmed = 2;
}
