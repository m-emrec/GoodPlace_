import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:good_place/core/constants/app_assets.dart';
import 'package:good_place/core/constants/app_paddings.dart';
import 'package:good_place/core/extensions/context_extension.dart';
import 'package:good_place/core/utils/models/habit_model.dart';
import 'package:good_place/core/utils/widgets/calendar.dart';
import 'package:good_place/core/utils/widgets/card_background_cover.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../user_data/habit_provider.dart';

class HabitDetail extends StatefulWidget {
  static const routeName = "habit-detail";
  const HabitDetail({
    super.key,
  });

  @override
  State<HabitDetail> createState() => _HabitDetailState();
}

class _HabitDetailState extends State<HabitDetail> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    HabitProvider habitProvider = Provider.of<HabitProvider>(context);

    final int habitIndex = ModalRoute.of(context)?.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(onPressed: () {
        if (!habitProvider.habits[habitIndex].done) {
          Provider.of<HabitProvider>(context, listen: false)
              .updateHabit(habitProvider.habits[habitIndex].id ?? "");
        } else {
          null;
        }
      }),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          SizedBox(
            height: context.dynamicHeight(0.4),
            width: double.infinity,
            child: Stack(
              children: [
                _image(context, habitProvider.habits[habitIndex]),

                CardBackgroundImageFilter(
                  child: SizedBox(
                    height: context.dynamicHeight(0.4),
                    width: double.infinity,
                  ),
                ),

                _infoRow(habitProvider.habits[habitIndex], context),

                /// Streak Count
                _streakCount(habitProvider.habits[habitIndex], context),

                Lottie.network(
                  "https://lottie.host/c20a5992-ee14-4fa8-bd0f-9671d941028d/sX9uTBccmh.json",
                  animate: true,
                  repeat: true,
                  fit: BoxFit.contain,
                ),
                // LottieBuilder.network(
                //   "https://lottie.host/c20a5992-ee14-4fa8-bd0f-9671d941028d/sX9uTBccmh.json",
                // ),
              ],
            ),
          ),
          Expanded(
            child: Calendar(
              eventLoader: (day) {
                bool _isDone = false;

                DateTime _day = DateTime(day.year, day.month, day.day);

                HabitProvider.instance.habits[habitIndex].completionDates
                    .forEach((_) {
                  DateTime a = DateTime(_.year, _.month, _.day);
                  if (a == _day) {
                    _isDone = true;
                  }
                });
                if (_isDone) {
                  return [const Text("data")];
                }
                return [];
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _image(BuildContext context, HabitModel habitModel) {
    return habitModel.imageUrl == null || habitModel.imageUrl!.isEmpty
        ? Image.asset(AppAssets.authTopBackgroundImage)
        : Image.network(
            habitModel.imageUrl ?? "",
            fit: BoxFit.cover,
            height: context.dynamicHeight(0.4),
          );
  }

  Widget _streakCount(HabitModel habitModel, BuildContext context) {
    return Positioned(
      right: AppPaddings.smallPaddingValue,
      top: kToolbarHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          /// Streak
          Text(
            habitModel.streakCount.toString(),
            style: context.textTheme.headlineLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Streak",
            style: context.textTheme.titleSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Positioned _infoRow(HabitModel habitModel, BuildContext context) {
    return Positioned(
      left: AppPaddings.homeScreenHorizontalPadding.left,
      bottom: AppPaddings.homeScreenHorizontalPadding.bottom,
      right: AppPaddings.homeScreenHorizontalPadding.right,
      child: LayoutBuilder(
        builder: (context, constraints) => FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title
                  Text(
                    habitModel.title,
                    style: context.textTheme.titleLarge
                        ?.copyWith(color: Colors.white),
                  ),

                  /// Purpose
                  Visibility(
                    visible: habitModel.purpose != "",
                    child: Text(
                      habitModel.purpose ?? "",
                      style: context.textTheme.labelLarge
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
              Gap(constraints.maxWidth / 2),

              /// Created Date
              Text(
                DateFormat.yMMMEd().format(habitModel.createDate),
                style: context.textTheme.labelLarge?.copyWith(
                  color: Colors.white.withOpacity(
                    0.75,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
