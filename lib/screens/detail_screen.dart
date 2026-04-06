import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/attendance_provider.dart';
import '../widgets/stats_row.dart';
import '../widgets/subject_card.dart';
import '../widgets/shimmer_loader.dart';
import '../widgets/error_card.dart';
import '../models/subject_attendance.dart';

class DetailScreen extends ConsumerWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceState = ref.watch(attendanceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(attendanceProvider.notifier).clearData();
            context.go('/home');
          },
        ),
      ),
      body: attendanceState.when(
        data: (subjects) {
          if (subjects.isEmpty) {
            return const Center(child: Text('No data found.'));
          }

          final overallPercentage = _calculateOverall(subjects);
          final safeSubjects = subjects.where((s) => s.status == 'Safe').length;
          final criticalSubjects = subjects.where((s) => s.status == 'Critical').length;

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              StatsRow(
                label1: 'Overall',
                value1: '\${overallPercentage.toStringAsFixed(1)}%',
                label2: 'Total Subjects',
                value2: subjects.length.toString(),
              ),
              const SizedBox(height: 16),
              StatsRow(
                label1: 'Safe',
                value1: safeSubjects.toString(),
                label2: 'Critical',
                value2: criticalSubjects.toString(),
              ),
              const SizedBox(height: 32),
              Text(
                'Subject Wise',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 16),
              ...subjects.map((s) => SubjectCard(subject: s)).toList(),
            ],
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.all(24),
          child: ShimmerLoader(),
        ),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ErrorCard(
              message: err.toString(),
              onRetry: () {
                // If we saved registering reg number we could retry, but here we just go back
                context.go('/home');
              },
            ),
          ),
        ),
      ),
    );
  }

  double _calculateOverall(List<SubjectAttendance> subjects) {
    int total = 0;
    int attended = 0;
    for (var s in subjects) {
      total += s.totalClasses;
      attended += s.attendedClasses;
    }
    return total == 0 ? 0 : (attended / total) * 100;
  }
}
