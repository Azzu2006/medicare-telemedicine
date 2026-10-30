import 'package:flutter/material.dart';

class Doctor {
  final String id;
  final String name;
  final String specialization;
  final String experience;
  final double rating;
  final int reviewCount;
  final double consultationFee;
  final String availability;
  final String hospital;
  final String education;
  final String bio;
  final Color avatarColor;
  final List<String> availableTimeSlots;

  const Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.experience,
    required this.rating,
    required this.reviewCount,
    required this.consultationFee,
    required this.availability,
    required this.hospital,
    required this.education,
    required this.bio,
    required this.avatarColor,
    required this.availableTimeSlots,
  });

  String get initials {
    final parts = name.replaceAll('Dr. ', '').trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts.isNotEmpty && parts[0].isNotEmpty ? parts[0][0].toUpperCase() : 'DR';
  }

  // Fallback / default doctor instance
  static const Doctor sample = Doctor(
    id: 'doc-1',
    name: 'Dr. Sarah Jenkins',
    specialization: 'Cardiologist',
    experience: '14+ Years',
    rating: 4.9,
    reviewCount: 210,
    consultationFee: 85.0,
    availability: 'Available Today',
    hospital: 'Metro Central Heart Institute',
    education: 'MD, FACC - Johns Hopkins University',
    bio: 'Renowned clinical cardiologist with over 14 years of practice managing hypertensive heart disease, arrhythmias, and preventative cardiovascular health.',
    avatarColor: Color(0xFF1976D2),
    availableTimeSlots: [
      '09:00 AM',
      '10:30 AM',
      '11:45 AM',
      '02:00 PM',
      '03:30 PM',
      '05:00 PM',
    ],
  );
}
