import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import './account_screen.dart';

import './main_screen.dart';
import './settings_screen.dart';
import '../widgets/navigation_bar.dart';

class TabsScreen extends StatefulWidget {
  static const String routeName = '/tabs';

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final _slider = CarouselController();
  int _currentIndex;
  int _nextIndex;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final int index = (ModalRoute.of(context).settings.arguments);
    _currentIndex = index ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CarouselSlider(
        carouselController: _slider,
        options: CarouselOptions(
          height: double.infinity,
          initialPage: _currentIndex,
          reverse: Localizations.localeOf(context).languageCode == 'ar'
              ? true
              : false,
          viewportFraction: 1,
          enableInfiniteScroll: false,
          onPageChanged: (index, reason) {
            if (reason == CarouselPageChangedReason.controller) {
              if (index == _nextIndex) {
                setState(() => _currentIndex = index);
              }
            } else {
              setState(() => _currentIndex = index);
            }
          },
        ),
        items: [
          MainScreen(),
          SettingsScreen(),
          AccountScreen(),
        ],
      ),
      bottomNavigationBar: Directionality(
        textDirection: TextDirection.ltr,
        child: NavigationBar(
          index: _currentIndex,
          onTap: (index) {
            _nextIndex = index;
            _slider.animateToPage(index);
          },
          items: [
            Image.asset('assets/icons/nav_bar/heart_outlined.png'),
            Image.asset('assets/icons/nav_bar/settings_outlined.png'),
            Image.asset('assets/icons/nav_bar/account_outlined.png'),
          ],
          activeItems: [
            Image.asset('assets/icons/nav_bar/heart_filled.png'),
            Image.asset('assets/icons/nav_bar/settings_filled.png'),
            Image.asset('assets/icons/nav_bar/account_filled.png'),
          ],
        ),
      ),
    );
  }
}
