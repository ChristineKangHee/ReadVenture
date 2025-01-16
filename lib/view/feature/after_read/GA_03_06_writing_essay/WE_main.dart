import 'package:flutter/material.dart';
import 'package:readventure/view/components/custom_app_bar.dart';
import 'package:readventure/theme/theme.dart';
import 'package:readventure/theme/font.dart';
import 'package:readventure/view/components/custom_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widget/start_page/description_section_main.dart';
import '../widget/start_page/icon_section_main.dart';
import '../widget/start_page/title_section_main.dart';
import 'WE_learning.dart';

class WritingEssayMain extends StatelessWidget {
  const WritingEssayMain({super.key});

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    return Scaffold(
      appBar: CustomAppBar_2depth_6(title: "에세이 작성"),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight, // 화면의 전체 높이에 맞추기
                ),
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                  color: customColors.neutral90,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SizedBox(height: 117.h),
                          TitleSectionMain(title: "자신의 경험을", subtitle: "", subtitle2: "글로 표현해볼까요?", customColors: customColors,),
                          SizedBox(height: 51.h),
                          IconSection(customColors: customColors),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(height: 30.h),
                          DescriptionSection(
                            customColors: customColors, // 필수: CustomColors 전달
                          ),
                          SizedBox(height: 50.h),
                          Button_Section(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class Button_Section extends StatelessWidget {
  const Button_Section({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ButtonPrimary(
        function: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WELearning(),
            ),
          );
        },
        title: '시작하기',
      ),
    );
  }
}