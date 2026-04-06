import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/subject_attendance.dart';
import '../services/camu_service.dart';

final camuServiceProvider = Provider<CamuService>((ref) => CamuService());

final attendanceProvider = AsyncNotifierProvider<AttendanceNotifier, List<SubjectAttendance>>(() {
  return AttendanceNotifier();
});

class AttendanceNotifier extends AsyncNotifier<List<SubjectAttendance>> {
  @override
  Future<List<SubjectAttendance>> build() async {
    return [];
  }

  Future<void> fetchAttendance(String registerNumber) async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(camuServiceProvider);
      final data = await service.fetchAttendance(registerNumber);
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  void clearData() {
    state = const AsyncValue.data([]);
  }
}
