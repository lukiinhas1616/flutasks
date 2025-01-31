import 'package:flutter/material.dart';

class TaskSearchBarWidget extends StatefulWidget {
  const TaskSearchBarWidget({
    super.key,
    required this.onSearchChanged,
  });

  final Function(String) onSearchChanged;

  @override
  State<TaskSearchBarWidget> createState() => _TaskSearchBarWidgetState();
}

class _TaskSearchBarWidgetState extends State<TaskSearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        onChanged: (v) => widget.onSearchChanged(v),
        decoration: InputDecoration(
          hintText: 'Pesquisar tarefas',
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
