# 프론트 화면/버튼 역할 정리

> 기준 코드: `lib/prototype_shell.dart`의 `PrototypePage` 라우팅과 각 `features/*/*_screen.dart` 화면.
> 목적: 화면별 역할, 버튼 동작, 아직 정해야 할 지점을 먼저 합의하고 이후 UI/기능을 수정한다.

## 전체 하단바

하단바는 4개 탭으로 간다.

| 탭 | 화면 | 역할 | 현재 동작 |
|---|---|---|---|
| 홈 | `HomeScreen` | 친구/지인과 만든 거지방 목록 | `PrototypePage.home` 이동 |
| 커뮤니티 | `CommunityScreen` | 모든 사용자와 대화/게시글을 나누는 공간 | `PrototypePage.community` 이동 |
| 랭킹 | `RankingScreen` | 거지 랭킹 확인 | `PrototypePage.ranking` 이동 |
| 마이 | `MyPageScreen` | 내 계정/개인 지출 내역 진입 | `PrototypePage.myPage` 이동 |

하단바가 안 보이는 화면:
- `SplashScreen`
- `LoginScreen`
- `SignupScreen`
- `CommunityChatScreen`
- `CommunityPostDetailScreen`
- `CommunityPostWriteScreen`
- `ActiveRoomScreen`
- `RoomRatingScreen`
- `RoomSettingsScreen`
- `ReceiptRegisterScreen`

## 현재 주요 화면 흐름

```text
Splash
  -> Login
    -> Home
    -> Signup -> Login

Home
  -> 방 카드 선택 -> ActiveRoom
  -> 방 만들기 -> CreateRoom -> InviteRoom -> BudgetInput -> BudgetResult -> Recommendation -> ActiveRoom

Community
  -> 전체 채팅방 -> CommunityChat
  -> 글쓰기 -> CommunityPostWrite
  -> 게시글 카드 -> CommunityPostDetail

MyPage
  -> 지출 내역 -> Receipts

ActiveRoom
  -> 거지평가 보기 -> RoomRating -> ActiveRoom
  -> 설정 아이콘 -> RoomSettings -> 지역/태그 변경 -> ActiveRoom
  -> 통합 영수증 -> ReceiptRegister -> 사진 촬영/갤러리/수동 입력 -> Receipts
  -> 분할 영수증 -> ReceiptRegister -> 사진 촬영/갤러리/수동 입력 -> Receipts
```

## 화면별 역할과 버튼

### 1. Splash

파일: `lib/features/splash/splash_screen.dart`

역할:
- 앱 진입 로딩 화면.
- 1.1초 뒤 로그인 화면으로 자동 이동.

버튼/동작:

| UI | 동작 |
|---|---|
| 자동 타이머 | `LoginScreen`으로 이동 |

### 2. Login

파일: `lib/features/auth/login_screen.dart`

역할:
- 일반 로그인/카카오 로그인 진입.
- 회원가입 화면 진입.

버튼/동작:

| UI | 동작 |
|---|---|
| 로그인 | `HomeScreen`으로 이동 |
| 카카오로 시작하기 | `HomeScreen`으로 이동 |
| 아직 계정이 없나요? 회원가입 | `SignupScreen`으로 이동 |

### 3. Signup

파일: `lib/features/auth/signup_screen.dart`

역할:
- 프로토타입용 회원가입 입력 화면.
- 닉네임, 이메일, 비밀번호, 성별, 나이를 받는다.

버튼/동작:

| UI | 동작 |
|---|---|
| 뒤로가기 | `LoginScreen`으로 이동 |
| 성별/나이 입력 | 프로토타입 입력 UI. 추후 `users.gender`, `users.age_range`로 저장 |
| 회원가입 완료 | `LoginScreen`으로 이동 |

### 4. Home / 거지방

파일: `lib/features/home/home_screen.dart`

역할:
- 친구/지인과 만든 거지방 목록.
- 친구방 생성 흐름 시작.

버튼/동작:

| UI | 동작 |
|---|---|
| 상단 헤더 | 로고 + `거지방` 화면 제목 |
| 알림 아이콘 | 미연결 |
| 검색 박스 | 미연결 |
| 방 카드 | `ActiveRoomScreen`으로 이동, 하단바 출발 탭은 홈 |
| 새 친구방 만들기 | `CreateRoomScreen`으로 이동, 하단바 출발 탭은 홈 |

### 5. Community / 커뮤니티

파일: `lib/features/community/community_screen.dart`

역할:
- 모든 사용자가 함께 쓰는 커뮤니티 공간.
- 전체 채팅방과 게시판을 보여준다.
- 게시판은 인기글/최신글/절약팁/질문 탭으로 나눈다.

버튼/동작:

| UI | 동작 |
|---|---|
| 알림 아이콘 | 미연결 |
| 검색 박스 | 미연결 |
| 전체 채팅방 카드 | `CommunityChatScreen`으로 이동 |
| 게시판 탭 | 프로토타입 표시 UI. 추후 목록 필터링 |
| 글쓰기 | `CommunityPostWriteScreen`으로 이동 |
| 게시글 카드 | `CommunityPostDetailScreen`으로 이동 |

### 5-1. CommunityChat / 전체 채팅방

파일: `lib/features/community/community_chat_screen.dart`

역할:
- 모든 사용자가 함께 쓰는 전체 채팅방.

버튼/동작:

| UI | 동작 |
|---|---|
| 뒤로가기 | `CommunityScreen`으로 복귀 |
| 메시지 입력 바 | 최상위 하단 오버레이. 탭 시 키보드가 올라오고 입력 바도 함께 올라감 |

### 5-2. CommunityPostDetail / 게시글

파일: `lib/features/community/community_post_detail_screen.dart`

역할:
- 게시글 본문과 댓글을 보여준다.

버튼/동작:

| UI | 동작 |
|---|---|
| 뒤로가기 | `CommunityScreen`으로 복귀 |

### 5-3. CommunityPostWrite / 글쓰기

파일: `lib/features/community/community_post_write_screen.dart`

역할:
- 커뮤니티 게시글을 작성한다.

버튼/동작:

| UI | 동작 |
|---|---|
| 뒤로가기 | `CommunityScreen`으로 복귀 |
| 카테고리 칩 | 프로토타입 선택 UI |
| 게시하기 | `CommunityScreen`으로 복귀 |

### 6. CreateRoom / 새 거지방 만들기

파일: `lib/features/room/create_room_screen.dart`

역할:
- 모임 위치, 모임 카테고리, 참여 인원 설정.
- 친구방 생성 폼으로 사용 중.

버튼/동작:

| UI | 동작 |
|---|---|
| 뒤로가기 | `HomeScreen` |
| 카테고리: 한식/양식/일식/중식/기타 요식업 | 현재 선택 상태 미연결 |
| 참여 인원 -/+ | 현재 카운트 변경 미연결 |
| 방 만들기 | `InviteRoomScreen`으로 이동 |

### 7. InviteRoom / 친구 초대

파일: `lib/features/room/invite_room_screen.dart`

역할:
- 생성한 방 링크와 입장 현황 확인.
- 예산 입력 단계로 진입.

버튼/동작:

| UI | 동작 |
|---|---|
| 뒤로가기 | `CreateRoomScreen`으로 이동 |
| 초대 링크 박스 | 미연결, 복사/공유 역할 후보 |
| 예산 입력 시작 | `BudgetInputScreen`으로 이동 |

### 8. BudgetInput / 예산 입력

파일: `lib/features/budget/budget_input_screen.dart`

역할:
- 내 예산 입력.
- 참여자별 예산 제출 상태 확인.

버튼/동작:

| UI | 동작 |
|---|---|
| 뒤로가기 | `InviteRoomScreen`으로 이동 |
| 금액 입력 박스/수정 아이콘 | 현재 입력 수정 미연결 |
| 입력 완료 | `BudgetResultScreen`으로 이동 |

### 9. BudgetResult / 예산 결정 완료

파일: `lib/features/budget/budget_result_screen.dart`

역할:
- 모든 참여자의 예산 제출 후 총예산 결과 확인.

버튼/동작:

| UI | 동작 |
|---|---|
| 뒤로가기 | `BudgetInputScreen`으로 이동 |
| 추천 보기 | `RecommendationScreen`으로 이동 |

### 10. Recommendation / 예산에 맞는 추천

파일: `lib/features/recommendation/recommendation_screen.dart`

역할:
- 백엔드 추천 API에서 받은 착한가격업소 기반 추천 장소 목록 확인.
- 현재 1차 연결값은 `roomNo=1`, `tag=식사`, `region=서울특별시 중구` 고정이다.
- 추천 카드는 업소명, 업종, 주소, 최저 가격, 카테고리 기본 이미지, 카카오맵 지도 버튼을 표시한다.
- 거지방 내부 화면으로 진입.

버튼/동작:

| UI | 동작 |
|---|---|
| 뒤로가기 | `BudgetResultScreen`으로 이동 |
| 위치 변경 | 미연결 |
| 추천 카드 지도 버튼 | `url_launcher`로 백엔드 응답의 `mapUrl`을 외부 앱/브라우저에서 열기 |
| 안내 카드 화살표 | 미연결 |
| 거지방 시작하기 | `ActiveRoomScreen`으로 이동 |

### 11. ActiveRoom / 거지방 내부

파일: `lib/features/room/active_room_screen.dart`

역할:
- 실제 방 내부 화면.
- 오늘의 예산, 상단 상시 추천, 업로드된 영수증, 하단 고정 영수증 등록, 다음 코스 고르기, 방 종료 진입을 보여준다.

버튼/동작:

| UI | 동작 |
|---|---|
| 뒤로가기 | `HomeScreen` |
| 설정 아이콘 | `RoomSettingsScreen`으로 이동 |
| 거지평가 보기 | 해당 방 안에서만 계산되는 거지평가 화면으로 이동 |
| 추천 카드 페이지 이동 `1 / 3 ->` | 미연결 |
| 하단 고정 통합 영수증 | 한 식당/장소에서 한 번에 결제한 한 장의 영수증 등록 모드로 이동 |
| 하단 고정 분할 영수증 | 같은 식당/장소에서 각자 계산해 여러 장으로 나뉜 영수증 등록 모드로 이동 |
| 다음 코스 고르기: 한식/양식/일식/중식/기타 요식업 | 태그를 바꾸면 남은 예산 기준 추천 후보를 갱신하는 영역 |
| 오늘 방 종료하기 | 모임 종료/리포트 생성 후보 플로우로 이동 예정 |

### 12. RoomSettings / 거지방 설정

파일: `lib/features/room/room_settings_screen.dart`

역할:
- 거지방 코드와 현재 참여 인원을 확인한다.
- 반장은 최대 인원 제한을 변경할 수 있다.
- 거지방의 지역과 추천 태그를 변경한다.

버튼/동작:

| UI | 동작 |
|---|---|
| 뒤로가기 | `ActiveRoomScreen`으로 복귀 |
| 거지방 코드 | 초대/공유용 방 코드 확인 |
| 현재 참여 인원 | 현재 인원/최대 인원 확인 |
| 최대 인원 -/+ | 반장만 인원 제한 변경. 현재 참여 인원보다 낮게 줄일 수 없고 최대 100명 |
| 지역 입력 | 프로토타입 입력 UI. 추후 방 지역/좌표 업데이트 |
| 태그: 한식/양식/일식/중식/기타 요식업 | 추천 태그 변경 |
| 설정 저장 | `ActiveRoomScreen`으로 복귀 |

### 13. ReceiptRegister / 영수증 등록

파일: `lib/features/receipts/receipt_register_screen.dart`

역할:
- 통합/분할 영수증 모드에 맞춰 등록 방법을 고른다.
- 실제 카메라/갤러리/입력 연동 전 프로토타입 선택 화면이다.

버튼/동작:

| UI | 동작 |
|---|---|
| 뒤로가기 | `ActiveRoomScreen`으로 이동 |
| 사진 촬영 | 현재는 `ReceiptsScreen`으로 이동, 추후 카메라 촬영 연결 |
| 갤러리에서 가져오기 | 현재는 `ReceiptsScreen`으로 이동, 추후 이미지 선택 연결 |
| 수동 입력 | 현재는 `ReceiptsScreen`으로 이동, 추후 직접 입력 폼 연결 |

### 14. Receipts / 모든 지출 내역

파일: `lib/features/receipts/receipts_screen.dart`

역할:
- 개인 지출 내역 확인.
- 현재는 마이 화면 또는 방 내부에서 진입 가능.

버튼/동작:

| UI | 동작 |
|---|---|
| 뒤로가기 | 진입 전 화면으로 복귀 (`MyPageScreen` 또는 `ActiveRoomScreen`) |
| 알림 아이콘 | 미연결 |
| 최신순 정렬 | 미연결 |
| 지출 카드 | 미연결 |

### 15. Ranking / 거지 랭킹

파일: `lib/features/home/ranking_screen.dart`

역할:
- 하단 탭에서 전체 거지 랭킹 목록 확인.

버튼/동작:

| UI | 동작 |
|---|---|
| 랭킹 리스트 아이템 | 미연결 |

### 16. RoomRating / 거지방 평가

파일: `lib/features/room/room_rating_screen.dart`

역할:
- 특정 거지방 안에서만 계산되는 방 공동 점수를 확인한다.
- 전체 랭킹과 연동하지 않는다.
- 데이터 기준은 `room_no` 단위의 `room_beggar_scores`.

버튼/동작:

| UI | 동작 |
|---|---|
| 뒤로가기 | `ActiveRoomScreen`으로 복귀 |

### 17. MyPage / 마이페이지

파일: `lib/features/auth/my_page_screen.dart`

역할:
- 내 프로필, 계정 정보, 개인 지출 내역 진입.

버튼/동작:

| UI | 동작 |
|---|---|
| 칭호 변경 | 미연결, 보유 칭호 선택 화면 후보 |
| 프로필 사진 변경 | 미연결 |
| 이메일 확인 | 미연결 |
| 지출 내역 | `ReceiptsScreen`으로 이동, 뒤로가기는 마이페이지 |
| 로그아웃 | `LoginScreen`으로 이동 |
| 탈퇴하기 | 미연결 |

## 다음에 같이 정해야 할 것

1. 사진 촬영/갤러리/수동 입력을 실제 기능 화면으로 각각 분리할지, 하나의 입력 화면에서 방식만 다르게 처리할지.
2. 추천 카드 선택, `1 / 3`, 태그 변경의 실제 상태 변화.
3. 방 종료 후 리포트 화면을 바로 보여줄지, 종료 확인 모달을 먼저 띄울지.
4. 검색, 정렬, 알림, 설정, 로그아웃/탈퇴의 우선순위.
