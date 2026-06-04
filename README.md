# beggar-frontend

거지 우정 수호대 (Save My Friendship) — Flutter 모바일 앱

## Tech Stack
- Flutter / Dart
- Material 3 + Pretendard 폰트
- 디자인 시스템: 골드 토큰(`#D4AF37`) 중심, Figma 393×852 기준 스케일링
- 상태/라우팅: 현재 `prototype_shell.dart` enum 기반 셸 (추후 `go_router` + `provider`/`riverpod` 도입 예정)
- 인증: 이메일 로그인/회원가입 API 연결, `shared_preferences` 기반 `TokenStorage`, Kakao SDK 로그인 연결

## 현재 구현 상태 (2026-06-04)
- 18개 주요 화면 UI 구현
- 추천 화면은 Spring 백엔드 `GET /rooms/{roomNo}/recommend`와 연결됨
- 위치 검색/현재 위치 선택 후 지역·좌표·반경 기준으로 착한가격업소 후보를 다시 불러온다
- 추천 카드는 업소명, 대표 메뉴명, 가격, 주소, 우상단 착한가격업소 띠를 표시한다
- 추천 카드 전체를 누르면 확인창을 띄운 뒤 `url_launcher`로 카카오맵 검색 링크를 외부 앱/브라우저에서 연다
- 그 외 다수 화면 데이터는 `data/mock/mock_db.dart` 사용
- 최근 추가/수정: 커뮤니티 채팅·게시글·글쓰기, 거지방 설정, 방별 거지평가, 통합/분할 영수증 등록, 화면 제목 중심 상단 헤더, 착한가격업소 추천 카드
- 하단 네비게이션 목표 구조: 홈 / 커뮤니티 / 랭킹 / 마이 4탭
- 백엔드 호출 연결: 추천 API (`RecommendationRepository`), 위치 검색 API (`LocationRepository`)
- 인증 호출 연결: 이메일 로그인 `POST /auth/login`, 회원가입 `POST /users/signup`, 카카오 로그인 `POST /auth/kakao`

## Planned Features
- 카카오 소셜 로그인
- 거지방(모임방) 생성 및 초대 (딥링크 + 초대코드)
- 모든 사용자와 대화하는 커뮤니티 공간
- 방별 거지평가와 방 설정(지역/태그/최대 인원)
- 익명 예산 입력 및 총예산 자동 계산
- 착한가격업소 기반 메뉴/가격 추천 및 카카오맵 상세 확인
- 영수증 OCR 기반 지출 관리
- 거지력 지수 및 칭호 시스템

## 문서
- 파일별 상세 구조/기능: [`STRUCTURE.md`](./STRUCTURE.md)
- 앱 전체 기능 명세: [`../docs/APP_FEATURES.md`](../docs/APP_FEATURES.md)
- 프론트엔드 마이그레이션 가이드: [`../docs/FRONTEND_MIGRATION.md`](../docs/FRONTEND_MIGRATION.md)

## 실행
Android는 `--dart-define=KAKAO_NATIVE_APP_KEY=...` 값이 네이티브 URL 스킴에도 자동 반영된다.

```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080 \
            --dart-define=KAKAO_NATIVE_APP_KEY=<your_key>
```

iOS는 `ios/Flutter/Debug.xcconfig`, `ios/Flutter/Release.xcconfig`의 `KAKAO_NATIVE_APP_KEY=`에도 같은 네이티브 앱 키를 넣어야 카카오 로그인 콜백을 받을 수 있다.

### 실기기 테스트 API 주소

시뮬레이터/에뮬레이터가 아니라 실제 Android/iPhone을 USB로 연결해서 테스트할 때는 `127.0.0.1`을 쓰면 안 된다. 실제 폰에서 `127.0.0.1`은 개발 PC가 아니라 폰 자기 자신이다.

`frontend/.env`의 `API_BASE_URL`을 개발 PC의 같은 네트워크 IP로 바꾼다.

```env
API_BASE_URL=http://<PC_IP>:8080
```

PC IP 확인:

```bash
# macOS
ifconfig | awk '/^[a-z0-9]+:/{iface=$1} /inet / && $2 !~ /^127\./ {gsub(":", "", iface); print iface, $2}'
```

```bat
:: Windows CMD
ipconfig
```

Windows에서는 현재 연결된 `무선 LAN 어댑터 Wi-Fi` 또는 `이더넷 어댑터`의 `IPv4 주소`를 사용한다.

예시:

```env
API_BASE_URL=http://192.168.0.25:8080
```

구분:
- Android 에뮬레이터: `http://10.0.2.2:8080`
- iOS 시뮬레이터: `http://127.0.0.1:8080`
- 실제 Android/iPhone: `http://<PC_IP>:8080`

실기기 조건:
- 폰과 개발 PC가 같은 Wi-Fi 또는 같은 네트워크에 있어야 한다.
- Spring 서버가 `8080`으로 실행 중이어야 한다.
- Windows/macOS 방화벽에서 8080 인바운드 연결을 허용해야 할 수 있다.

### Android 카카오 로그인 확인값

카카오 개발자 콘솔 Android 플랫폼에는 아래 값을 등록한다.

```text
패키지명: com.beggar.beggar_app
디버그 키 해시: lOUH7HiBO0HkB0LCXnVHeiVFCmw=
URL 스킴: kakao{KAKAO_NATIVE_APP_KEY}
```
