import 'package:flutter/material.dart';
import '../../widgets/account_data_screen.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});
  @override
  Widget build(BuildContext context) => const AccountDataScreen(
    title: 'Payment methods',
    collection: 'paymentMethods',
    emptyTitle: 'No payment methods',
    emptyMessage: 'Save your preferred cards and wallets at checkout for 1-tap reordering.',
    icon: Icons.credit_card_outlined,
  );
}
