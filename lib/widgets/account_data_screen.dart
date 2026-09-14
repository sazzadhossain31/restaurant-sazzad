import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'food_widgets.dart';
import '../theme/app_theme.dart';

/// Displays supplied JSON records without inventing customer information.
class AccountDataScreen extends StatefulWidget {
  final String title;
  final String collection;
  final String emptyTitle;
  final String emptyMessage;
  final IconData icon;
  const AccountDataScreen({
    super.key,
    required this.title,
    required this.collection,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.icon,
  });
  @override
  State<AccountDataScreen> createState() => _AccountDataScreenState();
}

class _AccountDataScreenState extends State<AccountDataScreen> {
  late Future<List<Map<String, dynamic>>> _records;
  @override
  void initState() {
    super.initState();
    _records = _load();
  }

  Future<List<Map<String, dynamic>>> _load() async {
    final data =
        jsonDecode(await rootBundle.loadString('assets/data/account.json'))
            as Map<String, dynamic>;
    return (data[widget.collection] as List)
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.title)),
    body: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _records,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return EmptyState(
                title: 'Unable to load this page',
                message: 'Please try again.',
                action: FilledButton(
                  onPressed: () => setState(() => _records = _load()),
                  child: const Text('Retry'),
                ),
              );
            }
            final records = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Container(
                  padding: const EdgeInsets.all(26),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2A1F00), Color(0xFF1A1A1E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: AppTheme.orange.withValues(alpha: .2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Everything organized in one place.',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: AppTheme.orange,
                          borderRadius: BorderRadius.circular(19),
                        ),
                        child: Icon(
                          widget.icon,
                          color: AppTheme.ink,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                if (records.isEmpty)
                  EmptyState(
                    title: widget.emptyTitle,
                    message: widget.emptyMessage,
                    icon: widget.icon,
                  )
                else
                  ...records.map(
                    (record) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(20),
                          leading: Icon(
                            widget.icon,
                            color: AppTheme.orange,
                          ),
                          title: Text(
                            record['title'] as String? ?? '',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            record['description'] as String? ?? '',
                          ),
                          isThreeLine: false,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    ),
  );
}
