import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../theme/app_theme.dart';
import '../data/doctor_data.dart';

class DoctorCard extends StatefulWidget {
  final Doctor doctor;
  final VoidCallback onBook;
  final bool isCompact;

  const DoctorCard({
    super.key,
    required this.doctor,
    required this.onBook,
    this.isCompact = false,
  });

  @override
  State<DoctorCard> createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final doc = widget.doctor;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? AppTheme.primaryBlue.withValues(alpha: 0.5)
                : AppTheme.border,
            width: _isHovered ? 1.5 : 1.0,
          ),
          boxShadow: _isHovered ? AppTheme.cardHoverShadow : AppTheme.softShadow,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Row: Avatar + Details
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Doctor Avatar with Status Badge
                Stack(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            doc.avatarColor.withValues(alpha: 0.85),
                            doc.avatarColor,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: doc.avatarColor.withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        doc.initials,
                        style: const TextStyle(
                          color: AppTheme.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: doc.availability.contains('Today')
                              ? AppTheme.successGreen
                              : AppTheme.warningAmber,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                // Doctor Name and Hospital
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              doc.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(
                            Icons.verified_rounded,
                            size: 16,
                            color: AppTheme.primaryBlue,
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        doc.hospital,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      // Specialization Tag
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.lightBlue,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              DoctorData.getSpecializationIcon(doc.specialization),
                              size: 12,
                              color: AppTheme.primaryBlue,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              doc.specialization,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: AppTheme.borderLight, height: 1),
            const SizedBox(height: 10),

            // Middle Stats Row: Experience, Rating, Fee
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem(
                  icon: Icons.work_outline_rounded,
                  label: 'Experience',
                  value: doc.experience,
                ),
                _buildInfoItem(
                  icon: Icons.star_rounded,
                  iconColor: AppTheme.warningAmber,
                  label: 'Rating',
                  value: '${doc.rating} (${doc.reviewCount})',
                ),
                _buildInfoItem(
                  icon: Icons.payments_outlined,
                  label: 'Consultation',
                  value: '\$${doc.consultationFee.toStringAsFixed(0)}',
                  valueColor: AppTheme.primaryBlue,
                ),
              ],
            ),

            if (!widget.isCompact) ...[
              const SizedBox(height: 10),
              // Availability Pill
              Row(
                children: [
                  Icon(
                    Icons.event_available_rounded,
                    size: 14,
                    color: doc.availability.contains('Today')
                        ? AppTheme.successGreen
                        : AppTheme.warningAmber,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    doc.availability,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: doc.availability.contains('Today')
                          ? AppTheme.successGreen
                          : AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 12),
            // Book Appointment Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: widget.onBook,
                icon: const Icon(Icons.calendar_month_rounded, size: 16),
                label: const Text('Book Appointment'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: AppTheme.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    Color? iconColor,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: iconColor ?? AppTheme.textMuted),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: valueColor ?? AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}
