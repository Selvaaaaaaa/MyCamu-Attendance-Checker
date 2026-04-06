import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/attendance_provider.dart';
import '../widgets/register_input.dart';
import '../constants.dart';
import '../theme/app_theme.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceState = ref.watch(attendanceProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              Text(
                AppConstants.loginTitle,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 8),
              Text(
                AppConstants.loginSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: RegisterInput(
                  isLoading: attendanceState.isLoading,
                  onSubmit: (registerNumber) async {
                    await ref.read(attendanceProvider.notifier).fetchAttendance(registerNumber);
                    if (!context.mounted) return;
                    if (ref.read(attendanceProvider).hasValue) {
                       context.go('/detail');
                    } else if (ref.read(attendanceProvider).hasError) {
                       ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(
                           backgroundColor: AppTheme.danger,
                           content: Text('Failed: \${ref.read(attendanceProvider).error}'),
                         )
                       );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
