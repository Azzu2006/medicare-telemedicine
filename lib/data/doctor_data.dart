import 'package:flutter/material.dart';
import '../models/doctor.dart';

class DoctorData {
  static const List<String> specializations = [
    'Cardiologist',
    'Dermatologist',
    'Neurologist',
    'Dentist',
    'General Physician',
    'Pediatrician',
    'Orthopedic',
  ];

  static const List<Doctor> doctors = [
    Doctor(
      id: 'doc-1',
      name: 'Dr. Sarah Jenkins',
      specialization: 'Cardiologist',
      experience: '14+ Years',
      rating: 4.9,
      reviewCount: 218,
      consultationFee: 85.0,
      availability: 'Available Today',
      hospital: 'Metro Central Heart Institute',
      education: 'MD, FACC - Johns Hopkins University',
      bio: 'Board-certified cardiologist specializing in adult cardiovascular disease, hypertension, non-invasive imaging, and preventive cardiology care.',
      avatarColor: Color(0xFF1976D2),
      availableTimeSlots: [
        '09:00 AM',
        '10:30 AM',
        '11:45 AM',
        '02:00 PM',
        '03:30 PM',
        '05:00 PM',
      ],
    ),
    Doctor(
      id: 'doc-2',
      name: 'Dr. Michael Chen',
      specialization: 'Neurologist',
      experience: '12+ Years',
      rating: 4.8,
      reviewCount: 184,
      consultationFee: 90.0,
      availability: 'Available Today',
      hospital: 'St. Luke Neuro-Sciences Clinic',
      education: 'MD, PhD - Stanford University School of Medicine',
      bio: 'Leading specialist in neurovascular disease, migraine management, peripheral neuropathies, and comprehensive neuro-diagnostic evaluations.',
      avatarColor: Color(0xFF5E35B1),
      availableTimeSlots: [
        '09:30 AM',
        '11:00 AM',
        '01:15 PM',
        '02:45 PM',
        '04:30 PM',
      ],
    ),
    Doctor(
      id: 'doc-3',
      name: 'Dr. Priya Patel',
      specialization: 'Dermatologist',
      experience: '9+ Years',
      rating: 4.9,
      reviewCount: 265,
      consultationFee: 70.0,
      availability: 'Available Today',
      hospital: 'Aura Skin & Aesthetics Center',
      education: 'MD, FAAD - Columbia University',
      bio: 'Expert dermatologist dedicated to treating clinical acne, eczema, psoriasis, hair disorders, and preventative skin cancer screenings.',
      avatarColor: Color(0xFFD81B60),
      availableTimeSlots: [
        '10:00 AM',
        '11:30 AM',
        '01:30 PM',
        '03:00 PM',
        '04:15 PM',
        '05:30 PM',
      ],
    ),
    Doctor(
      id: 'doc-4',
      name: 'Dr. James Wilson',
      specialization: 'Orthopedic',
      experience: '16+ Years',
      rating: 4.8,
      reviewCount: 198,
      consultationFee: 80.0,
      availability: 'Available Tomorrow',
      hospital: 'Mayo Orthopedic & Sports Medicine',
      education: 'MS Ortho - Mayo Clinic College of Medicine',
      bio: 'Renowned orthopedic surgeon specializing in knee and hip joint preservation, sports ligament reconstruction, and acute musculoskeletal trauma.',
      avatarColor: Color(0xFF00897B),
      availableTimeSlots: [
        '08:30 AM',
        '10:00 AM',
        '11:15 AM',
        '02:30 PM',
        '04:00 PM',
      ],
    ),
    Doctor(
      id: 'doc-5',
      name: 'Dr. Elena Rodriguez',
      specialization: 'Pediatrician',
      experience: '10+ Years',
      rating: 5.0,
      reviewCount: 312,
      consultationFee: 65.0,
      availability: 'Available Today',
      hospital: 'Children First Specialty Hospital',
      education: 'MD, FAAP - Boston Children’s Hospital',
      bio: 'Compassionate pediatric consultant providing newborn care, developmental milestone tracking, vaccinations, and adolescent illness guidance.',
      avatarColor: Color(0xFFE65100),
      availableTimeSlots: [
        '09:00 AM',
        '10:15 AM',
        '11:45 AM',
        '01:45 PM',
        '03:15 PM',
        '04:45 PM',
      ],
    ),
    Doctor(
      id: 'doc-6',
      name: 'Dr. David Kim',
      specialization: 'General Physician',
      experience: '13+ Years',
      rating: 4.8,
      reviewCount: 220,
      consultationFee: 50.0,
      availability: 'Available Today',
      hospital: 'Pacific Health Family Clinic',
      education: 'MD - UCLA David Geffen School of Medicine',
      bio: 'Experienced primary care doctor focusing on diabetes management, seasonal viral infections, preventative annual wellness, and telehealth triage.',
      avatarColor: Color(0xFF039BE5),
      availableTimeSlots: [
        '08:00 AM',
        '09:15 AM',
        '10:45 AM',
        '01:00 PM',
        '02:30 PM',
        '04:00 PM',
        '05:15 PM',
      ],
    ),
    Doctor(
      id: 'doc-7',
      name: 'Dr. Olivia Taylor',
      specialization: 'Dentist',
      experience: '8+ Years',
      rating: 4.9,
      reviewCount: 142,
      consultationFee: 75.0,
      availability: 'Available Today',
      hospital: 'BrightSmile Dental Care',
      education: 'DDS - NYU College of Dentistry',
      bio: 'Specialist in dental pain diagnostics, preventative oral care, cosmetic dentistry, and virtual post-operative orthodontic consultations.',
      avatarColor: Color(0xFF00ACC1),
      availableTimeSlots: [
        '09:45 AM',
        '11:15 AM',
        '01:30 PM',
        '03:00 PM',
        '04:30 PM',
      ],
    ),
    Doctor(
      id: 'doc-8',
      name: 'Dr. Robert Marcus',
      specialization: 'Cardiologist',
      experience: '15+ Years',
      rating: 4.7,
      reviewCount: 175,
      consultationFee: 85.0,
      availability: 'Available Tomorrow',
      hospital: 'Penn Medicine Heart Center',
      education: 'MD - Perelman School of Medicine at UPenn',
      bio: 'Senior consultant in cardiovascular health, lipid optimization, heart failure monitoring, and cardiac rehabilitation telemetry.',
      avatarColor: Color(0xFF2E7D32),
      availableTimeSlots: [
        '10:00 AM',
        '11:30 AM',
        '02:00 PM',
        '03:45 PM',
        '05:15 PM',
      ],
    ),
    Doctor(
      id: 'doc-9',
      name: 'Dr. Sophia Martinez',
      specialization: 'Neurologist',
      experience: '11+ Years',
      rating: 4.9,
      reviewCount: 194,
      consultationFee: 95.0,
      availability: 'Available Today',
      hospital: 'Oxford Neuroscience Institute',
      education: 'MD, MRCP - University of Oxford',
      bio: 'Specialized in chronic vertigo, sleep medicine, stroke recovery monitoring, and holistic neurological well-being.',
      avatarColor: Color(0xFF6A1B9A),
      availableTimeSlots: [
        '09:00 AM',
        '10:30 AM',
        '01:00 PM',
        '03:30 PM',
        '05:00 PM',
      ],
    ),
  ];

  static List<Doctor> getFeaturedDoctors() {
    return [doctors[0], doctors[2], doctors[4], doctors[5]];
  }

  static List<Doctor> filterDoctors({String? query, String? specialization}) {
    return doctors.where((doc) {
      final matchesQuery = query == null ||
          query.trim().isEmpty ||
          doc.name.toLowerCase().contains(query.trim().toLowerCase()) ||
          doc.specialization.toLowerCase().contains(query.trim().toLowerCase()) ||
          doc.hospital.toLowerCase().contains(query.trim().toLowerCase());

      final matchesSpecialization = specialization == null ||
          specialization == 'All' ||
          doc.specialization.toLowerCase() == specialization.toLowerCase();

      return matchesQuery && matchesSpecialization;
    }).toList();
  }

  static Doctor getDoctorById(String id) {
    return doctors.firstWhere(
      (doc) => doc.id == id,
      orElse: () => doctors.first,
    );
  }

  static IconData getSpecializationIcon(String spec) {
    switch (spec.toLowerCase()) {
      case 'cardiologist':
        return Icons.favorite_rounded;
      case 'dermatologist':
        return Icons.face_retouching_natural_rounded;
      case 'neurologist':
        return Icons.psychology_rounded;
      case 'dentist':
        return Icons.medical_services_rounded;
      case 'general physician':
        return Icons.health_and_safety_rounded;
      case 'pediatrician':
        return Icons.child_care_rounded;
      case 'orthopedic':
        return Icons.accessibility_new_rounded;
      default:
        return Icons.local_hospital_rounded;
    }
  }
}
