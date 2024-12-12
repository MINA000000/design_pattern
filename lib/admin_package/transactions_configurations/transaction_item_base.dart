import 'package:flutter/material.dart';

// Abstract class defining a method for building the transaction item
abstract class TransactionItemBase {
  Widget buildItem(BuildContext context, Map transaction);
}
