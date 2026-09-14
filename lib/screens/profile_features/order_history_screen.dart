import 'package:flutter/material.dart';
import '../../widgets/account_data_screen.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) => const AccountDataScreen(
    title: 'Dining history',
    collection: 'orders',
    emptyTitle: 'No orders yet',
    emptyMessage: 'Your completed orders and receipts will appear here.',
    icon: Icons.receipt_long_outlined,
  );
}
