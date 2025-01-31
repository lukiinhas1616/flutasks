import 'package:flutter/material.dart';

class CreateTaskBottomSheet extends StatelessWidget {
  const CreateTaskBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final titleTecController = TextEditingController();
    final descriptionTecController = TextEditingController();
    return Wrap(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: 32,
            left: 32,
            right: 32,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleTecController,
                decoration: InputDecoration(
                  hintText: 'What\'s in your mind?',
                  prefixIcon: Icon(
                    Icons.check_box_outline_blank_rounded,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionTecController,
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Add a note',
                  prefixIcon: Icon(
                    Icons.notes,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop({
                      'title': titleTecController.text,
                      'description': descriptionTecController.text,
                    });
                  },
                  child: const Text('Create'),
                ),
              ),
              SizedBox(
                height: size.height * 0.1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
