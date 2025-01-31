import 'package:flutter/material.dart';

import '../../../../utils/mocks/images/mock_images.dart';

class GlobalAppbarWidget extends StatelessWidget implements PreferredSize {
  const GlobalAppbarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.transparent,
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 4,
            children: [
              Icon(
                Icons.check_box_rounded,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 32,
              ),
              Text(
                'Taski',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade800,
                    ),
              ),
            ],
          ),
          Row(
            spacing: 16,
            children: [
              Text(
                'John',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
              ),
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  MockImages.person,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement child
  Widget get child => throw UnimplementedError();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 20);
}
