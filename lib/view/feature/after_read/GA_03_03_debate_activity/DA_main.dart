import 'package:flutter/material.dart';
import 'package:readventure/view/components/custom_app_bar.dart';
import 'package:readventure/theme/theme.dart';
import 'package:readventure/theme/font.dart';
import 'package:readventure/view/components/custom_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widget/start_page/description_section_main.dart';
import '../widget/start_page/icon_section_main.dart';
import '../widget/start_page/title_section_main.dart';
import 'DA_learning.dart';

class DebateActivityMain extends StatelessWidget {
  const DebateActivityMain({super.key});

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    return Scaffold(
      appBar: CustomAppBar_2depth_6(title: "토론", automaticallyImplyLeading: false,
        onIconPressed: () {
          Navigator.pop(context);
        } ,
      ),
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
                          TitleSectionMain(
                            title: "인공지능의 일자리 대체를",
                            subtitle: "",
                            subtitle2: "주제로 토론해볼까요?",
                            customColors: customColors,
                          ),
                          SizedBox(height: 51.h),
                          SVGSection(customColors: customColors)

                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(height: 30.h),
                          DescriptionSection(
                            customColors: customColors, // 필수: CustomColors 전달
                            items: [
                              {
                                "icon": Icons.message_outlined, // 사용자 지정 아이콘
                                "text": "찬성/반대 총 4번을 반복해요!",
                              },
                              {
                                "icon": Icons.access_time_filled, // 사용자 지정 아이콘
                                "text": "미션을 시작하면 타이머가 작동해요!",
                              },
                            ],
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
              builder: (context) => DebatePage(),
            ),
          );
        },
        title: '시작하기',
      ),
    );
  }
}