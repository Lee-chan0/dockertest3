REPOSITORY=/home/ubuntu/finalCICD
BLUE_SERVER=$REPOSITORY/blue
GREEN_SERVER=$REPOSITORY/green
CURRENT_SERVER=$REPOSITORY/current

# 현재 서버를 'current'로 지정
ln -snf $BLUE_SERVER $CURRENT_SERVER

# 'current' 서버의 포트 확인
CURRENT_PORT=$(sudo lsof -t -i:3000)

# 서비스 중단
sudo kill -s SIGTERM $CURRENT_PORT

# 새로운 서버 빌드 및 실행
cd $REPOSITORY
chmod +x deploy.sh
sudo npm ci
./deploy.sh

# 서비스 시작
sudo npm start
