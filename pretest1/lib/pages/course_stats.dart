import 'package:flutter/material.dart';
import '../services/course_service.dart';

class CourseStatsPage extends StatefulWidget {
  const CourseStatsPage({Key? key}) : super(key: key);

  @override
  State<CourseStatsPage> createState() => _CourseStatsPageState();
}

class _CourseStatsPageState extends State<CourseStatsPage> {
  final CourseService _courseService = CourseService();
  int _totalCourses = 0;
  double _totalFees = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final totalCourses = await _courseService.getTotalCourses();
      final totalFees = await _courseService.getTotalFees();

      setState(() {
        _totalCourses = totalCourses;
        _totalFees = totalFees;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading stats: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Statistics'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.school,
                            size: 48,
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Total Courses',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            '$_totalCourses',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.monetization_on,
                            size: 48,
                            color: Colors.green,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Total Fees',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            '\$${_totalFees.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _loadStats,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Refresh Statistics'),
                  ),
                ],
              ),
            ),
    );
  }
}
