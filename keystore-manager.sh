#!/bin/bash

# Android Keystore 관리 스크립트
# 사용법: ./keystore-manager.sh [옵션]

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 로그 함수
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}" >&2
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}



# React Native 프로젝트 확인
check_rn_project() {
    if [ ! -f "package.json" ] || [ ! -d "android" ] || [ ! -f "android/app/build.gradle" ]; then
        log_error "React Native 프로젝트 폴더가 아닙니다."
        log_info "프로젝트 최상위 폴더에서 실행해주세요."
        exit 1
    fi
}

# namespace 추출
get_namespace() {
    local namespace=$(grep -E 'namespace\s+"[^"]+"' android/app/build.gradle | sed 's/.*namespace[[:space:]]*"\([^"]*\)".*/\1/')
    if [ -z "$namespace" ]; then
        log_error "namespace를 찾을 수 없습니다."
        exit 1
    fi
    echo "$namespace"
}

# 키스토어 관련 변수 추출
get_keystore_vars() {
    local build_gradle="android/app/build.gradle"
    local vars=()
    
    # 원하는 순서로 변수들 찾기
    while IFS= read -r line; do
        if [[ $line =~ [A-Z0-9]+_UPLOAD_STORE_FILE ]]; then
            vars+=("$BASH_REMATCH")
        fi
    done < "$build_gradle"
    
    while IFS= read -r line; do
        if [[ $line =~ [A-Z0-9]+_UPLOAD_STORE_PASSWORD ]]; then
            vars+=("$BASH_REMATCH")
        fi
    done < "$build_gradle"
    
    while IFS= read -r line; do
        if [[ $line =~ [A-Z0-9]+_UPLOAD_KEY_ALIAS ]]; then
            vars+=("$BASH_REMATCH")
        fi
    done < "$build_gradle"
    
    while IFS= read -r line; do
        if [[ $line =~ [A-Z0-9]+_UPLOAD_KEY_PASSWORD ]]; then
            vars+=("$BASH_REMATCH")
        fi
    done < "$build_gradle"
    
    # 중복 제거 (순서 유지)
    printf '%s\n' "${vars[@]}" | awk '!seen[$0]++'
}

# 키스토어 정보 입력
input_keystore_info() {
    local namespace=$1
    shift
    local vars=("$@")

    log_info "키스토어 정보를 입력하세요 (빈 값 입력시 중단)"
    
    local keystore_info=""
    keystore_info+="# $namespace - update $(date '+%Y-%m-%d %H:%M:%S')\n"
    
    for var in "${vars[@]}"; do
        # STORE_FILE인 경우 키스토어 파일 자동 검색
        if [[ $var == *"_UPLOAD_STORE_FILE" ]]; then
            local keystore_files=($(find android/app/ -name "*.jks" -type f 2>/dev/null))
            
            if [ ${#keystore_files[@]} -gt 0 ]; then
                local suggested_file=$(realpath "${keystore_files[0]}")
                echo -n "$var [$suggested_file]: " >&2
                read -r value
                
                # 빈 값이면 제안된 파일 사용
                if [ -z "$value" ]; then
                    value="$suggested_file"
                    echo "제안된 파일을 사용합니다: $value" >&2
                fi
            else
                echo -n "$var: " >&2
                read -r value
            fi
        else
            echo -n "$var: " >&2
            read -r value
        fi
        
        if [ -z "$value" ]; then
            echo "" >&2
            echo -n "입력을 중단하시겠습니까? (Y/N): " >&2
            read -r confirm
            if [[ $confirm =~ ^[Yy]$ ]]; then
                echo "입력이 중단되었습니다." >&2
                return 1
            else
                echo -n "$var: " >&2
                read -r value
                if [ -z "$value" ]; then
                    echo "값이 필요합니다." >&2
                    return 1
                fi
            fi
        fi
        
        keystore_info+="$var=$value\n"
    done
    
    printf "%s" "$keystore_info"
    return 0
}

# gradle.properties 파일 업데이트
update_gradle_properties() {
    local namespace=$1
    local keystore_info=$2
    local gradle_props="$HOME/.gradle/gradle.properties"
    
    # 디렉토리 생성
    mkdir -p "$(dirname "$gradle_props")"
    
    # 기존 namespace 정보 제거
    if [ -f "$gradle_props" ]; then
        # namespace 섹션 시작부터 다음 섹션 시작까지 제거
        sed -i '' "/# $namespace/,/^# [^-]/d" "$gradle_props"
        # 마지막 줄이 namespace 섹션이면 제거
        sed -i '' "/# $namespace$/d" "$gradle_props"
    fi
    
    # 새 정보 추가
    echo -e "$keystore_info" >> "$gradle_props"
    echo "" >&2
    log_success "키스토어 정보가 저장되었습니다: $gradle_props"
}

# 초기 설정
init_keystore() {
    log_info "키스토어 초기 설정을 시작합니다..."
    
    # React Native 프로젝트 확인
    check_rn_project
    
    # namespace 추출
    local namespace=$(get_namespace)
    log_info "네임스페이스: $namespace"
    
    # 키스토어 변수 추출
    local vars=($(get_keystore_vars))
    if [ ${#vars[@]} -eq 0 ]; then
        log_error "키스토어 관련 변수를 찾을 수 없습니다."
        exit 1
    fi
    
    log_info "발견된 키스토어 변수들:"
    for var in "${vars[@]}"; do
        echo "  - $var"
    done
    echo ""
    
    # 키스토어 정보 입력
    local keystore_info
    keystore_info=$(input_keystore_info "$namespace" "${vars[@]}")
    if [ $? -ne 0 ]; then
        exit 1
    fi
    
    # gradle.properties 업데이트
    update_gradle_properties "$namespace" "$keystore_info"
    
    # 입력된 내용 확인
    echo ""
    log_success "설정 완료!"
    log_info "입력된 내용:"
    echo ""
    echo -e "${GREEN}==========================================${NC}"
    echo -e "$keystore_info"
    echo -e "${GREEN}==========================================${NC}"
}

# 정보 확인
check_keystore() {
    log_info "키스토어 정보를 확인합니다..."
    
    # React Native 프로젝트 확인
    check_rn_project
    
    # namespace 추출
    local namespace=$(get_namespace)
    log_info "네임스페이스: $namespace"
    
    # gradle.properties에서 해당 namespace 정보 찾기
    local gradle_props="$HOME/.gradle/gradle.properties"
    
    if [ ! -f "$gradle_props" ]; then
        log_error "키스토어 정보 파일이 없습니다: $gradle_props"
        exit 1
    fi
    
    # namespace 섹션 찾기
    local start_line=$(grep -n "^# $namespace" "$gradle_props" | cut -d: -f1)
    
    if [ -z "$start_line" ]; then
        log_warning "네임스페이스 '$namespace'의 키스토어 정보가 없습니다."
    else
        # 다음 섹션 시작까지 출력
        local end_line=$(tail -n +$((start_line + 1)) "$gradle_props" | grep -n "^# " | head -1 | cut -d: -f1)
        
        if [ -n "$end_line" ]; then
            end_line=$((start_line + end_line - 1))
            sed -n "${start_line},${end_line}p" "$gradle_props"
        else
            # 파일 끝까지 출력
            sed -n "${start_line},\$p" "$gradle_props"
        fi
    fi
    
    # 키스토어 파일 경로 출력
    echo ""
    log_info "키스토어 파일 경로:"
    local keystore_files=($(find android/app/ -name "*.jks" -type f 2>/dev/null))
    
    if [ ${#keystore_files[@]} -eq 0 ]; then
        log_warning "android/app/ 폴더에서 *.jks 파일을 찾을 수 없습니다."
    else
        for file in "${keystore_files[@]}"; do
            # 상대 경로를 절대 경로로 변환
            local abs_path=$(realpath "$file")
            echo "  - $abs_path"
        done
    fi
}

# 키스토어 alias 확인
check_keystore_alias() {
    log_info "키스토어 alias를 확인합니다..."
    
    # React Native 프로젝트 확인
    check_rn_project
    
    # android/app/ 폴더에서 *.jks 파일 찾기
    local keystore_files=($(find android/app/ -name "*.jks" -type f 2>/dev/null))
    
    if [ ${#keystore_files[@]} -eq 0 ]; then
        log_error "android/app/ 폴더에서 *.jks 파일을 찾을 수 없습니다."
        exit 1
    fi
    
    log_info "발견된 키스토어 파일들:"
    for file in "${keystore_files[@]}"; do
        echo "  - $file"
    done
    echo ""
    
    # 첫 번째 파일 사용 (여러 개가 있으면 첫 번째)
    local keystore_file="${keystore_files[0]}"
    log_info "사용할 키스토어 파일: $keystore_file"
    echo ""
    
    echo -n "이 키스토어 파일의 alias를 확인하시겠습니까? (Y/N): "
    read -r confirm
    
    if [[ $confirm =~ ^[Yy]$ ]]; then
        log_info "keytool 명령어를 실행합니다..."
        echo ""
        
        # keytool 실행 결과에서 alias 추출
        echo "키스토어 비밀번호를 입력하세요:"
        local temp_file=$(mktemp)
        keytool -list -v -keystore "$keystore_file" > "$temp_file" 2>/dev/null
        
        local alias_info=$(grep "별칭 이름:" "$temp_file")
        rm "$temp_file"
        
        if [ -n "$alias_info" ]; then
            # "별칭 이름: " 이후 부분 추출
            local alias=$(echo "$alias_info" | sed 's/별칭 이름: //')
            log_success "키스토어 alias: $alias"
        else
            log_error "alias 정보를 찾을 수 없습니다."
        fi
    else
        log_info "alias 확인을 취소했습니다."
    fi
}

# 도움말
show_help() {
    echo "Android Keystore 관리 스크립트"
    echo ""
    echo "사용법: ./keystore-manager [옵션]"
    echo ""
    echo "옵션:"
    echo "  --init, -i               키스토어 정보 초기 설정"
    echo "  --check, -c              현재 키스토어 정보 확인"
    echo "  --alias, -l              키스토어 alias 확인"
    echo "  --help, -h               도움말 표시"
    echo ""
    echo "예시:"
    echo "  ./keystore-manager --init"
    echo "  ./keystore-manager -c"
    echo "  ./keystore-manager --alias"
    echo ""
    echo "주의:"
    echo "  - React Native 프로젝트 최상위 폴더에서 실행해야 합니다."
    echo "  - 키스토어 정보는 ~/.gradle/gradle.properties에 저장됩니다."
}

# 메인 실행
case "$1" in
    "--init"|"-i")
        init_keystore
        ;;
    "--check"|"-c")
        check_keystore
        ;;
    "--alias"|"-l"|"alias")
        check_keystore_alias
        ;;
    "--help"|"-h"|"help"|"")
        show_help
        ;;
    *)
        log_error "알 수 없는 옵션: $1"
        echo ""
        show_help
        exit 1
        ;;
esac
