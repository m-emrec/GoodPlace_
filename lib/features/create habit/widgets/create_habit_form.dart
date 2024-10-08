import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:good_place/core/extensions/context_extension.dart';
import 'package:good_place/core/resourcers/tutorial_manager.dart';
import 'package:good_place/core/utils/widgets/tutorial_widget.dart';
import 'package:good_place/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_paddings.dart';
import '../../../core/utils/widgets/custom_text_form_field.dart';
import '../../chatgpt/ChatGptService.dart';
import '../../chatgpt/SystemContentTexts.dart';

class CreateHabitForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final String habitNameTextFieldLabel;
  final TextEditingController habitNameController;
  final TextEditingController imageUrlController;
  final String habitPurposeTextFieldLabel;
  final TextEditingController purposeController;
  const CreateHabitForm(
      {super.key,
      required this.habitNameTextFieldLabel,
      required this.habitNameController,
      required this.habitPurposeTextFieldLabel,
      required this.purposeController,
      required this.formKey,
      required this.imageUrlController});

  @override
  State<CreateHabitForm> createState() => _CreateHabitFormState();
}

class _CreateHabitFormState extends State<CreateHabitForm> {
  bool isAIButtonEnabled = true;
  Future<void> generateResponse(
    String? userContentText,
    String? userContentImageUrl,
    String systemContentText,
    TextEditingController controller,
  ) async {
    controller.clear();
    setState(() {
      isAIButtonEnabled = false;
    });
    final body = ChatgptService().getApiBody(
        systemContentText: systemContentText,
        userContentText: userContentText,
        imageUrl: userContentImageUrl);

    var response = '';
    ChatgptService().getChatResponse(body).listen((word) {
      setState(() {
        response += word;
        controller.text = response;
      });
    }).onDone(() {
      isAIButtonEnabled = true;
    });
  }

  @override
  void initState() {
    TutorialManager.ins
        .show(context, TutorialManager.createHabitPageTutorialKeList);
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          /// Habit Name
          NormalTextFormField(
            label: widget.habitNameTextFieldLabel,
            controller: widget.habitNameController,
            textCapitalization: TextCapitalization.words,
            maxLength: 25,
            validator: (value) =>
                value?.trim() == "" ? "This field can't be empty ! " : null,
            buildCounter: (context,
                {required currentLength,
                required isFocused,
                required maxLength}) {
              return Text(
                "$currentLength / $maxLength",
                style: context.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                ),
              );
            },
          ),
          const Gap(AppPaddings.smallPaddingValue),

          /// Purpose text Field
          TextAreaFormField(
            // validator: (value) => widget.habitNameController.text.trim() == "" ?"" :,
            label: widget.habitPurposeTextFieldLabel,
            suffixIcon: Skeletonizer(
              enabled: !isAIButtonEnabled,
              child: Skeleton.replace(
                replace: !isAIButtonEnabled,
                replacement: const Padding(
                    padding:
                        EdgeInsets.all(AppPaddings.xxsmallPaddingValue * 2),
                    child: CircularProgressIndicator()),
                child: TutorialWidget(
                  tutorialKey: TutorialKeys.aiWriter,
                  child: GestureDetector(
                    onTap: isAIButtonEnabled ? onAIButtonTapped : null,
                    child: AppAssets.aiIcon(96, 96),
                  ),
                ),
              ),
            ),
            isExpandable: true,
            constraints: BoxConstraints(
              maxHeight: context.dynamicHeight(0.4),
            ),
            controller: widget.purposeController,
            textInputAction: TextInputAction.done,
            maxLength: 300,

            textCapitalization: TextCapitalization.sentences,
            buildCounter: (context,
                {required currentLength,
                required isFocused,
                required maxLength}) {
              return Text(
                "$currentLength / $maxLength",
                style: context.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void onAIButtonTapped() {
    if ((widget.habitNameController.text.isNotEmpty) ||
        (widget.imageUrlController.text.isNotEmpty)) {
      generateResponse(
        widget.habitNameController.text,
        widget.imageUrlController.text,
        purposeSystemContentText,
        widget.purposeController,
      );
    } else {
      widget.purposeController.text =
          "Please provide a valid habit name first.";
    }
  }
}
