#!/bin/bash

# 현재 실행 중인 컨테이너 확인 (blue 또는 green)
CURRENT=$(docker-compose ps | grep 'Up' | grep 'finalcicd-' | awk '{print $2}' | cut -d'-' -f2)

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
fi
