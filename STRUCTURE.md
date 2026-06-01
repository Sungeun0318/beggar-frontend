# 프론트엔드 파일 구조 & 기능 설명

> `frontend/lib/` 내 61개 Dart 파일의 역할, 화면 구성, 기능, 의존성 정리
> 마지막 갱신: 2026-05-30 (화면 제목 중심 상단 헤더, 커뮤니티, 거지방 설정/다음 코스 구조 반영)

---

## 전체 구조

```
lib/
├── main.dart                       앱 진입점
├── prototype_shell.dart            18개 페이지 전환 셸 (추후 go_router로 교체)
├── core/
│   ├── theme/
│   │   ├── app_colors.dart         색상 토큰
│   │   └── assets.dart             이미지 경로 상수
│   ├── utils/
│   │   ├── formatters.dart         money() — 천단위 콤마
│   │   └── decorations.dart        softBox() — 공용 카드 데코
│   └── config/
│       └── api_config.dart         baseUrl, Kakao key
├── data/
│   ├── models/                     도메인 모델 (User, Room, Member, BudgetResult, Receipt)
│   ├── mock/mock_db.dart           샘플 데이터 인스턴스
│   ├── api/api_client.dart         HTTP 클라이언트 (TODO — dio 미도입)
│   ├── auth/
│   │   ├── kakao_auth_service.dart 카카오 SDK 래퍼 (TODO — Kakao SDK 미연동)
│   │   └── token_storage.dart      JWT 저장 (shared_preferences 구현 완료)
│   └── repositories/               4개 추상 인터페이스 (TODO 구현체)
├── shared/widgets/                 공용 위젯 16개
└── features/                       화면 13개 (도메인별 폴더, placeholder 포함)
```

### 화면 구현 상태 요약

| 화면 | 파일 | 백엔드 연동 |
|---|---|---|
| 스플래시 | `splash/splash_screen.dart` | 자동 로그인 분기 TODO |
| 로그인 | `auth/login_screen.dart` | KakaoAuthService TODO |
| 회원가입 | `auth/signup_screen.dart` | AuthRepository TODO |
| 마이페이지 | `auth/my_page_screen.dart` | 사용자 정보/로그아웃 TODO |
| 홈 | `home/home_screen.dart` | RoomRepository.myRooms TODO |
| 랭킹 | `home/ranking_screen.dart` | 거지력 지수 API TODO |
| 거지방 생성 | `room/create_room_screen.dart` | RoomRepository.create TODO |
| 친구 초대 | `room/invite_room_screen.dart` | 입장 현황 폴링 TODO |
| 진행 중 | `room/active_room_screen.dart` | 실시간 지출 동기화 TODO |
| 영수증 등록 | `receipts/receipt_register_screen.dart` | 카메라/갤러리/수동 입력 TODO |
| 예산 입력 | `budget/budget_input_screen.dart` | BudgetRepository.submit TODO |
| 예산 결과 | `budget/budget_result_screen.dart` | BudgetRepository.result TODO |
| 추천 | `recommendation/recommendation_screen.dart` | Spring 추천 API 1차 연결 완료 |
| 커뮤니티 | `community/community_screen.dart` | CommunityRepository TODO |
| 지출 내역 | `receipts/receipts_screen.dart` | 마이 화면 내부 진입, ReceiptRepository.listAll TODO |
| (기타 탭 placeholder) | `placeholders/placeholder_tab_screen.dart` | 사실상 사용 안 함 |

---

## 진입점

### `lib/main.dart`
앱 부트스트랩.
- `WidgetsFlutterBinding.ensureInitialized()` → 세로 모드 잠금 → 시스템 UI 오버레이 색 설정 → `runApp()`
- `BeggarPrototypeApp`: `MaterialApp` 루트. 테마: Material3 + Pretendard 폰트 + `AppColors.bg` 배경.
- `home`은 `PrototypeShell`. 추후 백엔드 연동 시 인증 상태에 따라 splash/login/home 라우팅으로 교체 예정.

### `lib/prototype_shell.dart`
18개 페이지를 enum으로 관리하는 임시 셸. 추후 `go_router`로 교체.
- `enum PrototypePage`: splash, login, signup, home, community, communityChat, communityPostDetail, communityPostWrite, createRoom, invite, budgetInput, budgetResult, recommendation, activeRoom, roomRating, roomSettings, receiptRegister, receipts, ranking, myPage
- `receipts`는 하단 탭이 아니라 `myPage`/방 내부에서 진입하는 개인 지출 화면
- `_PrototypeShellState`: `_page` 상태와 `_go(PrototypePage)` 메서드로 화면 전환
- `BottomNav` 표시 조건: splash/login/signup, 커뮤니티 하위 화면, 방 내부/방 평가/방 설정/영수증 등록 제외
- `RoomReceiptBar`: 방 내부에서만 최상위 Stack 하단에 고정되는 통합/분할 영수증 바
- `CommunityMessageBar`: 전체 채팅방에서만 최상위 Stack 하단에 고정되는 메시지 입력 바
- `_activeIndex` 목표 구조: 홈=0, 커뮤니티=1, 랭킹=2, 마이=3
- 방 생성/참여 흐름은 하단 FAB 탭이 아니라 홈 화면의 CTA에서 진입

---

## core/

### `lib/core/theme/app_colors.dart`
앱 전역 색상 토큰. `class AppColors` 정적 상수 모음.
- 핵심: `bg`(#FDFBF7), `canvas`(#F3EFE6), `text`(#2C241B), `accent`(#D4AF37 골드), `brown`(#C69C6D)
- 보조: `sub`, `lightSub`, `placeholder`, `border`, `muted`, `accentBg`, `danger`
- `goldGradient`: accent → brown 그라데이션 (PrimaryButton, FAB 추가 버튼에 사용)

### `lib/core/theme/assets.dart`
이미지 에셋 경로 문자열 상수. `class Assets`.
- 로고: `logo`
- 영수증 더미: `receiptFood`, `receiptCafe`, `receiptBrunch`
- 추천 카드 이미지: `recoFood`, `recoCafe`, `recoGame`
- 마스코트: `mascotCelebration` (예산 결과 화면), `mascotSmall` (초대/추천 화면)

### `lib/core/utils/formatters.dart`
- `money(int value) → String`: 정수를 "1,234,567" 형식 천단위 콤마 문자열로 변환. `intl` 패키지 의존 없이 직접 구현.

### `lib/core/utils/decorations.dart`
- `softBox({Color color, double radius, bool shadow}) → BoxDecoration`: 카드/입력박스에 공통으로 쓰는 둥근 사각형 데코. 흰 배경+회색 테두리가 기본, accentBg 색일 때 테두리 색이 자동으로 바뀜. `shadow:true`면 30 blur의 부드러운 그림자 추가.

### `lib/core/config/api_config.dart`
백엔드/카카오 환경 설정. `class ApiConfig`.
- `baseUrl`: `--dart-define=API_BASE_URL=...`로 주입, 기본값 `http://10.0.2.2:8080` (Android 에뮬레이터 → 호스트 localhost)
- `kakaoNativeAppKey`: `--dart-define=KAKAO_NATIVE_APP_KEY=...`
- `connectTimeout` 10s, `receiveTimeout` 15s

---

## data/

### models/ — 백엔드 DTO와 1:1 매핑되는 도메인 모델
각 클래스에 `fromJson` / `toJson` 포함 → API 응답 디시리얼라이즈 즉시 사용 가능.

#### `lib/data/models/user.dart`
- 필드: `no`(int), `name`(String), `email`(String)
- 카카오/로컬 로그인 후 백엔드에서 받은 사용자 프로필 표현. DB 식별은 이메일 기준

#### `lib/data/models/room.dart`
- 필드: `no`, `ownerNo`, `name`, `code`(초대 코드), `location`, `tags`(List<String>), `memberCount`, `maxMemberCount`
- 거지방 한 개를 표현. 홈 카드/초대 화면/진행 중 화면에서 사용

#### `lib/data/models/member.dart`
- 필드: `name`, `status`(예산 입력 상태), `mine`(현재 사용자 여부)
- 방 참여자. 초대 화면, 예산 입력 화면에서 입장/제출 현황 표시

#### `lib/data/models/budget_result.dart`
- 필드: `minBudgetPerPerson`, `memberCount`, `totalBudget`
- 익명 예산 제출 후 계산된 결과 (최저 제출 금액 × 인원수)

#### `lib/data/models/receipt.dart`
- 필드: `date`, `room`(방 이름), `image`, `title`, `amount`(int)
- 지출 영수증 한 건

### mock/

#### `lib/data/mock/mock_db.dart`
화면 프로토타입용 샘플 데이터 모음. 모두 `const` 인스턴스.
- `currentUser`: 거지판다 (id 3, 이메일 기반 mock)
- `room`: 명학역 데이트 (4명, 최대 8명, 한식+양식+기타 요식업)
- `members`: 4명 (모두 제출 완료)
- `budgetResult`: 1인 15,000 × 4명 = 60,000원
- `receipts`: 3건 (정성한식 35k, 블루보틀 14k, 오아시스 52k)
- **백엔드 연동 시 점진적으로 Repository 호출로 교체**

### api/

#### `lib/data/api/api_client.dart`
HTTP 클라이언트 래퍼. **TODO**: 패키지 결정(`dio` 권장) 후 구현.
- 인터셉터: `TokenStorage`에서 JWT 읽어 Authorization 헤더에 주입
- 401 응답 시 refresh 토큰으로 재발급 또는 로그아웃
- 메서드 시그니처만 정의됨 (`get`, `post`)

### auth/

#### `lib/data/auth/kakao_auth_service.dart`
카카오 로그인 SDK 래퍼. **TODO**: `kakao_flutter_sdk_user` 패키지 추가 후 구현.
- `signInWithKakao()`: `isKakaoTalkInstalled` 확인 → `loginWithKakaoTalk` or `loginWithKakaoAccount` → OAuth 토큰 반환
- 받은 토큰을 Spring 백엔드 `/auth/kakao`로 POST → 자체 JWT 받기
- `signOut()`: SDK 로그아웃 + TokenStorage clear

#### `lib/data/auth/token_storage.dart`
JWT 액세스/리프레시 토큰 영속화. **구현 완료** (shared_preferences 사용).
- `saveTokens({accessToken, refreshToken})`
- `readAccessToken()` / `readRefreshToken()`
- `clear()`: 로그아웃 시 호출

### repositories/ — 도메인 추상 인터페이스 (Mock/API 두 구현체 갈아끼우는 시점)

#### `lib/data/repositories/auth_repository.dart`
- `signInWithEmail`, `signInWithKakao`, `signUp`, `signOut`, `currentUser`

#### `lib/data/repositories/room_repository.dart`
- `myRooms`, `create`, `join(code)`, `members(roomNo)`

#### `lib/data/repositories/budget_repository.dart`
- `submit({roomNo, amount})`, `result(roomNo)`

#### `lib/data/repositories/receipt_repository.dart`
- `listAll`, `listByRoom(roomNo)`, `create({roomNo, title, amount, imagePath})`

---

## shared/widgets/ — 공용 위젯 16개

### `lib/shared/widgets/figma_frame.dart`
디자인 393×852 기준 캔버스를 실제 화면 크기에 맞춰 비례 스케일링하는 컨테이너. 모든 화면의 최상위.
- `FigmaFrame({child, height = 852})`: width 393 기준, height는 화면별 가변
- `maxScale = 1.06`: 너무 큰 화면에서 과대 확대 방지
- `StatusRow`: 빈 위젯 (이전 상태바 placeholder, 현재 사용 안 됨)

### `lib/shared/widgets/app_header.dart`
공용 상단 헤더.
- `AppHeader.brand({title, onBack?, showNotification, onNotification?})`: 로고 + 화면 제목 + 옵션 뒤로가기/알림. 메인 탭 화면은 화면 제목 중심으로 표시한다.
- `AppHeader.titled({title, onBack})`: 뒤로가기 + 가운데 정렬 제목. 서브 화면 표준 헤더.
- 공통 위치: `top: AppSpacing.headerTop - 16`, `left/right: AppSpacing.pageH`, `height: AppSpacing.headerHeight`

### `lib/shared/widgets/bottom_nav.dart`
하단 4탭 구조로 정리 예정.
- 목표 시그니처: `BottomNav({activeIndex, onHome, onCommunity, onRanking, onMy})`
- 4개 탭: 홈 / 커뮤니티 / 랭킹 / 마이
- 기존 지출 탭은 제거하고, `ReceiptsScreen`은 마이 화면 내부 메뉴로 이동
- 기존 가운데 FAB는 하단바에서 제거하고, 방 만들기 CTA는 홈 화면 본문에 배치
- `NavItem`: 아이콘 + 라벨, 활성 시 `AppColors.text`, 비활성 시 `lightSub`

### `lib/shared/widgets/primary_button.dart`
앱 전역 메인 CTA 버튼.
- `PrimaryButton({label, onTap, enabled = true})`
- 높이 60, 골드 그라데이션 + 골드 그림자
- `enabled=false`면 회색 + 그림자 제거

### `lib/shared/widgets/section_title.dart`
- `SectionTitle(text)`: 17pt w600 표준 섹션 헤더 텍스트

### `lib/shared/widgets/input_like.dart`
입력처럼 보이지만 실제 입력 안 받는 정적 박스 (프로토타입용 placeholder).
- `InputLike({label, icon})`: 높이 56, softBox + placeholder 색 텍스트 + 오른쪽 아이콘
- 실제 TextField 교체 시 이 위젯을 TextFormField로 대체

### `lib/shared/widgets/info_card.dart`
강조 정보 카드 (accentBg 배경).
- `InfoCard({icon, title, body?})`: body 유무에 따라 높이/아이콘 크기 자동 조정 (67 / 107)
- 사용처: 회원가입 안내, 방 생성 익명 안내, 초대 화면 카톡 안내, 예산 결과 익명 보호 안내

### `lib/shared/widgets/choice_box.dart`
방 카테고리 선택 박스 (`한식/양식/일식/중식/기타 요식업`).
- `ChoiceBox({icon, label})`: softBox + 가로 중앙 정렬 아이콘+텍스트
- 방 생성 화면 GridView에서 2×2로 배치

### `lib/shared/widgets/round_icon.dart`
인원 카운터의 +/- 원형 버튼.
- `RoundIcon({icon})`: 40px 원, muted 배경, sub 색 아이콘

### `lib/shared/widgets/chip_label.dart`
작은 라벨 칩.
- `ChipLabel({icon, label})`: 12px 아이콘 + 11pt 라벨, 둥근 모서리 14, 흐린 테두리
- 사용처: 영수증 카드 우상단 방 이름, 진행 중 화면 위치 표시

### `lib/shared/widgets/participant_tile.dart`
참여자 한 명 행.
- `ParticipantTile({name, status, active})`
- 높이 58, 왼쪽 아바타 아이콘 + 이름 + 우측 상태 텍스트 + 상태 아이콘
- `active=true`(나/입력 중)면 accent 색, `false`(완료)면 sub 색

### `lib/shared/widgets/summary_row.dart`
- `SummaryRow({icon, label, trailing?, bg})`: 추천 화면 상단의 "위치/예산" 한 줄 요약
- `trailing` 있으면 우측에 muted 칩 버튼 ("변경" 등)

### `lib/shared/widgets/recommendation_card.dart`
가게 추천 카드.
- `RecommendationCard({image, tag, title, walk, rating, amount, tagBg, tagColor, onMapTap?})`
- 높이 146, 왼쪽 94×94 이미지 + 우측 텍스트 영역 (태그 배지, 업소명, 대표 메뉴명, 가격, 주소/도보정보)
- 우상단 카드 내부 `착한가격업소` 띠를 포함한다.
- 카드 전체 클릭 시 `onMapTap`을 호출한다.
- 사용처: 추천 화면

### `lib/shared/widgets/receipt_card.dart`
영수증 한 건 카드.
- `ReceiptCard({date, room, image, title, amount})`
- 높이 138, 상단 날짜+ChipLabel, 디바이더, 하단 이미지+제목+금액(danger 색)

### `lib/shared/widgets/room_home_card.dart`
홈 화면의 거지방 카드.
- `RoomHomeCard({title, location, budget, spent, memberCount, status, onTap})`
- 높이 158, 상단 제목+상태 칩, 위치 정보, 하단 사용액/총액 + 프로그레스 바
- `ratio = spent / budget`으로 골드 LinearProgressIndicator 채움

### `lib/shared/widgets/action_box.dart`
영수증 등록 방식 액션 박스 (사진 촬영 / 갤러리에서 가져오기 / 수동 입력).
- `ActionBox({icon, title, body, onTap})`: 높이 104, 좌상단 아이콘 + 하단 제목/설명
- 사용처: `ReceiptRegisterScreen`

### `lib/shared/widgets/flow_step.dart`
번호 표시 단계 행. **현재 어떤 화면에서도 사용 안 됨** (가입 흐름 설명용 placeholder로 보존).
- `FlowStep({index, title, body})`

---

## features/ — 화면 13개 (+ placeholder 위젯 1개)

### splash/

#### `lib/features/splash/splash_screen.dart`
**스플래시**. 앱 진입 시 1.1초 보여주고 자동 로그인 화면 이동.
- 가운데: 118px 로고 + "거지 우정 수호대" + "Save My Friendship" + 골드 로딩 스피너
- 하단: "익명 예산 조율을 준비하고 있어요"
- props: `onDone` (1.1초 후 자동 호출)
- **백엔드 연동 시**: `TokenStorage.readAccessToken()`으로 자동 로그인 분기

### auth/

#### `lib/features/auth/login_screen.dart`
**로그인**. 일반 로그인 + 카카오 로그인 + 회원가입 진입.
- 상단: 로고 + 타이틀 + "친구의 자존심을 지키는 익명 예산 조율"
- 일반 로그인 카드: 이메일(`MockDb.currentUser.email` 미리채움) + 비밀번호 + 로그인 버튼
- 하단: 노란색(#FEE500) 카카오 로그인 박스 + "아직 계정이 없나요? 회원가입" 링크
- props: `onLogin`, `onSignup`
- **백엔드 연동 시**: `KakaoAuthService.signInWithKakao()` → `AuthRepository.signInWithKakao()`

#### `lib/features/auth/signup_screen.dart`
**회원가입**. 닉네임/이메일/비밀번호/성별/나이 입력 + 익명 보호 안내.
- 헤더: 뒤로가기 + "회원가입"
- "처음 오셨나요?" + 설명
- 입력 필드: 닉네임 / 이메일 / 비밀번호 / 성별 / 나이 (모두 `InputLike` 정적 placeholder)
- 안내 카드: "예산 정보는 익명으로 보호돼요"
- 성별/나이: 추후 `users.gender`, `users.age_range` 저장
- 하단: "회원가입 완료" 버튼 → `onComplete` (로그인으로 복귀)
- props: `onBack`, `onComplete`

### home/

#### `lib/features/home/home_screen.dart`
**홈 (거지방 목록)**. 친구/지인과 함께 쓰는 거지방 목록 메인 화면.
- 상단: 로고 + "거지방" 화면 제목 + 알림 벨
- 설명 문구 + 검색 박스(정적)
- 거지방 카드 2개: "명학역 데이트" (mock) + "전시 보러 가요" (하드코딩)
- 하단: "새 친구방 만들기" 박스 (accent 배경, 탭 시 방 생성으로)
- props: `onOpenRoom`, `onCreate`

### community/

#### `lib/features/community/community_screen.dart`
**커뮤니티**. 모든 사용자가 같이 쓰는 채팅/게시글 공간.
- 하단 탭 2번째 "커뮤니티"에서 진입
- 전체 채팅방 카드 + 게시판 탭 + 게시글 카드 구성
- 게시판 탭: 인기글 / 최신글 / 절약팁 / 질문
- 글쓰기 버튼으로 커뮤니티 게시글 작성 화면 진입
- 방 생성/예산 흐름과 분리된 사용자 간 소통 공간
- props: `onOpenChat`, `onOpenPost`, `onWritePost`
- **백엔드 연동 시**: `CommunityRepository.posts()` / `CommunityRepository.chatMessages()` 후보

#### `lib/features/community/community_chat_screen.dart`
**전체 채팅방**. 모든 사용자가 함께 쓰는 실시간 채팅 공간.
- 헤더: 뒤로가기 + "전체 채팅방"
- 안내 카드 + 채팅 메시지 목록
- `CommunityMessageBar`: `PrototypeShell` 최상위 Stack에서 렌더링되는 실제 화면 하단 입력 바. `TextField`라 탭 시 키보드가 올라오고, `viewInsets` 기준으로 입력 바가 함께 올라간다.
- props: `onBack`

#### `lib/features/community/community_post_detail_screen.dart`
**게시글 상세**. 게시글 본문과 댓글 목록.
- 헤더: 뒤로가기 + "게시글"
- 게시글 카드 + 댓글 목록
- props: `onBack`

#### `lib/features/community/community_post_write_screen.dart`
**게시글 작성**. 커뮤니티 게시글 작성 화면.
- 카테고리 칩: 절약팁 / 질문 / 같이해요
- 제목/내용 입력 UI
- 하단: "게시하기" 버튼 → 커뮤니티 메인 복귀
- props: `onBack`, `onSubmit`

### room/

#### `lib/features/room/create_room_screen.dart`
**거지방 생성**. 모임 정보 입력.
- 헤더: "새 거지방 만들기"
- "어디서 모이나요?" → InputLike (강남역, 홍대입구 예시)
- "어떤 모임인가요?" → 2×2 GridView + 기타 요식업 (한식/양식/일식/중식/기타 요식업)
- "몇 명이서 모이나요?" → 카운터 (RoundIcon - / 숫자 / RoundIcon +), 최소 2~최대 100명 안내
- 익명 수집 안내 InfoCard
- 하단: "방 만들기" 버튼 → `onNext` (초대 화면으로)
- props: `onBack`, `onNext`

#### `lib/features/room/invite_room_screen.dart`
**친구 초대**. 방 정보 + 초대 링크 + 입장 현황.
- 헤더: "친구 초대"
- accentBg 카드: 마스코트 + 방 이름 + 위치/인원 + 초대 링크 (`beggar.app/join/{code}`)
- "입장 현황" 섹션: `MockDb.members` 4명의 `ParticipantTile` (본인은 "방장", 나머지는 "입장 완료")
- "카톡 링크 공유만 사용해요" 안내 카드
- 하단: "예산 입력 시작" 버튼 → `onNext`
- props: `onBack`, `onNext`

#### `lib/features/room/active_room_screen.dart`
**거지방 내부**. 방 운영 중 추천/영수증 등록 화면.
- 상단: 뒤로가기 + 방 이름(21pt w900) + 설정 아이콘
- 오늘의 예산 요약 + 추천 카드 + 업로드된 영수증 미리보기
- 다음 코스 고르기: 태그 칩(한식/양식/일식/중식/기타 요식업) + 남은 예산 기준 추천 카드
- 하단 고정 영수증 바 + 통합 영수증/분할 영수증 버튼
- 통합 영수증: 한 식당/장소에서 한 번에 결제한 한 장의 영수증
- 분할 영수증: 같은 식당/장소에서 각자 계산해 여러 장으로 나뉜 영수증
- 통합/분할 선택 후 `ReceiptRegisterScreen`으로 이동
- 설정 아이콘 선택 후 `RoomSettingsScreen`으로 이동
- props: `onBack`, `onOpenRating`, `onOpenSettings`

#### `lib/features/room/room_settings_screen.dart`
**거지방 설정**. 방 내부 설정 아이콘에서 진입.
- 헤더: 뒤로가기 + "거지방 설정"
- 거지방 정보: 방 코드 + 현재 참여 인원/최대 인원 표시
- 인원 제한: 반장만 최대 인원 변경 가능
- 지역 변경: 현재 지역 입력 UI
- 추천 태그 변경: 한식 / 양식 / 일식 / 중식 / 기타 요식업
- 하단: "설정 저장" 버튼 → `ActiveRoomScreen` 복귀
- **백엔드 연동 시**: `PATCH /rooms/{no}` 또는 `PATCH /rooms/{no}/settings`로 지역/태그/최대 인원 업데이트

### receipts/

#### `lib/features/receipts/receipt_register_screen.dart`
**영수증 등록 방법 선택**. 통합/분할 모드별로 등록 방식을 고른다.
- 사진 촬영: 카메라로 영수증을 바로 찍는 흐름
- 갤러리에서 가져오기: 이미 찍어둔 사진을 선택하는 흐름
- 수동 입력: 금액/내용을 직접 입력하는 흐름
- 현재 프로토타입에서는 세 선택지 모두 `ReceiptsScreen`으로 이동

### budget/

#### `lib/features/budget/budget_input_screen.dart`
**예산 입력**. 익명으로 본인 예산 제출.
- 헤더: "예산 입력"
- 정보 카드 (accentBg): 방 이름 + 위치/인원
- "내 예산을 입력해주세요" → 큰 숫자 박스 (15,000 + 원 + 편집 아이콘)
- "참여자 입력 현황" → 4명 ParticipantTile (거지님=입력 중, 나머지 3명=제출 완료)
- 안내: "시스템이 가장 낮은 제출 금액을 기준으로 오늘의 총예산을 계산해요"
- 하단: "입력 완료" 버튼 → `onNext`
- props: `onBack`, `onNext`

#### `lib/features/budget/budget_result_screen.dart`
**예산 결정 완료**. 총예산 결정 결과 표시.
- 헤더: "예산 결정 완료"
- 축하 마스코트 (120px) + 별/스파클 장식 3개
- 큰 카드: "4명이 모두 예산을 입력했어요!" + "1인 기준 최저 예산 15,000원" 칩 + **60,000원** 거대 텍스트 + "4명 × 15,000원" 계산식
- 익명 보호 InfoCard
- 하단: "추천 보기" 버튼 → `onNext` (추천 화면으로)
- props: `onBack`, `onNext`

### recommendation/

#### `lib/features/recommendation/recommendation_screen.dart`
**예산 맞춤 추천**. Spring 백엔드 추천 API에서 착한가격업소 후보를 받아 표시.
- 헤더: "예산에 맞는 추천"
- 입력값: `roomNo`, `initialTag`, `region`, `tags`
- 상단 요약: 선택 지역/현재 위치 + 1인 추천 예산 문구
- 위치 변경: 카카오 로컬 검색 결과 또는 현재 위치 좌표를 선택해 추천 API를 재호출
- 태그는 반장이 선택한 방 태그만 표시한다. 태그가 1개면 칩 영역을 숨기고, 여러 개면 선택된 태그들만 칩으로 보여준다.
- 태그 선택 시 `GET /rooms/{roomNo}/recommend?tag={tag}&region={region}&lat={lat}&lng={lng}&radius={radius}` 재호출
- 응답의 `recommendationBudget`, `budgetGuide`, `fallbackApplied`를 안내 문구로 표시
- 추천 카드:
  - `thumbnailUrl` 기본 이미지
  - 업소명, 업종, 대표 메뉴명(`menuName`), 가격(`expectedPrice`), 주소 표시
  - 우상단 카드 내부 착한가격업소 띠 표시
  - 카드 전체 클릭 시 카카오맵 이동 확인창 표시 후 `mapUrl` 열기
  - 긴 주소/가격은 말줄임 처리
- 마스코트 안내 카드: "남는 예산까지 고려한 조합을 추천해드려요!"
- 하단: "거지방 시작하기" 버튼 → `onDone` (진행 중 화면으로)
- props: `onBack`, `onDone`

### receipts/

#### `lib/features/receipts/receipts_screen.dart`
**모든 지출 내역**. 마이 화면 내부 메뉴 또는 진행 중 화면에서 진입.
- 상단: 로고 + "지출 내역" 화면 제목 + (옵션 뒤로가기) + 알림
- "모든 지출 내역" + "최신순" 정렬 표시
- 이번 달 총 지출 카드 (accentBg): "101,000원"
- 영수증 카드 3개 (날짜순):
  1. 2024.05.18 정성 한식 35,000원
  2. 2024.05.12 블루보틀 삼청 14,000원
  3. 2024.05.05 오아시스 한남 52,000원
- props: `onCreate`, `onBack?` (옵션)

### home/ (랭킹 추가)

#### `lib/features/home/ranking_screen.dart`
**거지 랭킹 (명예의 거지 전당)**. 하단 탭 3번째.
- 헤더: 로고 + "거지 랭킹" 화면 제목
- ListView.separated: 15명 (`AppSpacing.contentTop`부터, 카드 간격 10px, 하단 padding 120)
- 1~3위 메달 그라데이션 + 흰색 텍스트 + 추가 그림자
  - 1위: `#FFE7A2 → #FFFBD0` 골드
  - 2위: `#F4F4F4 → #8E8E8E` 실버
  - 3위: `#FFDBA9 → #D0701B` 브론즈
- 4위~: 일반 흰 배경 카드 (높이 79, radius 16)
- 행 구성: `{rank}위` 25pt → 아바타 원(44px) → 이름 15pt w700 → trophy/face 아이콘 40px
- **현재 mock**: 1~3위 "박진감", 4위 이하 "거지가 아닙니다"로 하드코딩
- **백엔드 연동 시**: `/api/ranking?limit=15` 등에서 거지력 지수 기준 정렬된 사용자 받아오기

### auth/ (마이페이지 추가)

#### `lib/features/auth/my_page_screen.dart`
**마이 페이지**. 하단 탭 4번째 (가장 우측).
- 헤더: 로고 + "마이페이지" 화면 제목
- SingleChildScrollView (`AppSpacing.contentTop`, 좌우 padding 24)
- 프로필 카드 (accentBg, 높이 98)
  - 좌측: 흰 원형 아바타 78px (face 아이콘)
  - 우측: 현재 칭호 + `님`, 이메일
- 메뉴 카드 4개 (높이 76, 좌측 54px 아이콘 박스 + 제목/서브타이틀)
  1. 칭호 변경 (`emoji_events_outlined`)
  2. 프로필 사진 변경 (`folder_shared_outlined`)
  3. 이메일 확인 (`mail_outline`, subtitle = `currentUser.email`)
  4. 지출 내역 (`receipt_long_outlined`) → `ReceiptsScreen`
- 이미지 갤러리 placeholder 2칸 제거. 칭호는 프로필 카드에 표시하고 변경은 메뉴에서 진입한다.
- 계정 섹션 (흰 카드 + 미세 그림자)
  - 계정 생성일 "2026.05.05" 하드코딩
  - 디바이더
  - 로그아웃 (16pt sub)
  - 탈퇴하기 (13pt 흐린 갈색 `#3D8C7E6A`)
- **현재 mock**: 사용자 정보는 `MockDb.currentUser`, 생성일은 텍스트 상수
- **백엔드 연동 시**: 로그아웃 탭 → `KakaoAuthService.signOut()` + `TokenStorage.clear()`, 탈퇴 탭 → `DELETE /api/users/me`

### placeholders/ (사실상 사용 안 됨, 보존 중)

#### `lib/features/placeholders/placeholder_tab_screen.dart`
**범용 미구현 탭 placeholder 위젯**. 현재 prototype_shell에서 더 이상 라우팅되지 않음 (랭킹/마이가 정식 화면으로 승격). 향후 새 탭 추가 시 공통 placeholder로 재활용 가능.
- 가운데: accent 원형 아이콘 + 제목 + 설명 텍스트
- props: `title`, `icon`, `body`

---

## 사용자 흐름

1. **Splash** → 자동 1.1초 → Login
2. **Login** → 카카오/일반 로그인 → Home / 회원가입 → Signup → Login 복귀
3. **Home** → 기존 방 탭 → ActiveRoom / 새 방 만들기 → CreateRoom
4. **CreateRoom** → Invite → BudgetInput → BudgetResult → Recommendation → ActiveRoom
5. **ActiveRoom**: 통합 영수증 또는 분할 영수증 → ReceiptRegister → 사진 촬영/갤러리/수동 입력 → Receipts
6. **하단 탭 목표 구조**: Home(0) / Community(1) / Ranking(2) / MyPage(3)
7. **Home** (탭0): 친구/지인 거지방 목록, 새 친구방 만들기
8. **Community** (탭1): 모든 사용자 채팅/게시글 공간
9. **Ranking** (탭2): 거지력 지수 기준 15명 순위판
10. **MyPage** (탭3): 프로필 + 개인 지출 내역 + 계정 관리 (로그아웃/탈퇴)

---

## 백엔드 연동 시 작업 순서

1. **pubspec.yaml** 의존성 추가: `dio`, `kakao_flutter_sdk_user`
2. `data/api/api_client.dart` 구현 (Dio + 인터셉터 + 401 처리)
3. `data/auth/kakao_auth_service.dart` 구현 (Kakao SDK 초기화는 `main()`에서)
4. `data/repositories/*` 각각 `XxxRepositoryImpl` 클래스 추가 (ApiClient 주입)
5. 의존성 주입: `provider` / `riverpod` 도입 후 Repository를 전역 제공
6. 화면에서 `MockDb.xxx` → `context.read<XxxRepository>().xxx()` 호출로 점진적 교체
7. `prototype_shell.dart`를 `go_router`로 교체 + 인증 가드
8. `core/config/api_config.dart`에 운영/스테이징 baseUrl 분기 추가
9. 랭킹/마이페이지에 신규 Repository 추가 (`RankingRepository`, `UserProfileRepository`)

---

## 화면별 ↔ 백엔드 API 매핑 (예정)

> DB는 `docs/DB_DESIGN.md`의 10개 테이블 기준.
> 추천은 착한가격업소 API 기준이며, 거지평가는 `room_beggar_scores` 기반으로 방마다 계산한다.

| 화면 | 호출할 API (예시 경로) | 주체 Repository | 주 테이블 |
|---|---|---|---|
| Login | `POST /auth/kakao` | AuthRepository | users |
| Signup | (카카오 첫 로그인 시 users 자동 생성) | AuthRepository | users |
| MyPage | `GET /users/me` / `POST /auth/signout` / `DELETE /users/me` | AuthRepository, UserProfileRepository (신규) | users |
| Home | `GET /rooms/my` (친구 전용 방만 표시, `is_friends=TRUE` 필터링) | RoomRepository | rooms ⋈ room_members |
| Community | `GET /community/posts` / `GET /community/chat-rooms` | CommunityRepository | community_posts, community_comments, community_chats 후보 |
| CreateRoom | `POST /rooms` (tags 동시 등록) | RoomRepository | rooms, room_purpose_tags |
| Invite | `POST /rooms/join` (입장) / `GET /rooms/{no}/members` (폴링) | RoomRepository | room_members |
| BudgetInput | `POST /rooms/{no}/budget` | BudgetRepository | budgets |
| BudgetResult | `POST /rooms/{no}/budget/confirm` / `GET /rooms/{no}/budget/result` | BudgetRepository | room_budget_results |
| Recommendation | `GET /rooms/{no}/recommend?tag={tag}&region={region}` (Spring이 착한가격업소 OpenAPI 직접 호출, DB 미적재) | RecommendationRepository | (없음 — 호출 시점 사용) |
| ActiveRoom | `GET /rooms/{no}` + `GET /rooms/{no}/receipts` + `GET /rooms/{no}/beggar-score` | RoomRepository, ReceiptRepository, RoomBeggarScoreRepository (신규) | rooms, receipts, room_beggar_scores |
| RoomSettings | `PATCH /rooms/{no}` 또는 `PATCH /rooms/{no}/settings` | RoomRepository | rooms, room_purpose_tags |
| ReceiptRegister | `POST /rooms/{no}/receipts` | ReceiptRepository | receipts, receipt_splits |
| Receipts | `PATCH /rooms/{no}/receipts/{id}` / `GET /users/me/receipts?sort=created_at,desc` / `GET /rooms/{no}/receipts?sort=created_at,desc` | ReceiptRepository | receipts |
| RoomRating | `GET /rooms/{no}/beggar-score` | RoomBeggarScoreRepository (신규) | room_beggar_scores |
| Ranking | 전체 랭킹 후보 API는 별도 정의 필요 | RankingRepository (신규) | 방별 평가와 분리 |
