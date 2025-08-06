import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dukascango/presentation/screens/admin/admin_home_screen.dart';
import 'package:dukascango/presentation/components/animation_route.dart';

class AdminWalkthroughScreen extends StatefulWidget {
  const AdminWalkthroughScreen({Key? key}) : super(key: key);

  @override
  State<AdminWalkthroughScreen> createState() => _AdminWalkthroughScreenState();
}

class _AdminWalkthroughScreenState extends State<AdminWalkthroughScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Widget> _walkthroughPages = [
    const WalkthroughPage(
      title: 'Welcome, Admin!',
      description: 'This walkthrough will guide you through the main features for admins.',
      image: 'Assets/svg/bussiness-man.svg',
    ),
    const WalkthroughPage(
      title: 'Manage Products',
      description: 'You can add, edit, and delete products in the inventory.',
      image: 'Assets/svg/restaurante.svg',
    ),
    const WalkthroughPage(
      title: 'Manage Orders',
      description: 'View and manage all customer orders.',
      image: 'Assets/svg/delivery-bike.svg',
    ),
    const WalkthroughPage(
      title: 'Staff Management',
      description: 'You can invite and manage your staff members.',
      image: 'Assets/delivery.svg',
    ),
  ];

  Future<void> _finishWalkthrough() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('walkthrough_completed', true);
    Navigator.pushAndRemoveUntil(context, routeFrave(page: AdminHomeScreen()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Walkthrough'),
      ),
      body: PageView(
        controller: _pageController,
        children: _walkthroughPages,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_currentPage != 0)
              TextButton(
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: const Text('Previous'),
              ),
            if (_currentPage != _walkthroughPages.length - 1)
              TextButton(
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: const Text('Next'),
              ),
            if (_currentPage == _walkthroughPages.length - 1)
              TextButton(
                onPressed: _finishWalkthrough,
                child: const Text('Finish'),
              ),
          ],
        ),
      ),
    );
  }
}

class WalkthroughPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const WalkthroughPage({
    Key? key,
    required this.title,
    required this.description,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 200,
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
