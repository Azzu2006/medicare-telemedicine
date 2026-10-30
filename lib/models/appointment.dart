import 'doctor.dart';

class Appointment {
  final String id;
  final Doctor doctor;
  final String patientName;
  final int patientAge;
  final String patientPhone;
  final String patientEmail;
  final String patientGender;
  final DateTime appointmentDate;
  final String appointmentTime;
  final String consultationType;
  final String symptoms;
  final String reason;
  final String? notes;
  final double fee;
  final DateTime createdAt;

  const Appointment({
    required this.id,
    required this.doctor,
    required this.patientName,
    required this.patientAge,
    required this.patientPhone,
    required this.patientEmail,
    required this.patientGender,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.consultationType,
    required this.symptoms,
    required this.reason,
    this.notes,
    required this.fee,
    required this.createdAt,
  });

  // Sample appointment for safe direct preview or fallback
  static Appointment sample = Appointment(
    id: 'MC-729401',
    doctor: Doctor.sample,
    patientName: 'Alex Morgan',
    patientAge: 29,
    patientPhone: '9876543210',
    patientEmail: 'alex.morgan@example.com',
    patientGender: 'Male',
    appointmentDate: DateTime.now().add(const Duration(days: 1)),
    appointmentTime: '10:30 AM',
    consultationType: 'Video Consultation',
    symptoms: 'Mild chest discomfort, palpitation after workout',
    reason: 'Follow-up consultation for cardiovascular screening',
    notes: 'Previous ECG reports ready for review during call',
    fee: Doctor.sample.consultationFee,
    createdAt: DateTime.now(),
  );
}
