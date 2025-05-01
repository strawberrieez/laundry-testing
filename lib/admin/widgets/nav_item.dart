import 'package:flutter/material.dart';

class NavItem extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback? onTap;

  const NavItem({
    super.key,
    required this.title,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selected,
      selectedTileColor: Colors.deepPurple.withOpacity(0.1),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: selected ? Colors.deepPurple : Colors.black,
        ),
      ),
      onTap: onTap,
    );
  }
}
