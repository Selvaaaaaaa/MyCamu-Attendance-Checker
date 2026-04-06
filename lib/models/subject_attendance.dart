class SubjectAttendance {
  final String subjectCode;
  final String subjectName;
  final int totalClasses;
  final int attendedClasses;
  final double percentage;

  SubjectAttendance({
    required this.subjectCode,
    required this.subjectName,
    required this.totalClasses,
    required this.attendedClasses,
    required this.percentage,
  });

  String get status {
    if (percentage >= 75) return 'Safe';
    if (percentage >= 65) return 'Warning';
    return 'Critical';
  }

  int get classesToSkip {
    if (percentage <= 75) return 0;
    // (Attended) / (Total + X) = 0.75 -> X classes can be skipped
    // Wait, Attended / Total = Current => Attended / (Total + additionalMissed) >= 0.75
    // additionalMissed <= (Attended / 0.75) - Total
    int skippable = ((attendedClasses / 0.75) - totalClasses).floor();
    return skippable > 0 ? skippable : 0;
  }

  int get classesNeededToSafe {
    if (percentage >= 75) return 0;
    // (Attended + X) / (Total + X) >= 0.75
    // Attended + X >= 0.75 * Total + 0.75 * X
    // 0.25 * X >= 0.75 * Total - Attended
    // X >= (0.75 * Total - Attended) / 0.25
    int needed = ((0.75 * totalClasses - attendedClasses) / 0.25).ceil();
    return needed > 0 ? needed : 0;
  }
}
