import express from "express";
import userRouter from "./routes/users.js";
import { v4 as uuidv4 } from "uuid";
import os from 'os';

const app = express();
let id = uuidv4();
const PORT = 3000;

app.use("/", [userRouter]);
app.use(express.json());

app.get("/", (req, res) => {
  res.send("lets go");
});

// 헬스 체크 엔드포인트 추가
app.get("/health", (req, res) => {
  // 서버의 현재 상태 확인
  const isServerOnline = true; // 여기에 실제 서버 상태 확인 로직을 추가하세요

  // 서버 시작 시간 확인
  const serverStartTime = new Date().toISOString();

  // 서버의 CPU 및 메모리 사용량 확인
  const cpuUsage = os.loadavg()[0]; // CPU 사용량 (1분 평균)
  const totalMemory = os.totalmem();
  const freeMemory = os.freemem();
  const usedMemory = totalMemory - freeMemory;

  // 사용 가능한 디스크 공간 확인 (예: 루트 디렉토리)
  const diskInfo = os.cpus(); // 여기에 실제 디스크 정보 확인 로직을 추가하세요

  // 응답 데이터 구성
  const healthStatus = {
    serverStatus: isServerOnline ? "Online" : "Offline",
    serverStartTime: serverStartTime,
    cpuUsage: cpuUsage,
    memoryUsage: {
      total: totalMemory,
      used: usedMemory,
      free: freeMemory,
    },
    diskSpace: diskInfo,
  };

  // 헬스 체크가 성공한 경우
  if (isServerOnline) {
    res.status(200).json(healthStatus);
  } else {
    // 서버가 오프라인인 경우
    res.status(503).json({ serverStatus: "Offline" });
  }
});

app.listen(PORT, () => {
  console.log("Server is Open");
});
