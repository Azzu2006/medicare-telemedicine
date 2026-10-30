import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicare_telemedicine/main.dart';
import 'package:medicare_telemedicine/models/doctor.dart';
import 'package:medicare_telemedicine/models/appointment.dart';
import 'package:medicare_telemedicine/screens/doctors_screen.dart';
import 'package:medicare_telemedicine/screens/booking_screen.dart';
import 'package:medicare_telemedicine/screens/confirmation_screen.dart';
import 'package:medicare_telemedicine/theme/app_theme.dart';

void main() {
  testWidgets('MediCare smoke test - renders Home Screen and branding', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const MediCareApp());
    await tester.pumpAndSettle();

    // Verify MediCare branding
    expect(find.text('Your Health, Our Priority'), findsWidgets);
    expect(find.text('Cardiologist'), findsWidgets);
    expect(find.text('Dermatologist'), findsWidgets);
    expect(find.text('Find a Doctor'), findsWidgets);
    expect(find.text('Book Appointment'), findsWidgets);
  });

  testWidgets('Doctors Screen renders and filters doctors', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const MaterialApp(
        themeMode: ThemeMode.light,
        home: DoctorsScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify doctors are displayed
    expect(find.text('Dr. Sarah Jenkins'), findsOneWidget);
    expect(find.text('Dr. Michael Chen'), findsOneWidget);
    expect(find.text('Dr. Priya Patel'), findsOneWidget);

    // Test filter chip tap
    final cardioChip = find.widgetWithText(ChoiceChip, 'Cardiologist');
    expect(cardioChip, findsOneWidget);
    await tester.tap(cardioChip);
    await tester.pumpAndSettle();

    // Sarah Jenkins is a Cardiologist
    expect(find.text('Dr. Sarah Jenkins'), findsOneWidget);
    // Michael Chen is a Neurologist, should not appear under Cardiologist filter
    expect(find.text('Dr. Michael Chen'), findsNothing);
  });

  testWidgets('Booking Screen validates required fields', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const BookingScreen(initialDoctor: Doctor.sample),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Doctor details shown
    expect(find.text('Dr. Sarah Jenkins'), findsWidgets);
    expect(find.text('Confirm Appointment'), findsOneWidget);

    // Tap Confirm Appointment without filling form
    await tester.tap(find.text('Confirm Appointment'));
    await tester.pumpAndSettle();

    // Should show validation error messages
    expect(find.text('Patient full name is mandatory'), findsOneWidget);
    expect(find.text('Age is required'), findsOneWidget);
    expect(find.text('Phone number is mandatory'), findsOneWidget);
    expect(find.text('Email address is mandatory'), findsOneWidget);
  });

  testWidgets('Confirmation Screen renders dynamic appointment details', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final testAppointment = Appointment(
      id: 'MC-998877',
      doctor: Doctor.sample,
      patientName: 'Jane Doe',
      patientAge: 35,
      patientPhone: '9123456789',
      patientEmail: 'jane.doe@example.com',
      patientGender: 'Female',
      appointmentDate: DateTime(2026, 11, 15),
      appointmentTime: '11:45 AM',
      consultationType: 'Video Consultation',
      symptoms: 'Mild headache',
      reason: 'Regular consultation',
      fee: 85.0,
      createdAt: DateTime.now(),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: ConfirmationScreen(appointment: testAppointment),
      ),
    );
    await tester.pumpAndSettle();

    // Verify details
    expect(find.text('Appointment Confirmed!'), findsOneWidget);
    expect(find.text('Booking ID: MC-998877'), findsOneWidget);
    expect(find.text('Jane Doe'), findsOneWidget);
    expect(find.text('Dr. Sarah Jenkins'), findsOneWidget);
    expect(find.text('Cardiologist'), findsOneWidget);
    expect(find.text('11:45 AM'), findsOneWidget);
    expect(find.text('Back to Home'), findsOneWidget);
    expect(find.text('Book Another Appointment'), findsOneWidget);
  });

  testWidgets('Complete end-to-end booking flow across named routes', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const MediCareApp());
    await tester.pumpAndSettle();

    // 1. Navigate from Home to Doctors
    final findDoctorBtn = find.text('Find a Doctor');
    expect(findDoctorBtn, findsOneWidget);
    await tester.tap(findDoctorBtn);
    await tester.pumpAndSettle();

    // Verify on Doctors screen
    expect(find.text('Find & Consult Specialist Doctors'), findsOneWidget);

    // 2. Select first doctor and tap Book Appointment
    final bookDoctorBtns = find.widgetWithText(ElevatedButton, 'Book Appointment');
    expect(bookDoctorBtns, findsWidgets);
    await tester.tap(bookDoctorBtns.first);
    await tester.pumpAndSettle();

    // Verify on Booking screen
    expect(find.text('Schedule Your Consultation'), findsOneWidget);

    // 3. Fill in form
    await tester.enterText(find.widgetWithText(TextFormField, '').first, 'John Smith');
    // Enter age
    await tester.enterText(find.byType(TextFormField).at(1), '30');
    // Enter phone
    await tester.enterText(find.byType(TextFormField).at(2), '9876543210');
    // Enter email
    await tester.enterText(find.byType(TextFormField).at(3), 'john.smith@example.com');
    await tester.pumpAndSettle();

    // 4. Tap Confirm Appointment
    final confirmBtn = find.text('Confirm Appointment');
    expect(confirmBtn, findsOneWidget);
    await tester.tap(confirmBtn);
    await tester.pumpAndSettle();

    // 5. Verify landed on Confirmation screen
    expect(find.text('Appointment Confirmed!'), findsOneWidget);
    expect(find.text('John Smith'), findsOneWidget);
    expect(find.text('9876543210'), findsOneWidget);
  });
}
