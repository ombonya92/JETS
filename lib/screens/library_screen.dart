import 'package:flutter/material.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final materials = [
      {
        "title": "Medical Biostatistics Notes",
        "type": "Lecture Notes",
        "icon": Icons.menu_book,
        "color": Colors.blue,
      },
      {
        "title": "Epidemiology Past Paper",
        "type": "Past Paper",
        "icon": Icons.description,
        "color": Colors.red,
      },
      {
        "title": "Research Methods Assignment",
        "type": "Assignment",
        "icon": Icons.assignment,
        "color": Colors.orange,
      },
      {
        "title": "Joseph Summary",
        "type": "AI Summary",
        "icon": Icons.smart_toy,
        "color": Colors.green,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text(
          "My Library",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    "📚 Academic Library",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    "All your notes, summaries, assignments and past papers in one place.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Recent Materials",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: ListView.builder(
                itemCount: materials.length,
                itemBuilder: (context, index) {

                  final item = materials[index];

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: ListTile(

                      leading: CircleAvatar(
                        backgroundColor: item["color"] as Color,
                        child: Icon(
                          item["icon"] as IconData,
                          color: Colors.white,
                        ),
                      ),

                      title: Text(
                        item["title"] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      subtitle: Text(
                        item["type"] as String,
                      ),

                      trailing: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed: () {},
                      ),
                    ),
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}