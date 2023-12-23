#!/bin/bash

CURRENT=$(docker ps --format '{{.Names}}' | grep -E 'finalcicd-(blue|green)-[0-9]+' | head -n 1 | cut -d'-' -f2)

echo "Current container: $CURRENT"

if [ "$CURRENT" == "blue" ]; then
    # Green 컨테이너 구동
    docker-compose up -d --build green

    # 헬스 체크
    echo "Performing health check for Green container..."
    HEALTH_CHECK() {
        local retries=0
        until [ $retries -ge 3 ]; do
            if curl --connect-timeout 3 --max-time 3 -f http://3.34.113.25/health; then
                echo "Health check passed. Switching traffic to Green container."
                return 0
            else
                retries=$((retries+1))
                echo "Health check failed. Retrying in 5 seconds..."
                sleep 5
            fi
        done
        echo "Health check failed. Rolling back to Blue container."
        docker-compose stop green
        exit 1
    }

    HEALTH_CHECK

    # Nginx 설정 변경 및 재시작
    sed -i 's/blue:3000/green:3000/' ./nginx.conf
    docker-compose restart nginx

    # 이전 컨테이너 중지
    docker-compose stop blue

elif [ "$CURRENT" == "green" ]; then
    # Blue 컨테이너 구동
    docker-compose up -d --build blue

    # 헬스 체크
    echo "Performing health check for Blue container..."
    HEALTH_CHECK() {
        local retries=0
        until [ $retries -ge 3 ]; do
            if curl --connect-timeout 3 --max-time 3 -f http://3.34.113.25/health; then
                echo "Health check passed. Switching traffic to Blue container."
                return 0
            else
                retries=$((retries+1))
                echo "Health check failed. Retrying in 5 seconds..."
                sleep 5
            fi
        done
        echo "Health check failed. Rolling back to Green container."
        docker-compose stop blue
        exit 1
    }

    HEALTH_CHECK

    # Nginx 설정 변경 및 재시작
    sed -i 's/green:3000/blue:3000/' ./nginx.conf
    docker-compose restart nginx

    # 이전 컨테이너 중지
    docker-compose stop green
fi
