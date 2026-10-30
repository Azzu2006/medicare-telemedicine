import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/doctor_data.dart';
import '../routes/app_routes.dart';
import '../widgets/navbar.dart';
import '../widgets/footer.dart';
import '../widgets/doctor_card.dart';
import '../widgets/custom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _currentBottomNavIndex = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearchSubmit(String query) {
    if (query.trim().isNotEmpty) {
      Navigator.pushNamed(
        context,
        AppRoutes.doctors,
        arguments: query.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;
    final isTablet = screenWidth >= 600 && screenWidth < 900;
    final featuredDoctors = DoctorData.getFeaturedDoctors();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: const Navbar(currentRoute: AppRoutes.home),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Banner Section
            _buildHeroSection(isDesktop, isTablet),

            // Quick Stats Bar
            _buildStatsBar(isDesktop),

            // Center Content
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 32 : 16,
                    vertical: 36,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Medical Specializations Section
                      _buildSpecializationsSection(isDesktop, isTablet),

                      const SizedBox(height: 48),

                      // Featured Doctors Section
                      _buildFeaturedDoctorsSection(isDesktop, isTablet, featuredDoctors),

                      const SizedBox(height: 48),

                      // Why Choose MediCare Section
                      _buildWhyChooseSection(isDesktop, isTablet),

                      const SizedBox(height: 48),

                      // Appointment Call To Action Banner
                      _buildCtaBanner(isDesktop),
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            const Footer(),
          ],
        ),
      ),
      bottomNavigationBar: isDesktop
          ? null
          : BottomNavigationBar(
              currentIndex: _currentBottomNavIndex,
              selectedItemColor: AppTheme.primaryBlue,
              unselectedItemColor: AppTheme.textSecondary,
              backgroundColor: AppTheme.white,
              onTap: (index) {
                setState(() => _currentBottomNavIndex = index);
                if (index == 1) {
                  Navigator.pushNamed(context, AppRoutes.doctors);
                } else if (index == 2) {
                  Navigator.pushNamed(context, AppRoutes.booking);
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people_alt_rounded),
                  label: 'Doctors',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month_rounded),
                  label: 'Book',
                ),
              ],
            ),
    );
  }

  Widget _buildHeroSection(bool isDesktop, bool isTablet) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightBlue.withValues(alpha: 0.9),
            AppTheme.background,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 48 : 20,
        vertical: isDesktop ? 54 : 32,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Row(
            children: [
              Expanded(
                flex: isDesktop ? 6 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.verified_user_rounded, size: 16, color: AppTheme.primaryBlue),
                          SizedBox(width: 6),
                          Text(
                            'Trusted Healthcare Network • 100% Certified Doctors',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Main Title
                    Text(
                      'Your Health, Our Priority.\nCare You Can Trust, Anywhere.',
                      style: TextStyle(
                        fontSize: isDesktop ? 44 : 28,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                        height: 1.15,
                        letterSpacing: -0.8,
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Subtitle
                    Text(
                      'Consult top-ranked specialists online via secure video, audio, or in-clinic visits. Quick appointments, zero waiting rooms, and transparent pricing.',
                      style: TextStyle(
                        fontSize: isDesktop ? 16 : 14,
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Search Doctor Bar
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: AppTheme.softShadow,
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Icon(Icons.search_rounded, color: AppTheme.primaryBlue, size: 24),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onSubmitted: _handleSearchSubmit,
                              decoration: const InputDecoration(
                                hintText: 'Search by doctor name or specialty (e.g. Cardiologist)...',
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _handleSearchSubmit(_searchController.text),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryBlue,
                              foregroundColor: AppTheme.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: isDesktop ? 24 : 16,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.search, size: 18),
                                if (isDesktop) ...[
                                  const SizedBox(width: 8),
                                  const Text('Search Doctors'),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    // Quick Action Buttons
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        CustomButton(
                          text: 'Find a Doctor',
                          icon: Icons.people_alt_rounded,
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.doctors),
                        ),
                        CustomButton(
                          text: 'Book Appointment',
                          icon: Icons.calendar_today_rounded,
                          isOutlined: true,
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.booking),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (isDesktop) ...[
                const SizedBox(width: 48),
                // Decorative Healthcare Illustration Card
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: AppTheme.softShadow,
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppTheme.lightBlue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.health_and_safety_rounded,
                            size: 44,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          '24/7 Telehealth Access',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Connect with verified doctors within 15 minutes. Secure e-prescriptions, lab referrals, and medical notes delivered directly to your device.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 12,
                          runSpacing: 8,
                          children: const [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle_rounded, color: AppTheme.successGreen, size: 18),
                                SizedBox(width: 6),
                                Text('Encrypted Consultation', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle_rounded, color: AppTheme.successGreen, size: 18),
                                SizedBox(width: 6),
                                Text('Instant Booking', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsBar(bool isDesktop) {
    return Container(
      width: double.infinity,
      color: AppTheme.white,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Wrap(
            alignment: WrapAlignment.spaceAround,
            spacing: 24,
            runSpacing: 16,
            children: [
              _buildStatItem('150+', 'Certified Specialists', Icons.verified_user_rounded),
              _buildStatItem('50,000+', 'Happy Consultations', Icons.favorite_rounded),
              _buildStatItem('4.9 / 5', 'Average Patient Rating', Icons.star_rounded),
              _buildStatItem('24 / 7', 'Instant Telehealth Triage', Icons.access_time_filled_rounded),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String number, String label, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.lightBlue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.primaryBlue, size: 22),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              number,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSpecializationsSection(bool isDesktop, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Medical Specializations',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Explore experienced specialists across all major clinical departments',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            TextButton.icon(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.doctors),
              icon: const Text('View All', style: TextStyle(fontWeight: FontWeight.w700)),
              label: const Icon(Icons.arrow_forward_rounded, size: 16),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Grid of specializations
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth >= 900
                ? 4
                : (constraints.maxWidth >= 550 ? 3 : 2);

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: DoctorData.specializations.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.7,
              ),
              itemBuilder: (context, index) {
                final spec = DoctorData.specializations[index];
                final icon = DoctorData.getSpecializationIcon(spec);

                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.doctors,
                      arguments: spec,
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.border),
                      boxShadow: AppTheme.softShadow,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppTheme.lightBlue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(icon, color: AppTheme.primaryBlue, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                spec,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Available Today',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.successGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildFeaturedDoctorsSection(bool isDesktop, bool isTablet, List featuredDoctors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Top Rated Doctors',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Book appointments directly with highly recommended medical practitioners',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.doctors),
              icon: const Icon(Icons.people_alt_outlined, size: 16),
              label: const Text('See All Doctors'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightBlue,
                foregroundColor: AppTheme.primaryBlue,
                elevation: 0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Responsive grid of featured doctors
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth >= 950
                ? 2
                : (constraints.maxWidth >= 700 ? 2 : 1);

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: featuredDoctors.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                mainAxisExtent: 260,
              ),
              itemBuilder: (context, index) {
                final doc = featuredDoctors[index];
                return DoctorCard(
                  doctor: doc,
                  onBook: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.booking,
                      arguments: doc,
                    );
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildWhyChooseSection(bool isDesktop, bool isTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isDesktop ? 36 : 24),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Why Patients Choose MediCare',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Designed to make healthcare seamless, empathetic, and accessible for everyone',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth >= 800 ? 3 : 1;

              return GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 20,
                  mainAxisExtent: 165,
                ),
                children: [
                  _buildFeatureCard(
                    Icons.security_rounded,
                    'HIPAA Compliant & Confidential',
                    'Your private health details and consultation logs are encrypted with enterprise-grade security standards.',
                  ),
                  _buildFeatureCard(
                    Icons.videocam_rounded,
                    'Flexible Consultation Modes',
                    'Choose between HD video calls, audio visits, or confirmed in-person hospital visits as per your preference.',
                  ),
                  _buildFeatureCard(
                    Icons.price_check_rounded,
                    'Zero Hidden Fees',
                    'See the exact consultation fee upfront before confirming your appointment. No surprises, no hidden bills.',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.lightBlue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.primaryBlue, size: 24),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCtaBanner(bool isDesktop) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isDesktop ? 40 : 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryBlue, AppTheme.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Need an urgent consultation right now?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Book a consultation slot with our verified physicians in under 2 minutes.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.lightBlue,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.booking),
                  icon: const Icon(Icons.calendar_today_rounded, size: 18),
                  label: const Text('Book Your Appointment Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.white,
                    foregroundColor: AppTheme.primaryBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
