#!/bin/bash
sed -i 's/server green:3000;/server blue:3000;/' ./nginx.conf
# docker-compose restart nginx
