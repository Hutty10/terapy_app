import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../controllers/services/local_db_service.dart';
import '../routers/route_names.dart';
import '../widgets/buttons.dart';
import '../widgets/textfields.dart';

class SignUpView extends ConsumerStatefulWidget {
  const SignUpView({super.key});

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  late TextEditingController _nameController,
      _emailController,
      _passwordController,
      _repeatPasswordController;
  late GlobalKey<FormState> _formKey;
  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _repeatPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  void _trySubmit({
    required String email,
    required String password,
    required String name,
  }) {
    final currentState = _formKey.currentState;
    if (currentState?.validate() ?? false) {
      currentState?.save();
      // ref
      //     .read(authServiceProvider)
      //     .signup(name: name, email: email, password: password);
      final rememberPassword = ref.read(srememberPasswordProvider);
      if (rememberPassword) {
        ref.read(localDbProvider).saveEmailPassword(email, password);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.fromLTRB(20.w, 50.h, 20.w, 0),
            children: [
              Text(
                'Sign Up',
                textAlign: TextAlign.center,
                style: theme.textTheme.displaySmall,
              ),
              SizedBox(height: 10.h),
              Text(
                'Welcome Back',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.textTheme.titleMedium?.color?.withOpacity(.6),
                ),
              ),
              SizedBox(height: 20.h),
              AppTextField(
                controller: _nameController,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Name must not be empty';
                  } else if (value!.length < 5) {
                    return 'Name must be more than 5 char';
                  }
                  return null;
                },
                keyboardType: TextInputType.name,
                hintText: 'Fullname',
              ),
              SizedBox(height: 20.h),
              AppTextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                hintText: 'Email',
              ),
              SizedBox(height: 20.h),
              AppTextField(
                controller: _passwordController,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Password must not be empty';
                  } else if (value!.length < 8) {
                    return 'Password should have 8 or more char';
                  }
                  return null;
                },
                hintText: 'Password',
                obscureText: true,
              ),
              SizedBox(height: 20.h),
              AppTextField(
                controller: _repeatPasswordController,
                validator: (value) {
                  if (value != null && value != _passwordController.text) {
                    return 'Repeat password must be the same as Password';
                  }
                  return null;
                },
                hintText: 'Repeat Password',
                obscureText: true,
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Checkbox(
                    value: ref.watch(srememberPasswordProvider),
                    onChanged: (value) {
                      ref.read(srememberPasswordProvider.notifier).state =
                          value!;
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: BorderSide(
                      color: theme.textTheme.bodyLarge!.color!.withOpacity(.8),
                    ),
                  ),
                  Text(
                    'Remember Password',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.textTheme.bodyLarge?.color?.withOpacity(.8),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              AppButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  _trySubmit(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                    name: _nameController.text.trim(),
                  );
                },
                text: 'Sign Up',
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: theme.textTheme.bodyLarge!.color!.withOpacity(.5),
                    ),
                  ),
                  Text(
                    ' Or ',
                    style: theme.textTheme.bodyLarge!.copyWith(
                      color: theme.textTheme.bodyLarge!.color!.withOpacity(.5),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: theme.textTheme.bodyLarge!.color!.withOpacity(.5),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  fixedSize: Size.fromHeight(50.h),
                ),
                icon: SvgPicture.asset(
                  'assets/images/google.svg',
                  height: 25,
                ),
                label: Text(
                  'Sign Up with Google',
                  style: theme.textTheme.bodyLarge,
                ),
              ),
              SizedBox(height: 20.h),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Have have an account?  ',
                  style: theme.textTheme.titleLarge!.copyWith(fontSize: 18.sp),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Sign In',
                      style: theme.textTheme.titleLarge!.copyWith(
                        fontSize: 18.sp,
                        color: theme.primaryColor,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => context.goNamed(RouteName.loginScreen),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final srememberPasswordProvider =
    StateProvider.autoDispose<bool>((ref) => false);
