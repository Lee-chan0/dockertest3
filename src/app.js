import express from 'express';
import userRouter from './routes/users.js';

const app = express();

app.use('/', [userRouter]);
app.use(express.json());



app.get('/', (req, res) => {
    res.send('Welcome Docker with Express!!');
});

app.listen(3000, () => {
    console.log('Server is Open');
});