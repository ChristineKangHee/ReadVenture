/// File: stage_data.dart
/// Purpose: Firestore에서 학습 스테이지 데이터를 불러오고 관리하는 기능을 제공
/// Author: 박민준
/// Created: 2025-02-04
/// Last Modified: 2025-02-05 by 박민준

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:readventure/model/reading_data.dart';
import 'ar_data.dart';
import 'br_data.dart';
import 'section_data.dart'; // SectionData, StageData
import 'package:firebase_storage/firebase_storage.dart';

/// 특정 파일의 Firebase Storage 다운로드 URL을 가져오는 함수 현재는 covers 폴더
Future<String?> getCoverImageUrl(String fileName) async {
  try {
    final ref = FirebaseStorage.instance.ref().child('covers/$fileName');
    return await ref.getDownloadURL();
  } catch (e) {
    print('❌ Error getting download URL for $fileName: $e');
    return null;
  }
}

/// Firestore에서 현재 유저의 모든 스테이지 문서를 불러와서 List<StageData>로 변환
Future<List<StageData>> loadStagesFromFirestore(String userId) async {
  final progressRef = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('progress');

  final querySnapshot = await progressRef.get();

  // 🔹 만약 아무 문서도 없다면, 기본 스테이지 몇 개를 만들어 Firestore에 저장
  if (querySnapshot.docs.isEmpty) {
    await _createDefaultStages(progressRef);
    // 기본 스테이지 생성 후, 다시 데이터를 불러옵니다.
    final updatedSnapshot = await progressRef.get();
    return updatedSnapshot.docs.map((doc) {
      return StageData.fromJson(doc.id, doc.data());
    }).toList();
  }

  // 🔹 문서가 있다면 그대로 변환
  return querySnapshot.docs.map((doc) {
    return StageData.fromJson(doc.id, doc.data());
  }).toList();
}

/// 초기 상태(처음 앱에 들어왔을 때) Firestore에 기본 스테이지 문서를 만드는 함수
Future<void> _createDefaultStages(CollectionReference progressRef) async {
  final stageCoverUrl = await getCoverImageUrl("stage_001.png");
  print("[_createDefaultStages] stageCoverUrl: $stageCoverUrl");

  final defaultStages = [
    StageData(
      stageId: "stage_001",
      subdetailTitle: "읽기 도구의 필요성",
      totalTime: "30",
      achievement: 0,
      status: StageStatus.inProgress, // 첫 스테이지만 시작 가능
      difficultyLevel: "쉬움",
      textContents: "읽기 도구가 왜 필요한지 알아봅니다.",
      missions: ["미션 1-1", "미션 1-2", "미션 1-3"],
      effects: ["집중력 향상", "읽기 속도 증가"],
      activityCompleted: {
        "beforeReading": false,
        "duringReading": false,
        "afterReading": false,
      },

      // 읽기 전(BR) 화면용 데이터
      brData: BrData(
        // Firebase Storage에서 다운받을 수 있는 URL을 바로 넣거나
        // 또는 일단 가짜로 두고 수정 가능
        coverImageUrl: stageCoverUrl ?? "",
        keywords: ["#읽기능력", "#맞춤형도구", "#피드백"],
      ),

      // 읽기 중(READING) 화면용 데이터
      readingData: ReadingData(
        coverImageUrl: stageCoverUrl ?? "",
        // 글 내용 3분할
        textSegments: [
          "이 글의 1단계 내용...",
          "이 글의 2단계 내용...",
          "이 글의 3단계 내용...",
        ],

        // 사지선다 퀴즈
        multipleChoice: MultipleChoiceQuiz(
          question: "이 글의 핵심 주제는 무엇일까요?",
          correctAnswer: "B",
          choices: [
            "A. 전혀 관련 없는 답",
            "B. 읽기 도구의 필요성",
            "C. 읽기 전 활동의 중요성",
            "D. 잘못된 선택지",
          ],
        ),

        // OX 퀴즈
        oxQuiz: OXQuiz(
          question: "이 글은 과학 분야이다.",
          correctAnswer: false,
        ),
      ),

      // 읽기 후(AR) 화면용 데이터 - 지금은 간단히 예시만
      arData: ArData(
        // 예: 어떤 feature를 쓸지(여기서는 2번, 5번, 9번).
        features: [2, 5, 9],
        // featureData에 어떤 형태든 넣을 수 있음
        featureData: {
          "feature2Title": "단어 빈칸 채우기",
          "feature5Description": "특정 UI 설정 값",
          "feature9Something": 123,
        },
      ),
    ),

    // ------ stage_002, stage_003, stage_004도 동일하게 작성 ------
    // 예시로 하나 더
    StageData(
      stageId: "stage_002",
      subdetailTitle: "읽기 도구 사용법",
      totalTime: "20",
      achievement: 0,
      status: StageStatus.locked,
      difficultyLevel: "쉬움",
      textContents: "읽기 도구의 사용법을 익힙니다.",
      missions: ["미션 2-1", "미션 2-2"],
      effects: ["이해력 향상", "읽기 효율 증가"],
      activityCompleted: {
        "beforeReading": false,
        "duringReading": false,
        "afterReading": false,
      },
      brData: BrData(
        coverImageUrl: stageCoverUrl ?? "",
        keywords: ["#사용법", "#연습하기", "#키워드3"],
      ),
      readingData: ReadingData(
        coverImageUrl: stageCoverUrl ?? "",
        textSegments: ["내용1", "내용2", "내용3"],
        multipleChoice: MultipleChoiceQuiz(
          question: "해당 도구의 장점이 아닌 것은?",
          correctAnswer: "A",
          choices: ["A. 실제로 단점", "B. 장점1", "C. 장점2", "D. 장점3"],
        ),
        oxQuiz: OXQuiz(question: "이 도구는 무료이다.", correctAnswer: true),
      ),
      arData: ArData(
        features: [1, 3, 7],
        featureData: {"feature1Title": "예시데이터..."},
      ),
    ),

    StageData(
      stageId: "stage_003",
      subdetailTitle: "읽기 도구의 필요성",
      totalTime: "30",
      achievement: 0,
      status: StageStatus.locked, // 첫 스테이지만 시작 가능
      difficultyLevel: "쉬움",
      textContents: "읽기 도구가 왜 필요한지 알아봅니다.",
      missions: ["미션 1-1", "미션 1-2", "미션 1-3"],
      effects: ["집중력 향상", "읽기 속도 증가"],
      activityCompleted: {
        "beforeReading": false,
        "duringReading": false,
        "afterReading": false,
      },

      // 읽기 전(BR) 화면용 데이터
      brData: BrData(
        // Firebase Storage에서 다운받을 수 있는 URL을 바로 넣거나
        // 또는 일단 가짜로 두고 수정 가능
        coverImageUrl: stageCoverUrl ?? "",
        keywords: ["#읽기능력", "#맞춤형도구", "#피드백"],
      ),

      // 읽기 중(READING) 화면용 데이터
      readingData: ReadingData(
        coverImageUrl: stageCoverUrl ?? "",
        // 글 내용 3분할
        textSegments: [
          "이 글의 1단계 내용...",
          "이 글의 2단계 내용...",
          "이 글의 3단계 내용...",
        ],

        // 사지선다 퀴즈
        multipleChoice: MultipleChoiceQuiz(
          question: "이 글의 핵심 주제는 무엇일까요?",
          correctAnswer: "B",
          choices: [
            "A. 전혀 관련 없는 답",
            "B. 읽기 도구의 필요성",
            "C. 읽기 전 활동의 중요성",
            "D. 잘못된 선택지",
          ],
        ),

        // OX 퀴즈
        oxQuiz: OXQuiz(
          question: "이 글은 과학 분야이다.",
          correctAnswer: false,
        ),
      ),

      // 읽기 후(AR) 화면용 데이터 - 지금은 간단히 예시만
      arData: ArData(
        // 예: 어떤 feature를 쓸지(여기서는 2번, 5번, 9번).
        features: [2, 5, 9],
        // featureData에 어떤 형태든 넣을 수 있음
        featureData: {
          "feature2Title": "단어 빈칸 채우기",
          "feature5Description": "특정 UI 설정 값",
          "feature9Something": 123,
        },
      ),
    ),

    // ------ stage_002, stage_003, stage_004도 동일하게 작성 ------
    // 예시로 하나 더
    StageData(
      stageId: "stage_004",
      subdetailTitle: "읽기 도구 사용법",
      totalTime: "20",
      achievement: 0,
      status: StageStatus.locked,
      difficultyLevel: "쉬움",
      textContents: "읽기 도구의 사용법을 익힙니다.",
      missions: ["미션 2-1", "미션 2-2"],
      effects: ["이해력 향상", "읽기 효율 증가"],
      activityCompleted: {
        "beforeReading": false,
        "duringReading": false,
        "afterReading": false,
      },
      brData: BrData(
        coverImageUrl: stageCoverUrl ?? "",
        keywords: ["#사용법", "#연습하기", "#키워드3"],
      ),
      readingData: ReadingData(
        coverImageUrl: stageCoverUrl ?? "",
        textSegments: ["내용1", "내용2", "내용3"],
        multipleChoice: MultipleChoiceQuiz(
          question: "해당 도구의 장점이 아닌 것은?",
          correctAnswer: "A",
          choices: ["A. 실제로 단점", "B. 장점1", "C. 장점2", "D. 장점3"],
        ),
        oxQuiz: OXQuiz(question: "이 도구는 무료이다.", correctAnswer: true),
      ),
      arData: ArData(
        features: [1, 3, 7],
        featureData: {"feature1Title": "예시데이터..."},
      ),
    ),
  ];

  // Firestore에 저장
  for (final stage in defaultStages) {
    await progressRef.doc(stage.stageId).set(stage.toJson());
  }
}


/// 특정 스테이지의 진행 상태를 업데이트하고, Firestore에도 반영하는 함수.
/// 예: "읽기 전 활동 완료" 버튼을 눌렀을 때 호출
Future<void> completeActivityForStage({
  required String userId,
  required String stageId,
  required String activityType,
}) async {
  final docRef = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('progress')
      .doc(stageId);

  // 문서가 있는지 확인
  final snapshot = await docRef.get();
  if (!snapshot.exists) {
    // 문서가 없는 경우 처리. (에러, 또는 무시)
    return;
  }

  // 문서 → StageData
  final stage = StageData.fromJson(snapshot.id, snapshot.data()!);

  // 로컬 StageData 객체에서 활동 완료 처리
  stage.completeActivity(activityType);

  // Firestore 업데이트
  await docRef.update(stage.toJson());
}
