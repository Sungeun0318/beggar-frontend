# 프론트엔드 파일 구조 & 기능 설명

> `frontend/lib/` 내 47개 Dart 파일의 역할, 화면 구성, 기능, 의존성 정리
> 디자인 토큰 / 색상 / 텍스트 스타일은 [`FRONTEND_FILES.md`](./FRONTEND_FILES.md) 참고

---

## 전체 구조

```
lib/
├── main.dart                       앱 진입점
├── prototype_shell.dart            13개 페이지 전환 셸 (추후 go_router로 교체)
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
│   ├── api/api_client.dart         HTTP 클라이언트 (TODO)
│   ├── auth/
│   │   ├── kakao_auth_service.dart 카카오 SDK 래퍼 (TODO)
│   │   └── token_storage.dart      JWT 저장 (구현됨)
│   └── repositories/               4개 추상 인터페이스 (TODO 구현체)
├── shared/widgets/                 공용 위젯 16개
└── features/                       화면 12개 (도메인별 폴더)
```

---

## 진입점

### `lib/main.dart`
앱 부트스트랩.
- `WidgetsFlutterBinding.ensureInitialized()` → 세로 모드 잠금 → 시스템 UI 오버레이 색 설정 → `runApp()`
- `BeggarPrototypeApp`: `MaterialApp` 루트. 테마: Material3 + Pretendard 폰트 + `AppColors.bg` 배경.
- `home`은 `PrototypeShell`. 추후 백엔드 연동 시 인증 상태에 따라 splash/login/home 라우팅으로 교체 예정.

### `lib/prototype_shell.dart`
13개 페이지를 enum으로 관리하는 임시 셸. 추후 `go_router`로 교체.
- `enum PrototypePage`: splash, login, signup, home, createRoom, invite, budgetInput, budgetResult, recommendation, activeRoom, receipts, ranking, myPage
- `_PrototypeShellState`: `_page` 상태와 `_go(PrototypePage)` 메서드로 화면 전환
- `BottomNav` 표시 조건: splash/login/signup 제외 모든 페이지
- `_activeIndex`: 현재 페이지에 따라 하단 탭 활성 인덱스 계산 (홈=0, 지출=1, 추가/생성흐름=2, 랭킹=3, 마이=4)

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
- 카카오 로그인 후 백엔드에서 받은 사용자 프로필 표현

#### `lib/data/models/room.dart`
- 필드: `no`, `ownerNo`, `name`, `code`(초대 코드), `location`, `tags`(List<String>), `memberCount`
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
- `currentUser`: 거지판다 (id 3, kakao)
- `room`: 명학역 데이트 (4명, 식사+카페+놀거리)
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
- `ScreenHeader({title, onBack})`: 뒤로가기 + 가운데 정렬 타이틀의 표준 헤더 (top: 55)
- `StatusRow`: 빈 위젯 (이전 상태바 placeholder, 현재 사용 안 됨)

### `lib/shared/widgets/bottom_nav.dart`
하단 5탭 + 가운데 떠 있는 골드 FAB.
- `BottomNav({activeIndex, onHome, onExpense, onAdd, onRanking, onMy})`
- 5개 탭: 홈 / 지출 / (가운데 +) / 랭킹 / 마이
- 가운데 FAB(56x56)은 골드 그라데이션 + 그림자, `Transform.translate`로 -16 띄움
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
방 카테고리 선택 박스 (식사/카페/놀거리/기타).
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
- `RecommendationCard({image, tag, title, walk, rating, amount, tagBg, tagColor})`
- 높이 148, 왼쪽 100×100 이미지 + 우측 텍스트 영역 (태그 배지, 제목, 도보시간, 별점, 금액)
- 사용처: 추천 화면 3개, 진행 중 화면 1개

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
영수증 추가 액션 박스 (촬영 / 수동입력).
- `ActionBox({icon, title, body, onTap})`: 높이 104, 좌상단 아이콘 + 하단 제목/설명
- 사용처: 진행 중 화면 "지출 입력" 섹션 2개

### `lib/shared/widgets/flow_step.dart`
번호 표시 단계 행. **현재 어떤 화면에서도 사용 안 됨** (가입 흐름 설명용 placeholder로 보존).
- `FlowStep({index, title, body})`

---

## features/ — 화면 12개

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
**회원가입**. 닉네임/이메일/비밀번호 입력 + 익명 보호 안내.
- 헤더: 뒤로가기 + "회원가입"
- "처음 오셨나요?" + 설명
- 입력 필드: 닉네임 / 이메일 / 비밀번호 (모두 `InputLike` 정적 placeholder)
- 안내 카드: "예산 정보는 익명으로 보호돼요"
- 하단: "회원가입 완료" 버튼 → `onComplete` (로그인으로 복귀)
- props: `onBack`, `onComplete`

### home/

#### `lib/features/home/home_screen.dart`
**홈 (내 거지방 목록)**. 메인 진입 화면.
- 상단: 로고 + 앱 이름 + 알림 벨
- "내 거지방" 제목 + 설명 + 검색 박스(정적)
- 거지방 카드 2개: "명학역 데이트" (mock) + "전시 보러 가요" (하드코딩)
- 하단: "새 거지방 만들기" 박스 (accent 배경, 탭 시 방 생성으로)
- props: `onOpenRoom`, `onCreate`

### room/

#### `lib/features/room/create_room_screen.dart`
**거지방 생성**. 모임 정보 입력.
- 헤더: "새 거지방 만들기"
- "어디서 모이나요?" → InputLike (강남역, 홍대입구 예시)
- "어떤 모임인가요?" → 2×2 GridView (식사/카페/놀거리/기타)
- "몇 명이서 모이나요?" → 카운터 (RoundIcon - / 숫자 / RoundIcon +), 최소 2~최대 20명 안내
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
**거지방 진행 중**. 방 운영 중 상황판.
- 상단: 로고 + "거지방 진행 중" + 알림
- 메인 카드 (accentBg): 방 이름 + 위치 칩 / "남은 예산" 큰 숫자 / 프로그레스 바 / 사용률
  - `spent = 영수증[0] + 영수증[1] = 49,000원`, `total = 60,000원`
  - `left = 11,000원`, `ratio ≈ 82%`
- "오늘의 추천 코스" 섹션 + RecommendationCard 1개 (정성 한식)
- "지출 입력" 섹션 + ActionBox 2개 (영수증 촬영 / 수동 입력) → `onAddReceipt`
- "최근 지출" 섹션 + ReceiptCard 1개 (`MockDb.receipts[0]`)
- props: `onAddReceipt`, `onCreate`

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
**예산 맞춤 추천**. 60,000원 예산 내 가게 3곳 추천.
- 헤더: "예산에 맞는 추천"
- 상단 요약: SummaryRow 2개 (위치 "명학역 1번 출구 근처" + 변경 칩 / 예산 "60,000원 이내 추천")
- 추천 카드 3개:
  1. 식사 — 정성 한식 세트 (도보 5분, 38,000원)
  2. 카페 — 따뜻한 하루 카페 (도보 7분, 18,000원)
  3. 놀거리 — 보드게임 놀이터 (도보 9분, 24,000원)
- 마스코트 안내 카드: "남는 예산까지 고려한 조합을 추천해드려요!"
- 하단: "거지방 시작하기" 버튼 → `onDone` (진행 중 화면으로)
- props: `onBack`, `onDone`

### receipts/

#### `lib/features/receipts/receipts_screen.dart`
**모든 지출 내역**. 하단 탭의 "지출" 또는 진행 중 화면에서 진입.
- 상단: 로고 + 앱 이름 + (옵션 뒤로가기) + 되돌리기 + 알림
- "모든 지출 내역" + "최신순" 정렬 표시
- 이번 달 총 지출 카드 (accentBg): "101,000원"
- 영수증 카드 3개 (날짜순):
  1. 2024.05.18 정성 한식 35,000원
  2. 2024.05.12 블루보틀 삼청 14,000원
  3. 2024.05.05 오아시스 한남 52,000원
- props: `onCreate`, `onBack?` (옵션)

### placeholders/

#### `lib/features/placeholders/placeholder_tab_screen.dart`
**랭킹/마이 임시 화면**. 아직 구현 안 된 탭들.
- 가운데: accent 원형 아이콘 + 제목 + 설명 텍스트
- 사용처:
  - 랭킹 탭: "명예의 거지 전당은 거지력 지수와 절약률 기준으로 보여줄 예정이에요."
  - 마이 탭: "{username}님의 계정과 참여한 거지방을 관리해요."
- props: `title`, `icon`, `body`

---

## 사용자 흐름

1. **Splash** → 자동 1.1초 → Login
2. **Login** → 카카오/일반 로그인 → Home / 회원가입 → Signup → Login 복귀
3. **Home** → 기존 방 탭 → ActiveRoom / 새 방 만들기 → CreateRoom
4. **CreateRoom** → Invite → BudgetInput → BudgetResult → Recommendation → ActiveRoom
5. **ActiveRoom**: 영수증 추가 → Receipts / 추천 보기 등
6. **하단 탭**: Home(0) / Receipts(1) / [추가FAB→CreateRoom] / Ranking(3) / MyPage(4)

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
