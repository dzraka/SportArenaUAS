import 'package:final_project/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class FieldActionButtons extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;
  const FieldActionButtons({
    super.key,
    required this.isLoading,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrimaryButton(
          text: 'Update Lapangan',
          isLoading: isLoading,
          onPressed: onUpdate,
        ),

        const SizedBox(height: 16),

        PrimaryButton(
          text: 'Hapus Lapangan',
          isLoading: isLoading,
          onPressed: onDelete,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        ),
      ],
    );
  }
}
