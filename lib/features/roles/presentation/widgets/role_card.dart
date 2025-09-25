// lib/features/roles/presentation/widgets/role_card.dart (Fixed)
import 'package:flutter/material.dart';
import '../../domain/entities/user_role.dart';

class RoleCard extends StatelessWidget {
  final UserRoleEntity role;
  final VoidCallback? onTap;
  final bool isSelected;

  const RoleCard({
    super.key,
    required this.role,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 2,
      color: isSelected ? const Color(0xFF667EEA).withOpacity(0.1) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? const BorderSide(color: Color(0xFF667EEA), width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFF667EEA),
                    radius: 20,
                    child: Text(
                      role.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          role.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Level ${role.level}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: role.isActive ? Colors.green : Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      role.isActive ? 'Active' : 'Inactive',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                role.description,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  ...role.permissions.take(3).map((permission) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF667EEA).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        permission.replaceAll('_', ' ').toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF667EEA),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }),
                  if (role.permissions.length > 3)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '+${role.permissions.length - 3} more',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// // lib/features/roles/presentation/widgets/role_card.dart
// import 'package:flutter/material.dart';
// import '../../domain/entities/user_role.dart';

// class RoleCard extends StatelessWidget {
//   final UserRoleEntity role;
//   final VoidCallback? onTap;
//   final bool isSelected;

//   const RoleCard({
//     super.key,
//     required this.role,
//     this.onTap,
//     this.isSelected = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: isSelected ? 4 : 2,
//       color: isSelected ? const Color(0xFF667EEA).withOpacity(0.1) : null,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: isSelected
//             ? const BorderSide(color: Color(0xFF667EEA), width: 2)
//             : BorderSide.none,
//       ),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   CircleAvatar(
//                     backgroundColor: const Color(0xFF667EEA),
//                     radius: 20,
//                     child: Text(
//                       role.name[0].toUpperCase(),
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           role.name,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           'Level ${role.level}',
//                           style: const TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: role.isActive ? Colors.green : Colors.grey,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       role.isActive ? 'Active' : 'Inactive',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 10,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 role.description,
//                 style: const TextStyle(fontSize: 14),
//               ),
//               const SizedBox(height: 12),
//               Wrap(
//                 spacing: 6,
//                 runSpacing: 6,
//                 children: role.permissions.take(3).map((permission) {
//                   return Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF667EEA).withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       permission.replaceAll('_', ' ').toUpperCase(),
//                       style: const TextStyle(
//                         color: Color(0xFF667EEA),
//                         fontSize: 10,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   );
//                 }).toList()
//                   ..add(
//                     role.permissions.length > 3
//                         ? Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 8, vertical: 4),
//                             decoration: BoxDecoration(
//                               color: Colors.grey.withOpacity(0.2),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Text(
//                               '+${role.permissions.length - 3} more',
//                               style: const TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           )
//                         : const SizedBox(),
//                   ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
