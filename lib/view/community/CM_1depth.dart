import 'package:flutter/material.dart';
import 'package:readventure/theme/font.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/theme.dart';
import '../../viewmodel/custom_colors_provider.dart';
import '../components/custom_app_bar.dart';
import 'Board/CM_2depth_board.dart';
import 'Board/CM_2depth_boardMain.dart';
import 'Ranking/CM_2depth_ranking.dart';
import 'Ranking/ranking_component.dart';
import 'Board/community_data.dart';

class CommunityMainPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customColors = ref.watch(customColorsProvider);
    return Scaffold(
      backgroundColor: customColors.neutral90,
      appBar: CustomAppBar_Community(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: RankingPreview(context, customColors),
            ),
            SizedBox(height: 24),
            CommunityPreview(posts, context, customColors),
          ],
        ),
      ),
    );
  }

  Widget CommunityPreview(posts, BuildContext context, CustomColors customColors) {
    return Column(
      children: [
        postnavigation(context, customColors),
        Container(
          height: 170,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: posts.length,
            itemBuilder: (context, index) {
              var post = posts[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetailPage(post: post),
                    ),
                  );
                },
                child: Container(
                  width: 250,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: customColors.neutral100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Row(
                            children: post.tags
                                .map<Widget>((tag) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(
                                tag,
                                style: body_xxsmall(context).copyWith(color: customColors.primary60),
                              ),
                            ))
                                .toList(),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight, // Align to the right
                              child: Text(
                                formatPostDate(post.createdAt),
                                style: body_xxsmall(context).copyWith(color: customColors.neutral60),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // 제목 & 내용
                      Text(
                        post.title,
                        style: body_small_semi(context),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        post.content,
                        style: body_xxsmall(context),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
// 프로필 정보
                      Row(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(post.profileImage),
                                radius: 12, // Adjusted profile image size
                              ),
                              const SizedBox(width: 8),
                              Text(
                                post.authorName,
                                style: body_xsmall_semi(context).copyWith(color: customColors.neutral30),
                              ),
                            ],
                          ),
                          Expanded( // Ensure this is wrapping the whole content
                            child: Align(
                              alignment: Alignment.centerRight, // Align to the right
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end, // Ensures the likes/views are pushed to the right
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.favorite, size: 16, color: customColors.neutral60),
                                      const SizedBox(width: 4),
                                      Text(
                                        post.likes.toString(),
                                        style: body_xxsmall_semi(context).copyWith(color: customColors.neutral60),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.remove_red_eye, size: 16, color: customColors.neutral60),
                                      const SizedBox(width: 4),
                                      Text(
                                        post.views.toString(),
                                        style: body_xxsmall_semi(context).copyWith(color: customColors.neutral60),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )

                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget RankingPreview(BuildContext context, CustomColors customColors) {
    return Column(
      children: [
        rankingnavigation(context, customColors),
        Container(
          decoration: BoxDecoration(
            color: customColors.neutral100,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              buildTopThree(context, customColors),
              buildPodium(context, customColors),
            ],
          ),
        ),
      ],
    );
  }

  Widget postnavigation(BuildContext context, CustomColors customColors) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      title: Text(
        '게시판',
        style: body_small_semi(context),
      ),
      trailing: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Cm2depthBoardmain()), // 게시판 페이지로 이동, 첫 번째 게시글을 전달
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '더보기',
              style: body_xxsmall_semi(context),
            ),
            SizedBox(width: 4),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: customColors.neutral0,
            ),
          ],
        ),
      ),
    );
  }

  Widget rankingnavigation(BuildContext context, CustomColors customColors) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      title: Text(
        '랭킹',
        style: body_small_semi(context),
      ),
      trailing: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RankingPage()), // 랭킹 페이지로 이동
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '더보기',
              style: body_xxsmall_semi(context),
            ),
            SizedBox(width: 4),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: customColors.neutral0,
            ),
          ],
        ),
      ),
    );
  }

  String formatPostDate(DateTime? postDate) {
    if (postDate == null) {
      return '알 수 없음'; // Handle the case when the postDate is null
    }

    final now = DateTime.now();
    final difference = now.difference(postDate);

    if (difference.inDays > 1) {
      return '${postDate.month}/${postDate.day}/${postDate.year}';
    } else if (difference.inDays == 1) {
      return '어제';
    } else if (difference.inHours > 1) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 1) {
      return '${difference.inMinutes}분 전';
    } else {
      return '방금 전';
    }
  }
}
