import 'package:flutter/material.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final events = [
      {
        "title": "Medical Biostatistics Revision",
        "subtitle": "Today • 7:00 PM",
        "icon": Icons.menu_book,
        "color": Colors.blue,
      },
      {
        "title": "Research Methods Assignment",
        "subtitle": "Due Tomorrow",
        "icon": Icons.assignment,
        "color": Colors.orange,
      },
      {
        "title": "Epidemiology CAT",
        "subtitle": "Friday • 10:00 AM",
        "icon": Icons.edit_note,
        "color": Colors.green,
      },
      {
        "title": "Mock Quiz",
        "subtitle": "Saturday • Joseph Generated",
        "icon": Icons.quiz,
        "color": Colors.purple,
      },
      {
        "title": "Medical Biostatistics Exam",
        "subtitle": "4 Days Remaining",
        "icon": Icons.school,
        "color": Colors.red,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Study Timeline",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: event["color"] as Color,
                      child: Icon(
                        event["icon"] as IconData,
                        color: Colors.white,
                      ),
                    ),
                    if (index != events.length - 1)
                      Container(
                        width: 3,
                        height: 70,
                        color: Colors.grey.shade300,
                      ),
                  ],
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            event["title"] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            event["subtitle"] as String,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}