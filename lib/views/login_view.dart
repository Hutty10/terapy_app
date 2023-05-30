import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../controllers/services/auth_service.dart';
import '../controllers/services/local_db_service.dart';
import '../routers/route_names.dart';
import '../widgets/buttons.dart';
import '../widgets/textfields.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  late TextEditingController _emailController, _passwordController;
  late GlobalKey<FormState> _formKey;
  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _readFormStorage();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _readFormStorage() async {
    final data = await ref.read(localDbProvider).readEmailPassword();
    _emailController.text = data['email'] ?? '';
    _passwordController.text = data['password'] ?? '';
    if (data['email'] != null) {
      ref.read(rememberPasswordProvider.notifier).state = true;
    }
  }

  _trySubmit({required String email, required String password}) {
    final currentState = _formKey.currentState;
    if (currentState?.validate() ?? false) {
      currentState?.save();
      ref.read(authServiceProvider).login(email, password);
      final rememberPassword = ref.read(rememberPasswordProvider);
      if (rememberPassword) {
        ref.read(localDbProvider).saveEmailPassword(email, password);
      } else {
        ref.read(localDbProvider).deleteEmailPassword();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.fromLTRB(20.w, 100.h, 20.w, 0),
            children: [
              Text(
                'Sign In',
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
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                hintText: 'Email',
              ),
              SizedBox(height: 30.h),
              AppTextField(
                controller: _passwordController,
                hintText: 'Password',
                obscureText: !ref.watch(visiblePasswordProvider),
                suffixIcon: IconButton(
                  onPressed: () =>
                      ref.read(visiblePasswordProvider.notifier).state =
                          !ref.read(visiblePasswordProvider.notifier).state,
                  color: theme.iconTheme.color?.withOpacity(.6),
                  icon: Icon(
                    ref.watch(visiblePasswordProvider)
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Checkbox(
                    value: ref.watch(rememberPasswordProvider),
                    onChanged: (value) {
                      ref.read(rememberPasswordProvider.notifier).state =
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
              SizedBox(height: 20.h),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Forget Password?',
                  style: theme.textTheme.bodyLarge!
                      .copyWith(color: theme.primaryColor),
                ),
              ),
              AppButton(
                onPressed: () {
                  // ref.read(localDbProvider).uninitializeApp();
                  FocusScope.of(context).unfocus();
                  _trySubmit(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                  );
                  context.goNamed(RouteName.homeScreen);
                },
                text: 'Sign In',
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
                  'Sign in with Google',
                  style: theme.textTheme.bodyLarge,
                ),
              ),
              SizedBox(height: 40.h),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Don\'t have an account?  ',
                  style: theme.textTheme.titleLarge!.copyWith(fontSize: 18.sp),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Sign Up',
                      style: theme.textTheme.titleLarge!.copyWith(
                        fontSize: 18.sp,
                        color: theme.primaryColor,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => context.goNamed(RouteName.signupScreen),
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

final rememberPasswordProvider =
    StateProvider.autoDispose<bool>((ref) => false);
final visiblePasswordProvider = StateProvider.autoDispose<bool>((ref) => false);
