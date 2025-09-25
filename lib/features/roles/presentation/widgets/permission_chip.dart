// lib/features/roles/presentation/widgets/permission_chip.dart
import 'package:flutter/material.dart';
import '../../domain/entities/permission.dart';

class PermissionChip extends StatelessWidget {
  final Permission permission;
  final bool isSelected;
  final VoidCallback? onTap;

  const PermissionChip({
    super.key,
    required this.permission,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF667EEA)
              : const Color(0xFF667EEA).withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF667EEA),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getPermissionIcon(permission.category),
              size: 14,
              color: isSelected ? Colors.white : const Color(0xFF667EEA),
            ),
            const SizedBox(width: 6),
            Text(
              permission.name,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF667EEA),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPermissionIcon(String category) {
    switch (category.toLowerCase()) {
      case 'news':
        return Icons.newspaper;
      case 'membership':
        return Icons.people;
      case 'user management':
        return Icons.admin_panel_settings;
      case 'administration':
        return Icons.settings;
      default:
        return Icons.security;
    }
  }
}
