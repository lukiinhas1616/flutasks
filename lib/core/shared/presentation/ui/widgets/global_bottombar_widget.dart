import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class GlobalBottomBarWidget extends StatelessWidget {
  const GlobalBottomBarWidget({
    super.key,
    required this.onTap,
    required this.currentIndex,
  });

  final Function(int) onTap;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: (int index) {
        if (index == 0) {
          Modular.to.navigate("/tasks/");
        }
        if (index == 1) onTap(index);
        if (index == 2) {
          Modular.to.navigate("/tasks/search");
        }
        if (index == 3) {
          Modular.to.navigate("/tasks/done");
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.checklist_outlined),
          label: 'Todo',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: 'Create',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_outlined),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.check_box_outlined),
          label: 'Done',
        ),
      ],
    );
  }
}
