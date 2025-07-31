import 'package:daily_cash/src/features/pages/models/transaction_waiter_model.dart';
import 'package:flutter/material.dart';
class WaiterReportWidget extends StatelessWidget {
  const WaiterReportWidget({
    super.key,
    required this.waiter,
  });

  final TransactionWaiterModel waiter;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(
          255,
          100,
          141,
          101,
        ).withOpacity(0.5),
      ),
      child: Row(
        children: [
          Icon(Icons.phone, size: 20),
          SizedBox(width: 10),
          Text("${waiter.merchant}"),
        ],
      ),
    );
  }
}
