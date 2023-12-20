FROM node:18

WORKDIR /home/ubuntu/finalCICD

COPY . .

RUN npm ci

CMD [ "node","src/app.js"]