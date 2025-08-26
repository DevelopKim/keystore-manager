# 🗺️ Roadmap

Android Keystore Manager의 향후 개발 계획과 추가 기능들입니다.

## 🎯 개발 목표

현재 스크립트는 기본적인 키스토어 정보 관리를 제공하지만, React Native 개발자들이 자주 겪는 키스토어 관련 문제들을 더 포괄적으로 해결할 수 있는 고급 기능들을 추가할 예정입니다.

## 🚀 계획된 기능들



### 키스토어 백업/복원
```bash
./keystore-manager.sh --backup
./keystore-manager.sh --restore
```
- 키스토어 파일과 설정을 안전한 위치에 백업
- 프로젝트 간 키스토어 설정 복원
- 백업 파일 암호화 지원
- 클라우드 스토리지 연동 (선택사항)

### 키스토어 유효성 검증
```bash
./keystore-manager.sh --validate
```
- 키스토어 파일의 무결성 확인
- 만료일 체크 및 경고
- 서명 설정이 올바른지 검증
- 빌드 전 사전 검증으로 문제 예방

### 빌드 자동화 통합
```bash
./keystore-manager.sh --build-release
```
- 키스토어 설정 확인 후 바로 릴리즈 빌드 실행
- `./gradlew assembleRelease` 자동 실행
- 빌드 결과 검증 및 성공/실패 알림
- AAB/APK 파일 생성 확인

### 팀 협업 기능
```bash
./keystore-manager.sh --share-config
./keystore-manager.sh --import-config
```
- 키스토어 설정을 팀원과 공유 (비밀번호 제외)
- 설정 템플릿 생성/가져오기
- 팀 공통 설정 파일 관리
- Git hooks와 연동하여 설정 동기화

### 키스토어 정보 암호화
```bash
./keystore-manager.sh --encrypt
```
- `~/.gradle/gradle.properties`의 비밀번호를 암호화 저장
- 런타임에 복호화하여 사용
- 시스템 키체인 연동 (macOS Keychain, Windows Credential Manager)
- 환경 변수 기반 암호화 키 관리

### 다중 환경 지원
```bash
./keystore-manager.sh --env production
./keystore-manager.sh --env staging
```
- 개발/스테이징/프로덕션 환경별 키스토어 관리
- 환경별 설정 파일 분리
- 환경 전환 시 자동 설정 적용
- 환경별 키스토어 파일 관리

### 키스토어 만료 알림
```bash
./keystore-manager.sh --check-expiry
```
- 키스토어 만료일 확인 및 알림
- 만료 임박 시 경고 메시지
- 자동 만료 알림 스케줄링
- 만료 대응 가이드 제공

### Google Play Console 연동
```bash
./keystore-manager.sh --upload-key
```
- Google Play Console에 업로드 키 등록
- App Signing by Google Play 설정 확인
- Google Play API 연동 (선택사항)
- 업로드 키 상태 모니터링

### 키스토어 마이그레이션 도구
```bash
./keystore-manager.sh --migrate
```
- 기존 릴리즈 키에서 업로드 키로 마이그레이션
- Google Play App Signing 마이그레이션 가이드
- 단계별 마이그레이션 프로세스
- 마이그레이션 검증 및 롤백 지원

## 📊 우선순위

### 높은 우선순위 (v2.0)
1. **유효성 검증** - 빌드 전에 문제 미리 확인
2. **빌드 자동화** - 설정 확인 후 바로 빌드
3. **백업/복원** - 키스토어 손실 방지
4. **다중 환경 지원** - 팀 개발 환경에서 유용

### 중간 우선순위 (v2.1)
5. **키스토어 만료 알림** - 장기 운영 시 필요
6. **팀 협업 기능** - 팀 프로젝트에서 유용

### 낮은 우선순위 (v3.0)
7. **키스토어 정보 암호화** - 보안 강화
8. **Google Play Console 연동** - 고급 기능
9. **키스토어 마이그레이션 도구** - 특수 상황

## 🔧 기술적 고려사항

### 호환성
- 다양한 React Native 버전 지원
- macOS, Linux, Windows 크로스 플랫폼 지원
- 다양한 Java/JDK 버전 호환성

### 보안
- 민감한 정보 암호화 저장
- 시스템 키체인 연동
- 안전한 백업 및 복원

### 사용성
- 대화형 인터페이스 개선
- 자동 완성 및 제안 기능
- 상세한 에러 메시지 및 해결 가이드

## 🤝 기여 방법

이 로드맵의 기능들을 구현하고 싶다면:

1. **이슈 등록**: 구현하고 싶은 기능을 이슈로 등록
2. **PR 제출**: 구현한 기능을 Pull Request로 제출
3. **문서 작성**: 새로운 기능에 대한 문서 작성

## 📝 버전 계획

- **v1.x**: 현재 기본 기능 (완료)
- **v2.0**: 키스토어 생성, 유효성 검증, 빌드 자동화
- **v2.1**: 백업/복원, 다중 환경 지원
- **v3.0**: 고급 보안 기능 및 Google Play 연동

---

*이 로드맵은 커뮤니티의 피드백과 요구사항에 따라 지속적으로 업데이트됩니다.*
