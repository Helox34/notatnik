import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ProjectColors {
  static const List<Color> available = [
    Color(0xFFFFC107), // Yellow
    Color(0xFF2196F3), // Blue
    Color(0xFF4CAF50), // Green
    Color(0xFFF44336), // Red
    Color(0xFF9C27B0), // Purple
    Color(0xFFFF9800), // Orange
    Color(0xFF009688), // Teal
    Color(0xFFE91E63), // Pink
  ];
}

class ColorPickerDialog extends StatelessWidget {
  final Color selectedColor;

  const ColorPickerDialog({
    super.key,
    required this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Wybierz kolor projektu'),
      content: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: ProjectColors.available.map((color) {
          final isSelected = color.value == selectedColor.value;
          return GestureDetector(
            onTap: () => Navigator.pop(context, color),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(color: AppColors.darkNavy, width: 3)
                    : null,
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                ],
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 30)
                  : null,
            ),
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Anuluj'),
        ),
      ],
    );
  }
}
