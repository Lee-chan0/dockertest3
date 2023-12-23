REPOSITORY=/home/ubuntu/finalCICD

cd $REPOSITORY

sudo npm ci

chmod +x ./deploy.sh

./deploy.sh

docker-compose restart nginx