class QuickAction {

  final String title;
  final String icon;

  const QuickAction({
    required this.title,
    required this.icon,
  });

}

const quickActions = [

  QuickAction(
    title: "Upload Notes",
    icon: "upload",
  ),

  QuickAction(
    title: "Generate Quiz",
    icon: "quiz",
  ),

  QuickAction(
    title: "Study Planner",
    icon: "planner",
  ),

  QuickAction(
    title: "Explain Topic",
    icon: "study",
  ),

];