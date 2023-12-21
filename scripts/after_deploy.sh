REPOSITORY=/home/ubuntu/finalCICD

cd $REPOSITORY

chmod +x deploy.sh

sudo npm ci

./deploy.sh

npm start