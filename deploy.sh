#!/bin/bash

# 현재 실행 중인 컨테이너 확인 (blue 또는 green)
CURRENT=$(docker ps --format '{{.Names}}' | grep -E 'finalcicd-(blue|green)-[0-9]+' | head -n 1 | cut -d'-' -f2)

echo "Current container: $CURRENT"

# Blue 컨테이너가 실행 중일 경우, Green을 배포
if [ "$CURRENT" == "blue" ]; then
    # Green 컨테이너를 빌드하고 실행합니다.
    docker-compose up -d --build green

    # Nginx가 green 컨테이너로 요청을 보내도록 설정 파일을 수정합니다.
    sed -i 's/blue:3000/green:3000/' ./nginx.conf

    # Nginx를 재시작하여 변경사항을 적용합니다.
    docker-compose restart nginx

    # Blue 컨테이너를 중단합니다.
    docker-compose stop blue

    # 헬스 체크를 수행하여 Green 컨테이너가 정상적으로 동작하는지 확인합니다.
    HEALTH_CHECK_URL="http://3.34.113.25/health"
    HEALTH_CHECK_INTERVAL=5  # 초 단위로 설정
    HEALTH_CHECK_TIMEOUT=3   # 초 단위로 설정
    HEALTH_CHECK_RETRIES=3  # 재시도 횟수

    echo "Performing health check for Green container..."
    health_check() {
        local retries=0
        until [ $retries -ge $HEALTH_CHECK_RETRIES ]
        do
            curl --connect-timeout $HEALTH_CHECK_TIMEOUT --max-time $HEALTH_CHECK_TIMEOUT -f $HEALTH_CHECK_URL && break
            retries=$((retries+1))
            echo "Health check failed. Retrying..."
            sleep $HEALTH_CHECK_INTERVAL
        done
        if [ $retries -ge $HEALTH_CHECK_RETRIES ]; then
            echo "Health check failed after $HEALTH_CHECK_RETRIES retries. Rolling back..."
            # 롤백 로직 추가
            exit 1
        fi
        echo "Health check passed. Switching traffic to Green container."
    }

    health_check

# Green 컨테이너가 실행 중일 경우, Blue를 배포
elif [ "$CURRENT" == "green" ]; then
    # Blue 컨테이너를 빌드하고 실행합니다.
    docker-compose up -d --build blue

    # Nginx가 blue 컨테이너로 요청을 보내도록 설정 파일을 수정합니다.
    sed -i 's/green:3000/blue:3000/' ./nginx.conf

    # Nginx를 재시작하여 변경사항을 적용합니다.
    docker-compose restart nginx

    # Green 컨테이너를 중단합니다.
    docker-compose stop green

    # 헬스 체크를 수행하여 Blue 컨테이너가 정상적으로 동작하는지 확인합니다.
    HEALTH_CHECK_URL="http://3.34.113.25/health"
    HEALTH_CHECK_INTERVAL=5  # 초 단위로 설정
    HEALTH_CHECK_TIMEOUT=3   # 초 단위로 설정
    HEALTH_CHECK_RETRIES=3  # 재시도 횟수

    echo "Performing health check for Blue container..."
    health_check() {
        local retries=0
        until [ $retries -ge $HEALTH_CHECK_RETRIES ]
        do
            curl --connect-timeout $HEALTH_CHECK_TIMEOUT --max-time $HEALTH_CHECK_TIMEOUT -f $HEALTH_CHECK_URL && break
            retries=$((retries+1))
            echo "Health check failed. Retrying..."
            sleep $HEALTH_CHECK_INTERVAL
        done
        if [ $retries -ge $HEALTH_CHECK_RETRIES ]; then
            echo "Health check failed after $HEALTH_CHECK_RETRIES retries. Rolling back..."
            # 롤백 로직 추가
            exit 1
        fi
        echo "Health check passed. Switching traffic to Blue container."
    }

    health_check
fi
