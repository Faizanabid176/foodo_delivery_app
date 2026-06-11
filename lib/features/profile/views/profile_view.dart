import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final user = controller.user;
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            CircleAvatar(
              radius: 44,
              backgroundImage:
                  user?.photoURL == null ? null : NetworkImage(user!.photoURL!),
              child: user?.photoURL == null ? const Icon(Icons.person) : null,
            ),
            const SizedBox(height: 18),
            Text(
              user?.displayName ?? AppStrings.guestUser,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              user?.email ?? AppStrings.noEmail,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: controller.signOut,
              icon: const Icon(Icons.logout),
              label: const Text(AppStrings.signOut),
            ),
          ],
        );
      },
    );
  }
}
