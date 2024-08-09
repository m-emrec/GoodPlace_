import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:good_place/features/onboarding/onboarding_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/theme.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_paddings.dart';
import '../../../core/extensions/context_extension.dart';
import '../../../core/utils/widgets/custom_buttons.dart';
import '../../../core/utils/widgets/image_container.dart';
import 'sign_in_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final String hiWelcome = "Hi, Welcome";

  final String toGoodPlace = "to GoodPlace";

  final String desc =
      "Explore the app, Find some peace of mind to achieve good habits.";

  final String buttonLabel = "GET STARTED";

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: theme(),
      child: _Body(
          buttonLabel: buttonLabel,
          hiWelcome: hiWelcome,
          toGoodPlace: toGoodPlace,
          desc: desc),
    );
  }

  ThemeData theme() => ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.welcomeScaffoldColor,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: AppColors.welcomeScaffoldColor,
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: GoogleFonts.rubik(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: AppColors.grayTextColor,
          ),
          titleLarge: GoogleFonts.rubik(
            color: AppColors.orangeTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
          titleMedium: GoogleFonts.rubik(
            color: AppColors.orangeTextColor,
            fontWeight: FontWeight.w300,
            fontStyle: FontStyle.italic,
            fontSize: 30,
          ),
        ),
        scaffoldBackgroundColor: AppColors.welcomeScaffoldColor,
      );
}

class _Body extends StatefulWidget {
  const _Body({
    required this.buttonLabel,
    required this.hiWelcome,
    required this.toGoodPlace,
    required this.desc,
  });

  final String buttonLabel;
  final String hiWelcome;
  final String toGoodPlace;
  final String desc;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  bool _isOnboardingCompleted = false;

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isOnboardingCompleted = prefs.getBool('onboardingCompleted') ?? false;
    });
  }

  onPressed() async {
    await _checkOnboardingStatus();
    if (_isOnboardingCompleted) {
      context.navigator.pushNamed(SignInPage.routeName);
    } else {
      context.navigator.pushNamed(OnboardingPage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: AppPaddings.authScreenHorizontalPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Get Starte Button
            ExpandedFilledButton(
              label: widget.buttonLabel,
              onPressed: () => onPressed(),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(
            flex: 2,
          ),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppPaddings.largePaddingValue),
            child: Column(
              children: [
                Text(
                  widget.hiWelcome,
                  style: context.textTheme.titleLarge,
                ),
                Text(
                  widget.toGoodPlace,
                  style: context.textTheme.titleMedium,
                ),
                const Gap(AppPaddings.smallPaddingValue),
                //desc
                Text(
                  widget.desc,
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          const Spacer(
            flex: 1,
          ),
          // Image
          AssetImageContainer(
            path: AppAssets.welcomePageImage,
            fit: BoxFit.fill,
            width: context.dynamicWidth(1),
            height: context.dynamicHeight(0.6),
          ),
        ],
      ),
    );
  }
}
