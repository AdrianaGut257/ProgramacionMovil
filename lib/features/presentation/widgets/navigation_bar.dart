import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:go_router/go_router.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).matchedLocation;

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(color: AppColors.grey, spreadRadius: 1, blurRadius: 5),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            Icons.home,
            currentLocation == '/',
            () => context.go('/'),
          ),
          _buildNavItem(
            Icons.videogame_asset,
            currentLocation == '/record',
            () => context.go('/record'),
          ),
          _buildNavItem(
            Icons.bar_chart,
            currentLocation == '/record',
            () => context.go('/record'),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        size: 30,
        color: isSelected ? AppColors.secondary : AppColors.grey,
      ),
    );
  }
}
