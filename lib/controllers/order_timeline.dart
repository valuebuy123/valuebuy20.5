import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderTimeline extends StatelessWidget {
  final String status;
  final List<Map<String, dynamic>> trackingStatus;

  const OrderTimeline({required this.status, this.trackingStatus = const [], super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Use trackingStatus if provided, otherwise create a single status entry
    final List<Map<String, dynamic>> timeline = trackingStatus.isNotEmpty
        ? trackingStatus
        : [
            {'status': status, 'timestamp': DateTime.now()}
          ];

    return Column(
      children: timeline.asMap().entries.map((entry) {
        final index = entry.key;
        final statusEntry = entry.value;
        final isLast = index == timeline.length - 1;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline dot and line
            Column(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent[700],
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: screenHeight * 0.05,
                    color: Colors.orangeAccent[700],
                  ),
              ],
            ),
            SizedBox(width: screenWidth * 0.04),
            // Status and timestamp
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    statusEntry['status'],
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('dd MMM yyyy, hh:mm a').format(statusEntry['timestamp']),
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}