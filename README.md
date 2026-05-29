# beggar-frontend

거지 우정 수호대 (Save My Friendship) — Flutter 모바일 앱

## Tech Stack
- Flutter / Dart
- Material 3 + Pretendard 폰트
- 디자인 시스템: 골드 토큰(`#D4AF37`) 중심, Figma 393×852 기준 스케일링
- 상태/라우팅: 현재 `prototype_shell.dart` enum 기반 셸 (추후 `go_router` + `provider`/`riverpod` 도입 예정)
- 인증: `shared_preferences` 기반 `TokenStorage` 구현됨 / Kakao SDK 미연동

## 현재 구현 상태 (2026-05-28)
- 13개 화면 모두 UI 완성, 모든 데이터는 `data/mock/mock_db.dart` 사용
- 최근 추가: `ranking_screen.dart`, `my_page_screen.dart` (커밋 `5024cb0`)
- 백엔드 호출 0건 — 모든 Repository는 추상 인터페이스만 존재

## Planned Features
- 카카오 소셜 로그인
- 거지방(모임방) 생성 및 초대 (딥링크 + 초대코드)
- 익명 예산 입력 및 총예산 자동 계산
- AI 기반 장소 추천 및 코스 조합 추천
- 영수증 OCR 기반 지출 관리
- 거지력 지수 및 칭호 시스템

## 문서
- 파일별 상세 구조/기능: [`STRUCTURE.md`](./STRUCTURE.md)
- 앱 전체 기능 명세: [`../docs/APP_FEATURES.md`](../docs/APP_FEATURES.md)
- 프론트엔드 마이그레이션 가이드: [`../docs/FRONTEND_MIGRATION.md`](../docs/FRONTEND_MIGRATION.md)

## 실행
```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080 \
            --dart-define=KAKAO_NATIVE_APP_KEY=<your_key>
```
