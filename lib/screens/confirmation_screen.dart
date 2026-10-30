import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/appointment.dart';
import '../theme/app_theme.dart';
import '../routes/app_routes.dart';
import '../widgets/navbar.dart';
import '../widgets/footer.dart';
import '../widgets/custom_button.dart';

class ConfirmationScreen extends StatelessWidget {
  final Appointment? appointment;

  const ConfirmationScreen({
    super.key,
    this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    final appt = appointment ?? Appointment.sample;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 850;
    final dateFormat = DateFormat('EEEE, MMMM dd, yyyy');

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: const Navbar(currentRoute: AppRoutes.confirmation),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 32 : 16,
                    vertical: 36,
                  ),
                  child: Column(
                    children: [
                      // Top Green Success Badge & Heading
                      _buildSuccessHeader(appt),

                      const SizedBox(height: 28),

                      // Appointment Details Card
                      _buildConfirmationDetailsCard(context, appt, dateFormat, isDesktop),

                      const SizedBox(height: 24),

                      // Preparation & Next Steps Box
                      _buildNextStepsCard(appt),

                      const SizedBox(height: 32),

                      // Navigation Action Buttons
                      _buildActionButtons(context),
                    ],
                  ),
                ),
              ),
            ),

            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessHeader(Appointment appt) {
    return Column(
      children: [
        Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            color: AppTheme.successLight,
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.successGreen.withValues(alpha: 0.3), width: 3),
            boxShadow: [
              BoxShadow(
                color: AppTheme.successGreen.withValues(alpha: 0.18),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.check_circle_rounded,
              color: AppTheme.successGreen,
              size: 52,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Appointment Confirmed!',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Thank you, ${appt.patientName}. Your telemedicine session has been scheduled successfully.',
          style: const TextStyle(
            fontSize: 15,
            color: AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),

        // Booking ID Pill
        Builder(
          builder: (context) {
            return InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: appt.id));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Booking ID ${appt.id} copied to clipboard!'),
                    backgroundColor: AppTheme.primaryBlue,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.lightBlue,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.confirmation_number_outlined, size: 16, color: AppTheme.primaryBlue),
                    const SizedBox(width: 8),
                    Text(
                      'Booking ID: ${appt.id}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryBlue,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.copy_rounded, size: 14, color: AppTheme.primaryBlue),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildConfirmationDetailsCard(
    BuildContext context,
    Appointment appt,
    DateFormat dateFormat,
    bool isDesktop,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isDesktop ? 32 : 20),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Appointment Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.successLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.check_circle_rounded, size: 13, color: AppTheme.successGreen),
                    SizedBox(width: 4),
                    Text(
                      'CONFIRMED',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.successGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(color: AppTheme.borderLight, height: 1),
          const SizedBox(height: 20),

          // Two-column or single column items
          LayoutBuilder(
            builder: (context, constraints) {
              final isTwoCol = constraints.maxWidth >= 600;

              return Column(
                children: [
                  if (isTwoCol) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildDetailField('Patient Name', appt.patientName, icon: Icons.person_rounded)),
                        const SizedBox(width: 24),
                        Expanded(child: _buildDetailField('Doctor Name', appt.doctor.name, icon: Icons.medical_services_rounded)),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildDetailField('Medical Specialization', appt.doctor.specialization, icon: Icons.category_rounded)),
                        const SizedBox(width: 24),
                        Expanded(child: _buildDetailField('Clinical Facility', appt.doctor.hospital, icon: Icons.local_hospital_rounded)),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildDetailField('Appointment Date', dateFormat.format(appt.appointmentDate), icon: Icons.calendar_month_rounded)),
                        const SizedBox(width: 24),
                        Expanded(child: _buildDetailField('Appointment Time', appt.appointmentTime, icon: Icons.access_time_filled_rounded)),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildDetailField('Consultation Type', appt.consultationType, icon: Icons.videocam_rounded)),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _buildDetailField(
                            'Consultation Fee',
                            '\$${appt.fee.toStringAsFixed(0)} (Pay at Consultation / Insurance)',
                            icon: Icons.payments_rounded,
                            valueColor: AppTheme.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildDetailField('Patient Phone', appt.patientPhone, icon: Icons.phone_rounded)),
                        const SizedBox(width: 24),
                        Expanded(child: _buildDetailField('Patient Email', appt.patientEmail, icon: Icons.email_rounded)),
                      ],
                    ),
                  ] else ...[
                    _buildDetailField('Patient Name', appt.patientName, icon: Icons.person_rounded),
                    const SizedBox(height: 14),
                    _buildDetailField('Doctor Name', appt.doctor.name, icon: Icons.medical_services_rounded),
                    const SizedBox(height: 14),
                    _buildDetailField('Medical Specialization', appt.doctor.specialization, icon: Icons.category_rounded),
                    const SizedBox(height: 14),
                    _buildDetailField('Appointment Date', dateFormat.format(appt.appointmentDate), icon: Icons.calendar_month_rounded),
                    const SizedBox(height: 14),
                    _buildDetailField('Appointment Time', appt.appointmentTime, icon: Icons.access_time_filled_rounded),
                    const SizedBox(height: 14),
                    _buildDetailField('Consultation Type', appt.consultationType, icon: Icons.videocam_rounded),
                    const SizedBox(height: 14),
                    _buildDetailField(
                      'Consultation Fee',
                      '\$${appt.fee.toStringAsFixed(0)}',
                      icon: Icons.payments_rounded,
                      valueColor: AppTheme.primaryBlue,
                    ),
                    const SizedBox(height: 14),
                    _buildDetailField('Contact Phone', appt.patientPhone, icon: Icons.phone_rounded),
                    const SizedBox(height: 14),
                    _buildDetailField('Contact Email', appt.patientEmail, icon: Icons.email_rounded),
                  ],

                  if (appt.symptoms.isNotEmpty) ...[
                    const SizedBox(height: 18),
                    const Divider(color: AppTheme.borderLight, height: 1),
                    const SizedBox(height: 18),
                    _buildDetailField(
                      'Reported Symptoms / Reason',
                      '${appt.symptoms} — ${appt.reason}',
                      icon: Icons.notes_rounded,
                    ),
                  ],

                  if (appt.notes != null && appt.notes!.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    _buildDetailField(
                      'Additional Patient Notes',
                      appt.notes!,
                      icon: Icons.edit_note_rounded,
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailField(String label, String value, {required IconData icon, Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.lightBlue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: AppTheme.primaryBlue),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: valueColor ?? AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNextStepsCard(Appointment appt) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.lightBlue.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.info_outline_rounded, color: AppTheme.primaryBlue, size: 20),
              SizedBox(width: 8),
              Text(
                'Next Steps & Telehealth Instructions',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildStepRow(
            '1',
            'A confirmation email and SMS has been sent to ${appt.patientEmail} and ${appt.patientPhone}.',
          ),
          const SizedBox(height: 8),
          _buildStepRow(
            '2',
            'For ${appt.consultationType}, your encrypted meeting link will become active 10 minutes prior to ${appt.appointmentTime}.',
          ),
          const SizedBox(height: 8),
          _buildStepRow(
            '3',
            'Have your prior prescriptions, diagnostic reports, or lab results handy for ${appt.doctor.name}.',
          ),
        ],
      ),
    );
  }

  Widget _buildStepRow(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: AppTheme.primaryBlue,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: const TextStyle(
              color: AppTheme.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textPrimary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 12,
      children: [
        CustomButton(
          text: 'Back to Home',
          icon: Icons.home_rounded,
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.home,
              (route) => false,
            );
          },
        ),
        CustomButton(
          text: 'Book Another Appointment',
          icon: Icons.add_circle_outline_rounded,
          isOutlined: true,
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.doctors);
          },
        ),
      ],
    );
  }
}
