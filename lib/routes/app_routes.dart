import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../models/appointment.dart';
import '../screens/home_screen.dart';
import '../screens/doctors_screen.dart';
import '../screens/booking_screen.dart';
import '../screens/confirmation_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String doctors = '/doctors';
  static const String booking = '/booking';
  static const String confirmation = '/confirmation';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const HomeScreen(),
      doctors: (context) {
        final args = ModalRoute.of(context)?.settings.arguments;
        final initialSpecialization = args is String ? args : null;
        return DoctorsScreen(initialSpecialization: initialSpecialization);
      },
      booking: (context) {
        final args = ModalRoute.of(context)?.settings.arguments;
        final selectedDoctor = args is Doctor ? args : null;
        return BookingScreen(initialDoctor: selectedDoctor);
      },
      confirmation: (context) {
        final args = ModalRoute.of(context)?.settings.arguments;
        final appointment = args is Appointment ? args : null;
        return ConfirmationScreen(appointment: appointment);
      },
    };
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
          settings: settings,
        );
      case doctors:
        final initialSpecialization = settings.arguments is String ? settings.arguments as String : null;
        return MaterialPageRoute(
          builder: (context) => DoctorsScreen(initialSpecialization: initialSpecialization),
          settings: settings,
        );
      case booking:
        final initialDoctor = settings.arguments is Doctor ? settings.arguments as Doctor : null;
        return MaterialPageRoute(
          builder: (context) => BookingScreen(initialDoctor: initialDoctor),
          settings: settings,
        );
      case confirmation:
        final appointment = settings.arguments is Appointment ? settings.arguments as Appointment : null;
        return MaterialPageRoute(
          builder: (context) => ConfirmationScreen(appointment: appointment),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
          settings: settings,
        );
    }
  }
}
