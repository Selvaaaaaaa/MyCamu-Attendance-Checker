import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import '../models/subject_attendance.dart';

class CamuService {
  final http.Client _client = http.Client();
  
  // Fake delay to simulate network & parsing time
  Future<List<SubjectAttendance>> fetchAttendance(String registerNumber) async {
    // Note: Since we don't have the real authentication flow or URL for CAMU,
    // this handles fetching the site with a mock or realistic attempt,
    // falling back to mocked data for demonstration in the case of failure.
    
    try {
      // Simulate network request...
      await Future.delayed(const Duration(seconds: 2));
      
      // In a real scenario you would:
      // final response = await _client.post(Uri.parse(AppConstants.apiEndpoint), body: {'regNo': registerNumber});
      // final document = html_parser.parse(response.body);
      // ... querySelectorAll('table.attendance tr')...

      // Return mock data for the sake of the Flutter app UI
      return [
        SubjectAttendance(
          subjectCode: 'CS101',
          subjectName: 'Data Structures and Algorithms',
          totalClasses: 40,
          attendedClasses: 35,
          percentage: (35 / 40) * 100,
        ),
        SubjectAttendance(
          subjectCode: 'MA201',
          subjectName: 'Discrete Mathematics',
          totalClasses: 30,
          attendedClasses: 21,
          percentage: (21 / 30) * 100, // 70%
        ),
        SubjectAttendance(
          subjectCode: 'EC301',
          subjectName: 'Digital Logic Design',
          totalClasses: 45,
          attendedClasses: 20,
          percentage: (20 / 45) * 100, // 44.4%
        ),
        SubjectAttendance(
          subjectCode: 'HU102',
          subjectName: 'Technical Communication',
          totalClasses: 20,
          attendedClasses: 18,
          percentage: (18 / 20) * 100, // 90%
        ),
      ];
    } catch (e) {
      throw Exception('Failed to fetch attendance: \$e');
    }
  }
}
