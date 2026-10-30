import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/doctor.dart';
import '../models/appointment.dart';
import '../data/doctor_data.dart';
import '../theme/app_theme.dart';
import '../routes/app_routes.dart';
import '../widgets/navbar.dart';
import '../widgets/footer.dart';
import '../widgets/custom_text_field.dart';

class BookingScreen extends StatefulWidget {
  final Doctor? initialDoctor;

  const BookingScreen({
    super.key,
    this.initialDoctor,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();

  // Patient Info Controllers
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  String _selectedGender = 'Male';

  // Appointment State
  late Doctor _selectedDoctor;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String? _selectedTimeSlot;
  String _consultationType = 'Video Consultation';

  // Medical Info Controllers
  final _symptomsController = TextEditingController();
  final _reasonController = TextEditingController();
  final _notesController = TextEditingController();

  final List<String> _quickSymptoms = [
    'Fever',
    'Headache',
    'Skin Rash',
    'Chest Pain',
    'Joint Ache',
    'Cough & Cold',
    'Fatigue',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDoctor = widget.initialDoctor ?? DoctorData.doctors.first;
    if (_selectedDoctor.availableTimeSlots.isNotEmpty) {
      _selectedTimeSlot = _selectedDoctor.availableTimeSlots.first;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _symptomsController.dispose();
    _reasonController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onDoctorChanged(Doctor newDoctor) {
    setState(() {
      _selectedDoctor = newDoctor;
      if (newDoctor.availableTimeSlots.isNotEmpty) {
        _selectedTimeSlot = newDoctor.availableTimeSlots.first;
      } else {
        _selectedTimeSlot = null;
      }
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isBefore(now) ? now : _selectedDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryBlue,
              onPrimary: AppTheme.white,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _toggleSymptom(String symptom) {
    final current = _symptomsController.text.trim();
    if (current.isEmpty) {
      _symptomsController.text = symptom;
    } else if (current.contains(symptom)) {
      final list = current.split(',').map((e) => e.trim()).where((e) => e != symptom).toList();
      _symptomsController.text = list.join(', ');
    } else {
      _symptomsController.text = '$current, $symptom';
    }
    setState(() {});
  }

  String _generateBookingId() {
    final randomDigits = 100000 + Random().nextInt(900000);
    return 'MC-$randomDigits';
  }

  void _submitBooking() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please correct the highlighted errors in the form.'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
      return;
    }

    if (_selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an appointment time slot.'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
      return;
    }

    final bookingId = _generateBookingId();

    final appointment = Appointment(
      id: bookingId,
      doctor: _selectedDoctor,
      patientName: _nameController.text.trim(),
      patientAge: int.parse(_ageController.text.trim()),
      patientPhone: _phoneController.text.trim(),
      patientEmail: _emailController.text.trim(),
      patientGender: _selectedGender,
      appointmentDate: _selectedDate,
      appointmentTime: _selectedTimeSlot!,
      consultationType: _consultationType,
      symptoms: _symptomsController.text.trim().isEmpty ? 'General Consultation' : _symptomsController.text.trim(),
      reason: _reasonController.text.trim().isEmpty ? 'Regular health check-up' : _reasonController.text.trim(),
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      fee: _selectedDoctor.consultationFee,
      createdAt: DateTime.now(),
    );

    // Navigate to Confirmation with arguments
    Navigator.pushNamed(
      context,
      AppRoutes.confirmation,
      arguments: appointment,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 950;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: const Navbar(currentRoute: AppRoutes.booking),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Page Header
            _buildPageHeader(isDesktop),

            // Main Content Area
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 32 : 16,
                    vertical: 28,
                  ),
                  child: Form(
                    key: _formKey,
                    child: isDesktop
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left Column: The Form
                              Expanded(
                                flex: 7,
                                child: _buildFormSections(),
                              ),
                              const SizedBox(width: 32),
                              // Right Column: Live Booking Summary
                              Expanded(
                                flex: 5,
                                child: _buildSummaryCard(),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              _buildFormSections(),
                              const SizedBox(height: 32),
                              _buildSummaryCard(),
                            ],
                          ),
                  ),
                ),
              ),
            ),

            // Footer
            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildPageHeader(bool isDesktop) {
    return Container(
      width: double.infinity,
      color: AppTheme.white,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 48 : 20,
        vertical: 28,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.home),
                    child: const Text('Home', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                  ),
                  const Text('  /  ', style: TextStyle(color: AppTheme.textMuted)),
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.doctors),
                    child: const Text('Doctors', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                  ),
                  const Text('  /  ', style: TextStyle(color: AppTheme.textMuted)),
                  const Text(
                    'Book Appointment',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Schedule Your Consultation',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Fill in the patient details and appointment preferences below to reserve your slot.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormSections() {
    return Column(
      children: [
        // 1. Doctor Selection Card
        _buildDoctorSelectionCard(),

        const SizedBox(height: 24),

        // 2. Appointment Preferences (Date, Time, Mode)
        _buildAppointmentPreferencesCard(),

        const SizedBox(height: 24),

        // 3. Patient Details Card
        _buildPatientDetailsCard(),

        const SizedBox(height: 24),

        // 4. Medical Notes & Symptoms
        _buildMedicalInfoCard(),
      ],
    );
  }

  Widget _buildDoctorSelectionCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
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
                'Selected Specialist',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              // Dropdown to switch doctor
              PopupMenuButton<Doctor>(
                tooltip: 'Change Doctor',
                onSelected: _onDoctorChanged,
                itemBuilder: (context) {
                  return DoctorData.doctors.map((doc) {
                    return PopupMenuItem<Doctor>(
                      value: doc,
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: doc.avatarColor.withValues(alpha: 0.2),
                            radius: 14,
                            child: Text(
                              doc.initials,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: doc.avatarColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doc.name,
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                ),
                                Text(
                                  '${doc.specialization} • \$${doc.consultationFee.toStringAsFixed(0)}',
                                  style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.lightBlue,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.swap_horiz_rounded, size: 16, color: AppTheme.primaryBlue),
                      SizedBox(width: 6),
                      Text(
                        'Change Doctor',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _selectedDoctor.avatarColor.withValues(alpha: 0.85),
                      _selectedDoctor.avatarColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Text(
                  _selectedDoctor.initials,
                  style: const TextStyle(
                    color: AppTheme.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedDoctor.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_selectedDoctor.specialization} • ${_selectedDoctor.hospital}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 16, color: AppTheme.warningAmber),
                        const SizedBox(width: 4),
                        Text(
                          '${_selectedDoctor.rating} (${_selectedDoctor.reviewCount} reviews)',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Fee: \$${_selectedDoctor.consultationFee.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentPreferencesCard() {
    final dateFormat = DateFormat('EEE, MMM dd, yyyy');

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Appointment Preferences',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 20),

          // 1. Consultation Mode Selection
          const Text(
            'Consultation Type',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildConsultationTypeOption(
                'Video Consultation',
                Icons.videocam_rounded,
                'Secure HD Video',
              ),
              const SizedBox(width: 12),
              _buildConsultationTypeOption(
                'Audio Consultation',
                Icons.phone_in_talk_rounded,
                'Direct Phone/VoIP',
              ),
              const SizedBox(width: 12),
              _buildConsultationTypeOption(
                'In-person Consultation',
                Icons.business_rounded,
                'Clinic Visit',
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 2. Date Selection
          const Text(
            'Appointment Date',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: _pickDate,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.border),
                borderRadius: BorderRadius.circular(12),
                color: AppTheme.white,
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month_rounded, color: AppTheme.primaryBlue, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      dateFormat.format(_selectedDate),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  const Text(
                    'Change Date',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 3. Time Slot Selection
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Available Time Slots',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
              ),
              Text(
                'Time Zone: Local',
                style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _selectedDoctor.availableTimeSlots.map((slot) {
              final isSelected = _selectedTimeSlot == slot;
              return ChoiceChip(
                label: Text(slot),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _selectedTimeSlot = slot);
                  }
                },
                selectedColor: AppTheme.primaryBlue,
                backgroundColor: AppTheme.white,
                labelStyle: TextStyle(
                  color: isSelected ? AppTheme.white : AppTheme.textPrimary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 13,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected ? AppTheme.primaryBlue : AppTheme.border,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildConsultationTypeOption(String title, IconData icon, String subtitle) {
    final isSelected = _consultationType == title;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _consultationType = title),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.lightBlue : AppTheme.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppTheme.primaryBlue : AppTheme.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? AppTheme.primaryBlue : AppTheme.textSecondary,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                title.replaceAll(' Consultation', ''),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? AppTheme.primaryBlue : AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected ? AppTheme.primaryBlue : AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Patient Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 20),

          // Full Name
          CustomTextField(
            label: 'Full Name *',
            hint: 'e.g. Alex Morgan',
            controller: _nameController,
            prefixIcon: Icons.person_outline_rounded,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Patient full name is mandatory';
              }
              if (value.trim().length < 2) {
                return 'Name must be at least 2 characters long';
              }
              return null;
            },
          ),

          const SizedBox(height: 18),

          // Age and Gender Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Age Field
              Expanded(
                flex: 4,
                child: CustomTextField(
                  label: 'Age *',
                  hint: 'e.g. 32',
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.cake_outlined,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Age is required';
                    }
                    final age = int.tryParse(value.trim());
                    if (age == null || age < 1 || age > 120) {
                      return 'Enter valid age (1-120)';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              // Gender Selector
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Gender *',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedGender,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(value: 'Male', child: Text('Male')),
                            DropdownMenuItem(value: 'Female', child: Text('Female')),
                            DropdownMenuItem(value: 'Other', child: Text('Other')),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedGender = val);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Phone Number (exact 10 digits validation)
          CustomTextField(
            label: 'Phone Number (10 digits) *',
            hint: 'e.g. 9876543210',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            prefixIcon: Icons.phone_outlined,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Phone number is mandatory';
              }
              final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
              if (digitsOnly.length != 10) {
                return 'Phone number must contain exactly 10 digits';
              }
              return null;
            },
          ),

          const SizedBox(height: 18),

          // Email
          CustomTextField(
            label: 'Email Address *',
            hint: 'e.g. alex.morgan@example.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email address is mandatory';
              }
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value.trim())) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalInfoCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Medical Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Quick Symptom Chips
          const Text(
            'Quick select common symptoms:',
            style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _quickSymptoms.map((symptom) {
              final isIncluded = _symptomsController.text.contains(symptom);
              return FilterChip(
                label: Text(symptom),
                selected: isIncluded,
                onSelected: (_) => _toggleSymptom(symptom),
                selectedColor: AppTheme.lightBlue,
                checkmarkColor: AppTheme.primaryBlue,
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: isIncluded ? FontWeight.w600 : FontWeight.normal,
                  color: isIncluded ? AppTheme.primaryBlue : AppTheme.textPrimary,
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Symptoms input
          CustomTextField(
            label: 'Symptoms Experienced',
            hint: 'Describe primary symptoms (e.g. Mild chest tightness, fever)',
            controller: _symptomsController,
            prefixIcon: Icons.healing_outlined,
          ),

          const SizedBox(height: 16),

          // Reason for Consultation
          CustomTextField(
            label: 'Reason for Consultation',
            hint: 'e.g. Routine follow-up, second opinion on test reports',
            controller: _reasonController,
            prefixIcon: Icons.notes_rounded,
          ),

          const SizedBox(height: 16),

          // Additional Notes (optional)
          CustomTextField(
            label: 'Additional Notes (Optional)',
            hint: 'Any allergies, past medication, or questions for the doctor...',
            controller: _notesController,
            maxLines: 3,
            prefixIcon: Icons.edit_note_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final dateFormat = DateFormat('EEE, MMM dd, yyyy');

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.receipt_long_rounded, color: AppTheme.primaryBlue, size: 22),
              SizedBox(width: 8),
              Text(
                'Booking Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppTheme.borderLight, height: 1),
          const SizedBox(height: 16),

          // Doctor summary item
          _buildSummaryRow(
            'Doctor',
            _selectedDoctor.name,
            subtitle: _selectedDoctor.specialization,
          ),

          const SizedBox(height: 14),

          // Date & Time
          _buildSummaryRow(
            'Date & Time',
            dateFormat.format(_selectedDate),
            subtitle: _selectedTimeSlot ?? 'Select a time slot',
          ),

          const SizedBox(height: 14),

          // Consultation Type
          _buildSummaryRow(
            'Consultation Mode',
            _consultationType,
          ),

          const SizedBox(height: 14),

          // Hospital / Clinic
          _buildSummaryRow(
            'Clinical Affiliate',
            _selectedDoctor.hospital,
          ),

          const SizedBox(height: 16),
          const Divider(color: AppTheme.borderLight, height: 1),
          const SizedBox(height: 16),

          // Fee breakdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Consultation Fee', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
              Text('\$${_selectedDoctor.consultationFee.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Platform & Booking Fee', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
              Text('FREE', style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.successGreen, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: AppTheme.border, height: 1),
          const SizedBox(height: 14),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Payable',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                '\$${_selectedDoctor.consultationFee.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primaryBlue,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Confirm Appointment CTA Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _submitBooking,
              icon: const Icon(Icons.check_circle_outline_rounded, size: 20),
              label: const Text('Confirm Appointment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: AppTheme.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Trust assurance badge
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: const [
              Icon(Icons.shield_outlined, size: 15, color: AppTheme.textSecondary),
              SizedBox(width: 6),
              Text(
                '100% Free Cancellation before 2 hours',
                style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {String? subtitle}) {
    return Column(
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
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
