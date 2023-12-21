# 예: deploy.sh 스크립트
DOCKER_USERNAME=leechan0
IMAGE_NAME=$DOCKER_USERNAME/app

# 이미지 빌드
docker build -t $IMAGE_NAME:$GITHUB_SHA .

# Docker Hub에 로그인
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

# Docker 이미지 푸시
docker push $IMAGE_NAME:$GITHUB_SHA

# Nginx 업스트림 변경
sed -i 's/backend-blue/backend-green/' /etc/nginx/nginx.conf
sed -i 's/3000/4000/' /etc/nginx/nginx.conf  # 포트 변경

# Nginx 서버 재시작
sudo service nginx restart

# Docker 컨테이너 실행 (예시)
docker run -d -p 3000:3000 $IMAGE_NAME:$GITHUB_SHA  # 포트 변경
