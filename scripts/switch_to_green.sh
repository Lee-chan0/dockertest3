#!/bin/bash
sed -i 's/server blue:3000;/server green:3000;/' ./nginx.conf
docker-compose restart nginx