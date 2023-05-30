import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import './home_view.dart';
import './profile_view.dart';
import './therapists.dart';
import '../routers/route_names.dart';

class MainView extends ConsumerStatefulWidget {
  MainView({required String tab, Key? key})
      : index = indexFrom(tab),
        super(key: key);
  final int index;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainViewState();
  static int indexFrom(String tab) {
    switch (tab) {
      case 'home':
        return 0;
      case 'cart':
        return 1;
      case 'chat':
        return 2;
      case 'profile':
        return 3;
      default:
        return 0;
    }
  }
}

class _MainViewState extends ConsumerState<MainView> {
  late int _selectedIndex;
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const HomeView(),
          const TherapistsView(),
          Container(color: Colors.blue),
          const ProfileView(),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        height: 86.h,
        decoration: BoxDecoration(
          color: theme.primaryColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                if (_selectedIndex != 0) {
                  setState(() => _selectedIndex = 0);
                  context.goNamed(RouteName.homeScreen);
                }
              },
              child: Icon(
                Icons.home_outlined,
                size: 32.sp,
                color: _selectedIndex == 0 ? Colors.black : Colors.white,
              ),
            ),
            GestureDetector(
              onTap: () {
                if (_selectedIndex != 1) {
                  setState(() => _selectedIndex = 1);
                  context.goNamed(RouteName.cartScreen);
                }
              },
              child: SvgPicture.asset(
                'assets/images/doc.svg',
                height: 32.h,
                width: 32.w,
                color: _selectedIndex == 1 ? Colors.black : Colors.white,
              ),
            ),
            GestureDetector(
              onTap: () {
                if (_selectedIndex != 2) {
                  setState(() => _selectedIndex = 2);
                  context.goNamed(RouteName.chatScreen);
                }
              },
              child: Icon(
                Icons.history,
                size: 32.sp,
                color: _selectedIndex == 2 ? Colors.black : Colors.white,
              ),
            ),
            GestureDetector(
              onTap: () {
                if (_selectedIndex != 3) {
                  setState(() => _selectedIndex = 3);
                  context.goNamed(RouteName.profileScreen);
                }
              },
              child: Icon(
                Icons.account_circle_outlined,
                size: 32.sp,
                color: _selectedIndex == 3 ? Colors.black : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
