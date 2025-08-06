import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dukascango/presentation/screens/client/client_home_screen.dart';
import 'package:dukascango/presentation/components/animation_route.dart';

class ClientWalkthroughScreen extends StatefulWidget {
  const ClientWalkthroughScreen({Key? key}) : super(key: key);

  @override
  State<ClientWalkthroughScreen> createState() =>
      _ClientWalkthroughScreenState();
}

class _ClientWalkthroughScreenState extends State<ClientWalkthroughScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Widget> _walkthroughPages = [
    const WalkthroughPage(
      title: 'Welcome to our App!',
      description:
          'This walkthrough will guide you through the main features for clients.',
      image: 'Assets/delivery.svg',
    ),
    const WalkthroughPage(
      title: 'Browse Products',
      description: 'You can easily browse through our wide range of products.',
      image: 'Assets/empty-cart.svg',
    ),
    const WalkthroughPage(
      title: 'Add to Cart',
      description:
          'Add your favorite products to the cart and proceed to checkout.',
      image: 'Assets/delivery.svg',
    ),
    const WalkthroughPage(
      title: 'Self-Scan Feature',
      description:
          'Use our self-scan feature for a faster checkout experience in-store.',
      image: 'Assets/google-map.png',
    ),
  ];

  Future<void> _finishWalkthrough() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('walkthrough_completed', true);
    Navigator.pushAndRemoveUntil(
        context, routeDukascango(page: ClientHomeScreen()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Walkthrough'),
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
