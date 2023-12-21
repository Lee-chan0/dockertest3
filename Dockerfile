# Dockerfile

# 기존 버전의 Node.js 이미지를 사용
FROM node:18

# 앱 소스 코드 복사
COPY . /app

# 작업 디렉토리 설정
WORKDIR /app

# 의존성 설치
RUN npm install

# 앱 실행
CMD ["node", "src/app.js"]
