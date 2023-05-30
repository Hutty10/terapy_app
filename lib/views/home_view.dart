import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SafeArea(
      child: ListView(
        padding:
            EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h, bottom: 20.h),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello,',
                    style: theme.textTheme.bodyLarge,
                  ),
                  Text(
                    'Name Last  👋',
                    style: theme.textTheme.titleLarge,
                  ),
                ],
              ),
              CircleAvatar(
                radius: 30.r,
              ),
            ],
          ),
          CustomCard(
            title: 'Nearby Therapist',
            onViewPressed: () {},
          ),
          CustomCard(
            title: 'Recommended',
            onViewPressed: () {},
          ),
          CustomCard(
            title: 'Popular Therapist',
            onViewPressed: () {},
          ),
          const UpcomingCard()
        ],
      ),
    );
  }
}

class CustomCard extends ConsumerWidget {
  const CustomCard({
    super.key,
    required this.title,
    required this.onViewPressed,
  });
  final String title;
  final VoidCallback onViewPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: theme.textTheme.bodyLarge,
            ),
            TextButton(
              onPressed: () {},
              child: const Text('View all'),
            ),
          ],
        ),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, __) => Card(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(radius: 25.r),
                    SizedBox(width: 8.w),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Dr Ahmed Uthman',
                          style: theme.textTheme.bodyLarge,
                        ),
                        RichText(
                          text: TextSpan(
                            text: '⭐️ 4.8  ',
                            style: theme.textTheme.bodyLarge,
                            children: [
                              TextSpan(
                                text: '(110 Reviews)',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.textTheme.bodyMedium?.color!
                                      .withOpacity(.7),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      color: theme.primaryColor,
                      icon: const Icon(Icons.schedule_send),
                    )
                  ],
                ),
              ),
            ),
            separatorBuilder: (_, __) => SizedBox(width: 10.w),
            itemCount: 5,
          ),
        )
      ],
    );
  }
}

class UpcomingCard extends ConsumerWidget {
  const UpcomingCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upcoming Appointment',
              style: theme.textTheme.bodyLarge,
            ),
            TextButton(
              onPressed: () {},
              child: const Text('View all'),
            )
          ],
        ),
        Card(
          color: theme.primaryColor,
          child: Container(
            margin: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(radius: 25.r),
                    SizedBox(width: 20.w),
                    Text(
                      'Dr Ahmed Uthman',
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(color: Colors.white),
                    )
                  ],
                ),
                SizedBox(height: 20.h),
                Container(
                  padding: EdgeInsets.all(5.sp),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.schedule,
                        color: Colors.white,
                      ),
                      Text(
                        'Thu, Dec at 10:00 am',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: Colors.white),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
