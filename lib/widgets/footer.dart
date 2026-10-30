import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../routes/app_routes.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 800;

    return Container(
      width: double.infinity,
      color: AppTheme.white,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 48 : 24,
        vertical: 40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // Top grid / row
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand column
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryBlue,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.medical_services_rounded,
                                  color: AppTheme.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'MediCare',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.primaryBlue,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Your Health, Our Priority',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Connecting you with certified medical specialists for virtual and in-person consultations. Quality healthcare at your fingertips.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),
                    // Quick Links
                    Expanded(
                      child: _buildFooterSection(
                        context,
                        title: 'Quick Navigation',
                        items: [
                          _FooterLink('Home', () => Navigator.pushNamed(context, AppRoutes.home)),
                          _FooterLink('Find Doctors', () => Navigator.pushNamed(context, AppRoutes.doctors)),
                          _FooterLink('Book Appointment', () => Navigator.pushNamed(context, AppRoutes.booking)),
                        ],
                      ),
                    ),
                    // Specializations
                    Expanded(
                      child: _buildFooterSection(
                        context,
                        title: 'Specialties',
                        items: [
                          _FooterLink('Cardiology', () => Navigator.pushNamed(context, AppRoutes.doctors, arguments: 'Cardiologist')),
                          _FooterLink('Dermatology', () => Navigator.pushNamed(context, AppRoutes.doctors, arguments: 'Dermatologist')),
                          _FooterLink('Neurology', () => Navigator.pushNamed(context, AppRoutes.doctors, arguments: 'Neurologist')),
                          _FooterLink('Pediatrics', () => Navigator.pushNamed(context, AppRoutes.doctors, arguments: 'Pediatrician')),
                        ],
                      ),
                    ),
                    // Emergency notice
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppTheme.lightBlue.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Row(
                              children: [
                                Icon(Icons.emergency_rounded, color: AppTheme.errorRed, size: 18),
                                SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Emergency Notice',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.errorRed,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Text(
                              'If you are experiencing life-threatening symptoms, please call your local emergency service (911/112) immediately.',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppTheme.textSecondary,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              else
                // Mobile stacked footer
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.medical_services_rounded,
                            color: AppTheme.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'MediCare',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Your Health, Our Priority',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.home),
                          child: const Text('Home'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.doctors),
                          child: const Text('Doctors'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.booking),
                          child: const Text('Book'),
                        ),
                      ],
                    ),
                  ],
                ),

              const SizedBox(height: 32),
              const Divider(color: AppTheme.border, height: 1),
              const SizedBox(height: 20),

              // Bottom copyright & badges
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 16,
                runSpacing: 8,
                children: const [
                  Text(
                    '© 2026 MediCare Telemedicine Inc. All rights reserved. HIPAA Compliant.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock_rounded, size: 14, color: AppTheme.successGreen),
                      SizedBox(width: 4),
                      Text(
                        '256-bit SSL Secure',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.successGreen,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooterSection(
    BuildContext context, {
    required String title,
    required List<_FooterLink> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: item.onTap,
              child: Text(
                item.label,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FooterLink {
  final String label;
  final VoidCallback onTap;
  _FooterLink(this.label, this.onTap);
}
