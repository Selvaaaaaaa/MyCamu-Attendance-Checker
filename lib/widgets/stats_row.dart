import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StatsRow extends StatelessWidget {
  final String label1;
  final String value1;
  final String label2;
  final String value2;

  const StatsRow({
    Key? key,
    required this.label1,
    required this.value1,
    required this.label2,
    required this.value2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildStatBox(label1, value1, context)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatBox(label2, value2, context)),
      ],
    );
  }

  Widget _buildStatBox(String label, String value, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: 20,
                  color: AppTheme.textPrimary,
                ),
          ),
        ],
      ),
    );
  }
}
