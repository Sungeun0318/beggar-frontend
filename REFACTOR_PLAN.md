# 프론트엔드 UI 일관성 리팩토링 계획

> **목표**: 주요 Flutter 화면의 헤더·여백·패딩·radius·디자인 토큰을 통일하고, 절대좌표 기반 레이아웃을 Column 적층 구조로 전환하여 유지보수성을 확보한다.
> **작성일**: 2026-05-29
> **상태**: 단계 1~4 완료 후 후속 UI 조정까지 반영됨
> **현재 헤더 방향**: 메인 탭은 로고 + 화면 제목 중심, 서브 화면은 뒤로가기 + 가운데 제목

---

## 진단 요약 (왜 하는가)

초기 13개 화면 점검 결과 7가지 일관성 문제를 발견했고, 현재 Flutter 프로토타입에는 개선이 반영되어 있다:

1. **헤더 패턴이 3종류로 갈림** — 기존 공용 헤더 / 홈 커스텀 / 랭킹·마이 커스텀. 현재는 `AppHeader` 중심으로 통합했고, 메인 탭은 로고 + 화면 제목 중심으로 변경.
2. **콘텐츠 시작 top 편차 18px** — 기존 공용 헤더/커스텀 헤더의 본문 시작 top이 112 / 122 / 128 / 130으로 제각각이었다.
3. **사이드 패딩 불일치** — 본문은 모두 24, 기존 공용 헤더만 8로 16px 차이가 있었다.
4. **하단 여백 누락** — home, activeRoom, receipts에서 마지막 콘텐츠가 BottomNav(92)+FAB(16)에 가려질 수 있음.
5. **카드 radius 7종 혼재** — 14 / 16 / 18 / 20 / 22 / 24 / 28. 규칙 없음.
6. **절대좌표 마법 숫자** — budgetResult의 top 274/632, receipts의 top 55/124/174/296. 콘텐츠 변경 시 다 깨짐.
7. **디자인 토큰 누락** — `Color(0xFF5A4F43)` 같은 자주 쓰는 색이 토큰 없이 6곳에서 직접 박힘. 스페이싱·텍스트 스타일도 매번 inline.

---

## 진행 순서 (4단계)

| 단계 | 작업 | 예상 시간 | 영향 범위 | 우선순위 |
|---|---|---|---|---|
| **1** | 디자인 토큰 확장 + 하단 여백 통일 | 30~50분 | core/theme/, home/activeRoom/receipts | ⭐⭐⭐ |
| **2** | 공용 헤더 위젯 통일 | 1시간 | shared/widgets/, 13개 화면 헤더 부분 | ⭐⭐⭐ |
| **3** | 카드 radius 규칙 일괄 적용 | 1시간 | 13개 화면 + 공용 위젯 | ⭐⭐ |
| **4** | 절대좌표 → Column 적층 리팩 | 2~3시간 | budgetResult, receipts, recommendation 중심 | ⭐ (큼) |

---

## 단계 1 — 디자인 토큰 확장 + 하단 여백 통일

### 1-1. `core/theme/app_colors.dart` 확장
- [ ] `darkSub = Color(0xFF5A4F43)` 추가 (`text`와 `sub` 사이 톤, 6곳+에서 사용 중)
- [ ] `kakaoYellow = Color(0xFFFEE500)` 추가
- [ ] 태그 배지 그룹 추가 (recommendation/activeRoom 공용):
  - `tagBgFood = Color(0xFFFFEADD)`
  - `tagBgCafe = Color(0xFFFFF2D1)` / `tagFgCafe = Color(0xFFB88B2D)`
  - `tagBgPlay = Color(0xFFEAE4FE)` / `tagFgPlay = Color(0xFF8B6CE0)`
- [ ] 메달 그라데이션 그룹 추가 (ranking):
  - `medalGold`, `medalSilver`, `medalBronze` (LinearGradient 상수)
- [ ] 스파클 색 그룹 (budgetResult 마스코트 주변): `sparkleYellow`, `sparkleOrange`, `sparklePurple`

### 1-2. `core/theme/app_spacing.dart` 신규
- [ ] 갭 상수: `gap8 = 8`, `gap12 = 12`, `gap16 = 16`, `gap20 = 20`, `gap24 = 24`, `gap28 = 28`
- [ ] 페이지 사이드 패딩: `pageH = 24`
- [ ] 헤더 끝 위치: `headerBottom = 111` (top 55 + height 56)
- [ ] 본문 시작 갭: `contentTopGap = 17` → 본문 시작 top = 128
- [ ] **BottomNav 회피 패딩**: `bottomSafe = 120`

### 1-3. `core/theme/app_radius.dart` 신규
- [ ] `compact = 16` — 입력 박스 / 작은 카드
- [ ] `card = 20` — 기본 카드
- [ ] `hero = 28` — 큰 히어로 카드 (예산 결과 등)
- [ ] `chip = 999` — 칩 / 프로그레스

### 1-4. `core/theme/app_text_styles.dart` 신규
- [ ] `appBrand` — "거지 우정 수호대" 헤더 타이틀 (size 19, w700, letterSpacing -0.7)
- [ ] `pageTitle` — "거지 랭킹", "마이 페이지" 등 (size 20, w600, -0.45)
- [ ] `sectionHeading` — "내 거지방" 같은 큰 본문 헤딩 (size 24, w900, -0.7)
- [ ] `bodyStrong` — 카드 안 강조 본문 (size 14, w600, color darkSub)
- [ ] `bodySub` — 보조 설명 (size 13, w600, color sub)

### 1-5. 하단 BottomNav 회피 통일
- [ ] `home_screen.dart` — 마지막 카드 뒤에 `SizedBox(height: AppSpacing.bottomSafe)` 추가
- [ ] `active_room_screen.dart` — 동일
- [ ] `receipts_screen.dart` — 마지막 영수증 뒤에 동일 추가
- [ ] 이미 적용된 화면 확인: createRoom, budgetInput, budgetResult, recommendation, invite, ranking, mypage → `AppSpacing.bottomSafe` 상수로 치환

### 검증
- [ ] 모든 화면에서 마지막 콘텐츠가 BottomNav에 가리지 않음
- [ ] 동일 톤 갈색·카카오 노랑이 더 이상 hex 리터럴로 직접 등장하지 않음 (`grep "Color(0xFF5A4F43)"` 0건)

---

## 단계 2 — 공용 헤더 위젯 통일

### 2-1. `shared/widgets/app_header.dart` 신규
두 가지 패턴을 같은 위젯의 named 생성자로 제공:

```dart
class AppHeader {
  // 패턴 A: 로고 + 화면 제목 (+ 옵션 알림벨/뒤로가기)
  AppHeader.brand({String title = '거지 우정 수호대',
                   VoidCallback? onBack,
                   bool showNotification = true});

  // 패턴 B: 뒤로가기 + 가운데 정렬 타이틀
  AppHeader.titled({required String title, required VoidCallback onBack});
}
```

현재 스펙:
- top: `AppSpacing.headerTop - 16`, left/right: pageH(24), height: 56
- `brand`: 로고 44px + 화면 제목 25pt w900
- `titled`: 뒤로가기 + 가운데 제목 21pt w900

### 2-2. 기존 공용 헤더 제거
- [x] 기존 공용 헤더 사용처를 `AppHeader.titled(...)`로 교체
- [x] 좌우 패딩 8 → 24로 통일

### 2-3. 커스텀 헤더 5개 교체
- [ ] `home_screen.dart` 헤더 → `AppHeader.brand(showNotification: true)`
- [ ] `ranking_screen.dart` 헤더 → `AppHeader.brand(showNotification: false)`
- [ ] `my_page_screen.dart` 헤더 → `AppHeader.brand(showNotification: false)`
- [ ] `active_room_screen.dart` 헤더 → `AppHeader.brand(title: '거지방 진행 중')`
- [ ] `receipts_screen.dart` 헤더 → `AppHeader.brand(onBack: ..., showNotification: true)`

### 2-4. 본문 시작 top 통일
- [ ] 모든 화면 본문의 첫 `Positioned(top: ...)` → `top: 128` (헤더끝 111 + 갭 17)
  - 예외: home은 `pageTitle` 영역이 별도이므로 116 유지 가능 (기존 로직 검토)
- [ ] ranking·mypage의 page title `top: 119`도 일관 검토 (헤더 끝 + 8 = 119라면 OK)

### 검증
- [ ] 모든 화면에서 같은 위치/크기의 헤더가 표시됨
- [ ] "거지 우정 수호대" 텍스트 스타일이 어떤 화면에서도 동일

---

## 단계 3 — 카드 radius 규칙 일괄 적용

### 3-1. 규칙 확정
- 입력 박스 / 컴팩트 카드: `AppRadius.compact (16)`
- 일반 카드: `AppRadius.card (20)`
- 히어로 카드: `AppRadius.hero (28)` — budgetResult 메인 카드만
- 칩 / 배지 / 프로그레스: `AppRadius.chip (999)`

### 3-2. 화면별 치환 작업
- [ ] `home_screen.dart` — 검색박스 16 → compact, 카드 20 → card
- [ ] `login_screen.dart` — 일반 로그인 카드 20 → card, 카카오 버튼 18 → card(20)
- [ ] `signup_screen.dart` — InfoCard 자체 점검
- [ ] `create_room_screen.dart` — 인원 카운터 16 → compact
- [ ] `invite_room_screen.dart` — 초대 카드 24 → card, 링크 박스 18 → compact(16)
- [ ] `budget_input_screen.dart` — 정보 카드 20 → card, 금액 박스 16 → compact
- [ ] `budget_result_screen.dart` — 메인 카드 28 → hero, 디바이더 박스 24 → card
- [ ] `recommendation_screen.dart` — 마스코트 안내 20 → card
- [ ] `active_room_screen.dart` — 메인 카드 22 → card(20)
- [ ] `receipts_screen.dart` — 요약 카드 20 → card
- [ ] `my_page_screen.dart` — 모든 박스 20 → card
- [ ] `ranking_screen.dart` — 카드 16 → compact 또는 card 결정
- [ ] `shared/widgets/info_card.dart` — radius 토큰 사용
- [ ] `shared/widgets/recommendation_card.dart` — 동일
- [ ] `shared/widgets/receipt_card.dart` — 동일
- [ ] `shared/widgets/room_home_card.dart` — 동일

### 검증
- [ ] `grep -E "BorderRadius.circular\((14|18|22|24|28)\)"` 결과 검토 (28은 hero 1곳만 허용)

---

## 단계 4 — 절대좌표 → Column 적층 리팩 (가장 큼)

### 4-1. 대상
- [ ] `budget_result_screen.dart` (top 112/274/632 4개 Positioned)
- [ ] `receipts_screen.dart` (top 55/124/174/296)
- [ ] `recommendation_screen.dart` (top 779 마스코트 안내)

### 4-2. 방식
- `Stack` + 다중 `Positioned` → `SingleChildScrollView` + `Column` + `SizedBox(height: ...)` 적층
- 헤더는 `AppHeader`가 별도 `Positioned`로 떠있고, 본문만 Column으로 만든다
- `FigmaFrame.height` 매개변수 제거 가능 — 콘텐츠 길이 자동 측정

### 4-3. 검증
- [ ] 콘텐츠 길이 변화에 대응 (텍스트 길어져도 카드끼리 안 겹침)
- [ ] `grep "top: [0-9]" features/` 에서 헤더(55) 외 절대 좌표가 사라짐

---

## 작업 분담 제안 (5인 팀)

| 단계 | 추천 담당 | 사유 |
|---|---|---|
| 1 | 토큰 도입자 1명 | 영향 작고 분리 가능. 모두가 이후 의존 |
| 2 | UI 일관성 담당 | 13개 화면 동시 수정, 충돌 적음 |
| 3 | 1명 일괄 | radius만 치환이라 빠름 |
| 4 | 화면별 owner 3명 분담 | budgetResult/receipts/recommendation 각자 |

---

## 작업 규칙

- 1 단계 = 1 PR 권장. 단계 안에서 화면별 분리도 가능
- 단계 1 토큰 정의 후 머지되어야 단계 2 시작 가능 (의존성)
- 각 PR에 단계 번호 표시: `Refactor: [Step 1] 디자인 토큰 도입`
- 커밋 컨벤션은 `backend/COMMIT_CONVENTION.md` 동일 적용

---

## 진행 체크리스트 (요약)

- [x] **단계 1** — 디자인 토큰 + 하단 여백
- [x] **단계 2** — 공용 헤더 위젯
- [x] **단계 3** — radius 규칙
- [x] **단계 4** — 절대좌표 리팩
- [x] 후속 UI — 하단 4탭, 커뮤니티, 거지방 설정, 방별 거지평가, 다음 코스 고르기, 화면 제목 중심 헤더
