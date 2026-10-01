import 'package:flutter/material.dart';

import '../core/app_controller.dart';

class JosephScreen extends StatefulWidget {
  const JosephScreen({super.key});

  @override
  State<JosephScreen> createState() => _JosephScreenState();
}

class _JosephScreenState extends State<JosephScreen> {
  final AppController controller = AppController();

  final TextEditingController questionController =
      TextEditingController();

  void _askJoseph() {
    final question = questionController.text.trim();

    if (question.isEmpty) {
      return;
    }

    final reply = controller.cognitive.respond(question);

    questionController.clear();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Joseph"),
        content: SingleChildScrollView(
          child: Text(reply),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final brain = controller.cognitive.think();

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text(
          "Joseph AI",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(18),
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.smart_toy,
                      color: Colors.blue,
                      size: 34,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          brain["greeting"]?.toString() ??
                              "Hello!",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          brain["insight"]?.toString() ??
                              "I'm ready to help you study.",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 18,
                ),
                children: [
                  Card(
                    elevation: 3,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Learning Status",
                            style: TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),

                          const SizedBox(height: 20),

                          Row(
                            children: [
                              Expanded(
                                child: _statCard(
                                  "Level",
                                  brain["learningLevel"]
                                          ?.toString() ??
                                      "Learning You",
                                  Icons.school,
                                ),
                              ),

                              const SizedBox(width: 15),

                              Expanded(
                                child: _statCard(
                                  "Confidence",
                                  "${brain["confidence"]?.toStringAsFixed(0) ?? "0"}%",
                                  Icons.psychology,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 25),

                          const Text(
                            "Joseph's Assessment",
                            style: TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            brain["insight"]?.toString() ??
                                "Continue studying and asking questions.",
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Quick Actions",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _actionChip(
                        Icons.quiz,
                        "Generate Quiz",
                      ),

                      _actionChip(
                        Icons.summarize,
                        "Summarize Notes",
                      ),

                      _actionChip(
                        Icons.menu_book,
                        "Study Plan",
                      ),

                      _actionChip(
                        Icons.analytics,
                        "Analyze Notes",
                      ),

                      _actionChip(
                        Icons.auto_graph,
                        "Track Progress",
                      ),

                      _actionChip(
                        Icons.psychology_alt,
                        "AI Revision",
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  Container(
                    padding:
                        const EdgeInsets.all(15),
                    decoration:
                        const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller:
                                questionController,
                            onSubmitted: (_) =>
                                _askJoseph(),
                            decoration:
                                InputDecoration(
                              hintText:
                                  "Ask Joseph anything.",
                              filled: true,
                              fillColor:
                                  Colors.grey.shade100,
                              border:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        30),
                                borderSide:
                                    BorderSide.none,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        FloatingActionButton(
                          heroTag:
                              "sendJoseph",
                          mini: true,
                          backgroundColor:
                              Colors.blue,
                          onPressed: _askJoseph,
                          child: const Icon(
                            Icons.send,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius:
            BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.blue,
            size: 30,
          ),

          const SizedBox(height: 10),

          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 5),

          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionChip(
    IconData icon,
    String text,
  ) {
    return ActionChip(
      avatar: Icon(
        icon,
        size: 18,
        color: Colors.blue,
      ),
      label: Text(text),
      onPressed: () {
        questionController.text = text;
        _askJoseph();
      },
    );
  }

  @override
  void dispose() {
    questionController.dispose();
    super.dispose();
  }
}