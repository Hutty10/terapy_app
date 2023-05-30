import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../controllers/services/local_db_service.dart';
import '../models/slider_model.dart';
import '../routers/route_names.dart';
import '../widgets/buttons.dart';

class OnboardingView extends ConsumerStatefulWidget {
  const OnboardingView({super.key});

  @override
  ConsumerState<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends ConsumerState<OnboardingView> {
  late PageController _pageController;
  int _currentIndex = 0;
  late List<SliderModel> slides;
  @override
  void initState() {
    _pageController = PageController();
    slides = getSlides();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: '${_currentIndex + 1}',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: theme.primaryColor),
                      children: <TextSpan>[
                        TextSpan(
                          text: '/3',
                          style: theme.textTheme.titleMedium,
                        )
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      context.goNamed(RouteName.loginScreen);
                      ref.read(localDbProvider).setOnboarding();
                    },
                    style: OutlinedButton.styleFrom(
                        textStyle: theme.textTheme.titleMedium),
                    child: const Text(
                      'Skip',
                    ),
                  ),
                ],
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (value) => setState(() {
                    _currentIndex = value;
                  }),
                  itemCount: slides.length,
                  itemBuilder: (context, index) {
                    final String image = slides[index].getImage();
                    if (image.endsWith('.svg')) {
                      return SvgPicture.asset(image);
                    }
                    return Image.asset(image);
                  },
                ),
              ),
              Text(
                slides[_currentIndex].getTitle(),
                style: theme.textTheme.titleLarge,
              ),
              SizedBox(height: 20.h),
              SizedBox(
                height: 50,
                child: Text(
                  slides[_currentIndex].getDescription(),
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: List.generate(
                  slides.length,
                  (index) => buildDot(
                    index,
                    _currentIndex == index
                        ? theme.primaryColor
                        : theme.splashColor,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              AppButton(
                onPressed: () {
                  if (_currentIndex == slides.length - 1) {
                    ref.read(localDbProvider).setOnboarding();
                  } else {
                    _pageController.nextPage(
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.bounceIn);
                  }
                },
                text: _currentIndex != slides.length - 1 ? 'Continue' : 'Next',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildDot(int index, Color color) {
    return Container(
      height: 10,
      width: _currentIndex == index ? 25 : 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
      ),
    );
  }
}
