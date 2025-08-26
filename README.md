# Android Keystore Manager

React Native 프로젝트에서 Android 서명 키(Keystore) 정보를 체계적으로 관리하는 Bash 스크립트입니다.

## 🎯 주요 기능

- **키스토어 정보 초기 설정**: React Native 프로젝트의 키스토어 관련 변수를 자동으로 추출하고 정보를 입력받아 `~/.gradle/gradle.properties`에 저장
- **키스토어 정보 확인**: 현재 프로젝트의 키스토어 설정 상태를 확인
- **키스토어 alias 확인**: 키스토어 파일에서 alias 정보를 추출하여 확인
- **자동 키스토어 파일 검색**: `android/app/` 폴더에서 `.jks` 파일을 자동으로 찾아 제안
- **키스토어 백업**: 모든 프로젝트의 키스토어 파일과 설정을 안전하게 백업
- **키스토어 복원**: 백업된 키스토어를 원본 경로와 파일명으로 안전하게 복원

## 📋 요구사항

- React Native 프로젝트
- `android/app/build.gradle` 파일에 키스토어 관련 변수 정의
- Bash 쉘 환경
- `keytool` 명령어 (alias 확인 기능 사용시)

## 🚀 사용법

### 기본 사용법
```bash
./keystore-manager.sh [옵션]
```

### 옵션

| 옵션 | 설명 |
|------|------|
| `--init`, `-i` | 키스토어 정보 초기 설정 |
| `--check`, `-c` | 현재 키스토어 정보 확인 |
| `--alias`, `-l` | 키스토어 alias 확인 |
| `--backup`, `-b` | 모든 프로젝트 키스토어 백업 |
| `--restore`, `-r` | 모든 프로젝트 키스토어 복원 |
| `--restore --test` | 테스트 모드로 복원 (.restore 확장자) |
| `--help`, `-h` | 도움말 표시 |

### 사용 예시

#### 1. 키스토어 정보 초기 설정
```bash
./keystore-manager.sh --init
```
- React Native 프로젝트의 `android/app/build.gradle`에서 키스토어 관련 변수를 자동으로 추출
- 각 변수에 대한 값을 입력받음
- 키스토어 파일 경로는 자동으로 제안됨
- 입력된 정보를 `~/.gradle/gradle.properties`에 저장

#### 2. 키스토어 정보 확인
```bash
./keystore-manager.sh --check
```
- 현재 프로젝트의 네임스페이스 확인
- `~/.gradle/gradle.properties`에서 해당 프로젝트의 키스토어 정보 출력
- `android/app/` 폴더의 키스토어 파일 경로 표시

#### 3. 키스토어 alias 확인
```bash
./keystore-manager.sh --alias
```
- `android/app/` 폴더에서 `.jks` 파일 검색
- 선택한 키스토어 파일의 alias 정보 추출
- `keytool` 명령어를 사용하여 alias 확인

#### 4. 키스토어 백업
```bash
./keystore-manager.sh --backup
```
- `~/.gradle/gradle.properties`에서 모든 프로젝트 정보 자동 파싱
- 키스토어 파일과 gradle 설정을 타임스탬프별로 백업
- JSON 메타데이터로 백업 정보 체계적 관리
- 최신 백업 심볼릭 링크 자동 생성

#### 5. 키스토어 복원 (테스트 모드)
```bash
./keystore-manager.sh --restore --test
```
- 백업된 키스토어를 `.restore` 확장자로 안전하게 복원
- 실제 파일에 영향 없이 복원 과정 테스트
- 원본 파일명과 경로 그대로 복원 (확장자만 추가)

#### 6. 키스토어 복원 (실제 복원)
```bash
./keystore-manager.sh --restore
```
- 백업된 키스토어를 원본 경로와 파일명으로 복원
- gradle.properties 설정도 함께 복원
- **주의**: 기존 파일을 덮어쓸 수 있으므로 테스트 모드 먼저 실행 권장

## 📁 파일 구조

### 입력 파일
- `android/app/build.gradle`: 키스토어 관련 변수 정의
- `android/app/*.jks`: 키스토어 파일

### 출력 파일
- `~/.gradle/gradle.properties`: 키스토어 정보 저장
- `~/.keystore-backups/`: 백업 파일 저장 디렉토리
  - `YYYY-MM-DD_HH-MM-SS/`: 타임스탬프별 백업
  - `latest/`: 최신 백업 심볼릭 링크

## 🔧 지원하는 키스토어 변수

스크립트는 다음 패턴의 변수들을 자동으로 추출합니다:

- `*_UPLOAD_STORE_FILE`: 키스토어 파일 경로
- `*_UPLOAD_STORE_PASSWORD`: 키스토어 비밀번호
- `*_UPLOAD_KEY_ALIAS`: 키 별칭
- `*_UPLOAD_KEY_PASSWORD`: 키 비밀번호

### React Native 공식 가이드

이 스크립트는 [React Native 공식 문서의 Gradle 변수 설정 가이드](https://reactnative.dev/docs/signed-apk-android#setting-up-gradle-variables)를 기반으로 만들어졌습니다.

공식 문서에 따르면, 키스토어 정보는 `~/.gradle/gradle.properties` 파일에 다음과 같이 설정해야 합니다:

```properties
MYAPP_UPLOAD_STORE_FILE=my-upload-key.keystore
MYAPP_UPLOAD_KEY_ALIAS=my-key-alias
MYAPP_UPLOAD_STORE_PASSWORD=*****
MYAPP_UPLOAD_KEY_PASSWORD=*****
```

**보안 참고사항**: 
- `~/.gradle/gradle.properties`에 저장하면 Git에 체크인되지 않아 보안상 안전합니다.
- macOS에서는 Keychain Access 앱을 사용하여 비밀번호를 저장할 수도 있습니다.

## ⚠️ 주의사항

1. **프로젝트 위치**: React Native 프로젝트 최상위 폴더에서 실행해야 합니다.
2. **파일 구조**: 다음 파일들이 존재해야 합니다:
   - `package.json`
   - `android/app/build.gradle`
3. **권한**: 스크립트 실행 권한이 필요합니다.
4. **보안**: 키스토어 비밀번호는 `~/.gradle/gradle.properties`에 평문으로 저장됩니다.
5. **백업/복원**: 복원 시 기존 파일을 덮어쓸 수 있으므로 테스트 모드를 먼저 사용하세요.

## 🔒 보안 고려사항

- 키스토어 파일과 비밀번호는 민감한 정보입니다.
- `~/.gradle/gradle.properties` 파일의 접근 권한을 적절히 설정하세요.
- 프로덕션 환경에서는 환경 변수나 보안 저장소 사용을 고려하세요.

## 🛠️ 설치 및 설정

1. 스크립트를 프로젝트 루트에 다운로드
2. 실행 권한 부여:
   ```bash
   chmod +x keystore-manager.sh
   ```
3. React Native 프로젝트 루트에서 실행

## 📞 문제 해결

### 일반적인 오류

1. **"React Native 프로젝트 폴더가 아닙니다"**
   - 프로젝트 루트 폴더에서 실행했는지 확인
   - `package.json`과 `android/app/build.gradle` 파일 존재 확인

2. **"키스토어 관련 변수를 찾을 수 없습니다"**
   - `android/app/build.gradle`에 키스토어 변수가 정의되어 있는지 확인
   - 변수명이 `*_UPLOAD_*` 패턴을 따르는지 확인

3. **"namespace를 찾을 수 없습니다"**
   - `android/app/build.gradle`에 `namespace` 속성이 정의되어 있는지 확인

## 🤝 기여

버그 리포트나 기능 제안은 이슈를 통해 제출해주세요.

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다.
