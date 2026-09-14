import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FoodImage extends StatelessWidget {
  final String url;
  final double height;
  const FoodImage({super.key, required this.url, this.height = 180});
  @override
  Widget build(BuildContext context) => Image.network(
    url,
    height: height,
    width: double.infinity,
    fit: BoxFit.cover,
    errorBuilder: (_, error, stack) => Container(
      height: height,
      color: AppTheme.lavender,
      alignment: Alignment.center,
      child: const Icon(
        Icons.restaurant_rounded,
        size: 56,
        color: AppTheme.muted,
      ),
    ),
    loadingBuilder: (_, child, progress) => progress == null
        ? child
        : Container(
            height: height,
            color: AppTheme.lavender,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              color: AppTheme.orange,
            ),
          ),
  );
}

class EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Widget? action;
  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.restaurant_menu,
    this.action,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              color: AppTheme.orange.withValues(alpha: .15),
              borderRadius: BorderRadius.circular(26),
            ),
            child: Icon(icon, size: 36, color: AppTheme.orange),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.muted, height: 1.5),
          ),
          if (action != null) ...[const SizedBox(height: 20), action!],
        ],
      ),
    ),
  );
}
