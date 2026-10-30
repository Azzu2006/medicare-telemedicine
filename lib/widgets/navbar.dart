import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../routes/app_routes.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  final String currentRoute;

  const Navbar({
    super.key,
    required this.currentRoute,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 800;

    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: const Border(
          bottom: BorderSide(color: AppTheme.border, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 32 : 16,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Brand Logo & Tagline
              InkWell(
                onTap: () {
                  if (currentRoute != AppRoutes.home) {
                    Navigator.pushNamed(context, AppRoutes.home);
                  }
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppTheme.primaryBlue, AppTheme.primaryDark],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.medical_services_rounded,
                          color: AppTheme.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Medi',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.primaryBlue,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Care',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.textPrimary,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            'Your Health, Our Priority',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textSecondary,
                              letterSpacing: 0.1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Desktop Navigation Links
              if (isDesktop)
                Row(
                  children: [
                    _buildNavLink(
                      context,
                      title: 'Home',
                      icon: Icons.home_rounded,
                      route: AppRoutes.home,
                    ),
                    const SizedBox(width: 8),
                    _buildNavLink(
                      context,
                      title: 'Doctors',
                      icon: Icons.people_alt_rounded,
                      route: AppRoutes.doctors,
                    ),
                    const SizedBox(width: 8),
                    _buildNavLink(
                      context,
                      title: 'Book Appointment',
                      icon: Icons.calendar_today_rounded,
                      route: AppRoutes.booking,
                    ),
                    const SizedBox(width: 20),
                    // Quick Action Button
                    ElevatedButton.icon(
                      onPressed: () {
                        if (currentRoute != AppRoutes.booking) {
                          Navigator.pushNamed(context, AppRoutes.booking);
                        }
                      },
                      icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                      label: const Text('Book Now'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: AppTheme.white,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                )
              else
                // Mobile quick actions
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.people_alt_rounded, color: AppTheme.primaryBlue),
                      tooltip: 'Doctors',
                      onPressed: () {
                        if (currentRoute != AppRoutes.doctors) {
                          Navigator.pushNamed(context, AppRoutes.doctors);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_month_rounded, color: AppTheme.primaryBlue),
                      tooltip: 'Book',
                      onPressed: () {
                        if (currentRoute != AppRoutes.booking) {
                          Navigator.pushNamed(context, AppRoutes.booking);
                        }
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavLink(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String route,
  }) {
    final isActive = currentRoute == route;

    return InkWell(
      onTap: () {
        if (!isActive) {
          Navigator.pushNamed(context, route);
        }
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.lightBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? AppTheme.primaryBlue : AppTheme.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? AppTheme.primaryBlue : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
