import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isHome;
  final VoidCallback? onBack;
  final VoidCallback? onNotification;
  final VoidCallback? onLogout;

  const CustomAppBar({
    super.key,
    required this.title,
    this.isHome = false,
    this.onBack,
    this.onNotification,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,


      leading: isHome
          ? null
          : IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: onBack ?? () => Navigator.pop(context),
      ),

      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,

      // 🔹 ACTIONS
      actions: [
        if (onNotification != null)
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: onNotification,
          ),

        // 🔥 LOGOUT ONLY FOR HOME
        if (isHome)
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: onLogout,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

