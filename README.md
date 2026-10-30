# MediCare – Telemedicine & Doctor Appointment Application

> **Tagline:** Your Health, Our Priority  
> **Live Web Application:** [https://Azzu2006.github.io/medicare-telemedicine/](https://Azzu2006.github.io/medicare-telemedicine/)

![MediCare Banner](https://img.shields.io/badge/MediCare-Telemedicine-1976D2?style=for-the-badge&logo=flutter&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-3.47+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.13+-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

---

## 🌟 Overview

**MediCare** is a modern, responsive telemedicine and doctor appointment booking web application built with Flutter Web and Material Design 3. It allows patients to browse top-rated medical specialists across key departments, review credentials and consultation fees, book appointments via video, audio, or in-person visits, and receive instant booking confirmations with a unique booking ID.

---

## 🚀 Key Features

* **Healthcare Dashboard (`/`):**
  * Hero search bar with instant search by doctor name or medical specialization.
  * 7 Clinical Specializations: Cardiologist, Dermatologist, Neurologist, Dentist, General Physician, Pediatrician, Orthopedic.
  * Featured top-rated doctors with quick booking navigation.
  * Telehealth benefit cards & trust indicators.
  * Fully responsive navigation for Desktop, Tablet, and Mobile.

* **Doctor Directory (`/doctors`):**
  * 9 realistic, comprehensive specialist doctor profiles with hospitals, ratings, reviews, fees, and real-time availability.
  * Real-time search by name, specialty, and hospital.
  * Specialization filter chips with instant UI updates.
  * Direct appointment booking navigation passing complete doctor arguments.

* **Appointment Booking (`/booking`):**
  * Doctor switcher with live doctor details card.
  * Multi-step appointment preferences: Consultation type (Video, Audio, Clinic Visit), appointment date picker (past dates disabled), and time slot chips.
  * Comprehensive patient form with strict validation:
    * Full Name (mandatory)
    * Age (mandatory, valid range 1–120)
    * Phone Number (mandatory, exact 10 digits)
    * Email Address (mandatory, standard regex)
    * Gender selection
  * Medical symptoms checklist + custom symptom description & consultation reason.
  * Dynamic live booking summary card updating fees in real-time.

* **Booking Confirmation (`/confirmation`):**
  * Green celebratory confirmation badge.
  * Unique generated Booking ID (`MC-XXXXXX`) with one-click clipboard copy.
  * Detailed appointment summary reflecting the patient's submitted details and doctor information.
  * Next-steps instructions & consultation guidelines.
  * Action buttons: "Back to Home" and "Book Another Appointment".

---

## 🎨 Color Palette & Design System

| Role | Color | Hex Code |
| :--- | :--- | :--- |
| **Primary Blue** | Deep Clinical Blue | `#1976D2` |
| **Light Blue** | Background / Accent | `#E3F2FD` |
| **Background** | Clean Slate Gray | `#F8FAFC` |
| **Surface White** | Pure Card Surface | `#FFFFFF` |
| **Success Green** | Confirmation Green | `#2E7D32` |

---

## 🧭 Application Routes

The application uses standard Flutter `MaterialApp` named routes with `Navigator.pushNamed()`:

| Route Name | Path | Description |
| :--- | :--- | :--- |
| **Home** | `/` | Primary landing page and telehealth dashboard |
| **Doctors** | `/doctors` | Complete doctor directory with search and filters |
| **Booking** | `/booking` | Appointment booking form with validation |
| **Confirmation** | `/confirmation` | Dynamic appointment confirmation screen |

*SPA refresh & direct URL navigation are fully supported via `web/404.html` fallback routing.*

---

## 🛠️ Architecture

```
lib/
├── main.dart                       # App entry point & MaterialApp configuration
├── models/
│   ├── doctor.dart                 # Doctor profile data model
│   └── appointment.dart            # Patient appointment data model
├── data/
│   └── doctor_data.dart            # Mock database of 9 specialist doctors
├── screens/
│   ├── home_screen.dart            # Home Screen (Route: /)
│   ├── doctors_screen.dart         # Doctors Directory Screen (Route: /doctors)
│   ├── booking_screen.dart         # Booking Form Screen (Route: /booking)
│   └── confirmation_screen.dart    # Confirmation Screen (Route: /confirmation)
├── widgets/
│   ├── custom_button.dart          # Reusable styled buttons
│   ├── custom_text_field.dart      # Polished form fields with validation
│   ├── doctor_card.dart            # Responsive doctor profile card
│   ├── navbar.dart                 # Responsive desktop & mobile header
│   └── footer.dart                 # Healthcare startup footer with emergency notes
├── routes/
│   └── app_routes.dart             # Named routes & dynamic argument routing
└── theme/
    └── app_theme.dart              # Material Design 3 theme system
```

---

## 🧪 Testing & Code Quality

Run tests locally:
```bash
flutter pub get
flutter analyze
flutter test
```

Build for Flutter Web:
```bash
flutter build web --release --base-href /medicare-telemedicine/
```

---

## 🌐 Deployment to GitHub Pages

Automated CI/CD via GitHub Actions (`.github/workflows/deploy.yml`):
* Triggers automatically on every push to `main`.
* Sets up Flutter SDK, installs dependencies, runs static analysis and unit tests.
* Builds Flutter Web release with `--base-href /medicare-telemedicine/`.
* Deploys directly to GitHub Pages.

---

## 📄 License

This project is licensed under the MIT License.
