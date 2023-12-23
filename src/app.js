import express from 'express';
import userRouter from './routes/users.js';
import {v4 as uuidv4} from 'uuid';

const app = express();
let id = uuidv4();
const PORT = 3000;

app.use('/', [userRouter]);
app.use(express.json());



app.get('/', (req, res) => {
    res.send('고유한 서버 ID : ', id);
});

app.listen(PORT, () => {
    console.log('Server is Open');
});