# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.1] - 2025-08-26

### Added
- **키스토어 백업 기능 (`--backup`)** - 모든 프로젝트 키스토어 자동 백업
  - `~/.gradle/gradle.properties`에서 프로젝트 정보 자동 파싱
  - 키스토어 파일과 gradle 설정을 타임스탬프별로 백업
  - JSON 메타데이터로 백업 정보 체계적 관리
  - 최신 백업 심볼릭 링크 자동 생성

- **키스토어 복원 기능 (`--restore`)** - 안전한 복원 시스템
  - 원본 파일명과 경로 그대로 복원
  - 테스트 모드 지원 (`--restore --test`)
  - 메타데이터 기반 정확한 복원
  - gradle.properties 자동 업데이트

### Removed
- **키스토어 생성 기능 (`--generate`)** - 복잡성 증가와 유지보수 부담으로 인해 제거
  - `keytool` 자체가 이미 완벽한 키스토어 생성 도구이므로 중복 기능 제거
  - expect 스크립트 관련 호환성 문제와 무한 루프 등 예상치 못한 버그 발생
  - 사용자는 직접 `keytool` 명령어를 사용하여 키스토어를 생성하고, 스크립트는 관리 기능에 집중

### Changed
- 우선순위 재조정: 키스토어 생성 기능 제거로 인한 로드맵 업데이트

## [Unreleased]

### Added
- 키스토어 정보 초기 설정 (`--init`)
- 키스토어 정보 확인 (`--check`)
- 키스토어 alias 확인 (`--alias`)
- React Native 프로젝트 자동 감지
- 네임스페이스 기반 키스토어 변수 추출
- gradle.properties 자동 업데이트
- 한글/영문 README 문서
- 로드맵 문서
