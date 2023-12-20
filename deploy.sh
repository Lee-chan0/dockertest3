# deploy.sh

# 이미지 이름은 Docker Hub에 있는 계정 및 프로젝트에 맞게 수정
DOCKER_USERNAME=leechan0
IMAGE_NAME=$DOCKER_USERNAME/app

# Docker 설치
sudo apt-get update
sudo apt-get install -y docker.io

# Docker 이미지 빌드
docker build -t $IMAGE_NAME .

# Docker Hub에 로그인
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

# Docker 이미지 푸시
docker push $IMAGE_NAME

# Nginx 서버 업데이트 및 재시작
sudo service nginx restart
