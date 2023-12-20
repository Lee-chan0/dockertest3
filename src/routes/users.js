import express from 'express';
import {prisma} from '../utils/prisma/index.js';


const router = express.Router();

router.get('/userinfo', async(req, res, next) => {
    const userinfo = await prisma.users.findMany({
        where : {username : 'John'}
    })

    return res.status(201).json({data : userinfo})
})

export default router;