import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../data/doctor_data.dart';
import '../theme/app_theme.dart';
import '../routes/app_routes.dart';
import '../widgets/navbar.dart';
import '../widgets/footer.dart';
import '../widgets/doctor_card.dart';

class DoctorsScreen extends StatefulWidget {
  final String? initialSpecialization;

  const DoctorsScreen({
    super.key,
    this.initialSpecialization,
  });

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  final TextEditingController _searchController = TextEditingController();
  late String _selectedSpecialization;

  @override
  void initState() {
    super.initState();
    _selectedSpecialization = widget.initialSpecialization ?? 'All';
    if (widget.initialSpecialization != null &&
        !DoctorData.specializations.contains(widget.initialSpecialization)) {
      // If a free-text search string was passed instead of a category
      _searchController.text = widget.initialSpecialization!;
      _selectedSpecialization = 'All';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedSpecialization = 'All';
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;
    final isTablet = screenWidth >= 600 && screenWidth < 900;

    final filteredDoctors = DoctorData.filterDoctors(
      query: _searchController.text,
      specialization: _selectedSpecialization,
    );

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: const Navbar(currentRoute: AppRoutes.doctors),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Search & Filter Bar
            _buildHeaderBanner(isDesktop),

            // Main Listing
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 32 : 16,
                    vertical: 28,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Filter chips row
                      _buildFilterChips(),

                      const SizedBox(height: 24),

                      // Results count & reset button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Showing ${filteredDoctors.length} available doctors',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          if (_searchController.text.isNotEmpty || _selectedSpecialization != 'All')
                            TextButton.icon(
                              onPressed: _resetFilters,
                              icon: const Icon(Icons.clear_rounded, size: 16),
                              label: const Text('Reset Filters'),
                              style: TextButton.styleFrom(
                                foregroundColor: AppTheme.primaryBlue,
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Doctors Grid or Empty State
                      if (filteredDoctors.isEmpty)
                        _buildEmptyState()
                      else
                        _buildDoctorsGrid(filteredDoctors, isDesktop, isTablet),
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
    );
  }

  Widget _buildHeaderBanner(bool isDesktop) {
    return Container(
      width: double.infinity,
      color: AppTheme.white,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 48 : 20,
        vertical: 32,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumb & Title
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.home),
                    child: const Text(
                      'Home',
                      style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                    ),
                  ),
                  const Text('  /  ', style: TextStyle(color: AppTheme.textMuted)),
                  const Text(
                    'Our Doctors',
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
                'Find & Consult Specialist Doctors',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Browse certified physicians, review clinical credentials, and book instant telemedicine consultations.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 20),

              // Search input
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.border),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search by doctor name, specialty, or clinic...',
                    prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primaryBlue),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final categories = ['All', ...DoctorData.specializations];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          final isSelected = _selectedSpecialization.toLowerCase() == cat.toLowerCase();

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(cat),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedSpecialization = selected ? cat : 'All';
                });
              },
              selectedColor: AppTheme.primaryBlue,
              backgroundColor: AppTheme.white,
              labelStyle: TextStyle(
                color: isSelected ? AppTheme.white : AppTheme.textPrimary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 13,
              ),
              avatar: cat != 'All'
                  ? Icon(
                      DoctorData.getSpecializationIcon(cat),
                      size: 16,
                      color: isSelected ? AppTheme.white : AppTheme.primaryBlue,
                    )
                  : null,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? AppTheme.primaryBlue : AppTheme.border,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDoctorsGrid(List<Doctor> doctors, bool isDesktop, bool isTablet) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 950
            ? 2
            : (constraints.maxWidth >= 650 ? 2 : 1);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: doctors.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            mainAxisExtent: 260,
          ),
          itemBuilder: (context, index) {
            final doc = doctors[index];
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
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: AppTheme.lightBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_search_rounded,
              size: 44,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No matching doctors found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try searching with a different doctor name or select another medical specialization.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _resetFilters,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Reset All Filters'),
          ),
        ],
      ),
    );
  }
}
