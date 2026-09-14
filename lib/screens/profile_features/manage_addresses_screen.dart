import 'package:flutter/material.dart';
import '../../widgets/account_data_screen.dart';

class ManageAddressesScreen extends StatelessWidget {
  const ManageAddressesScreen({super.key});
  @override
  Widget build(BuildContext context) => const AccountDataScreen(
    title: 'Delivery addresses',
    collection: 'addresses',
    emptyTitle: 'No saved addresses',
    emptyMessage: 'Save delivery locations during checkout for fast, priority dining delivery.',
    icon: Icons.location_on_outlined,
  );
}
