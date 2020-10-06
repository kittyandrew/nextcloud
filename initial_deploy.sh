docker-compose up -d db
docker-compose up -d redis
# Give DBs some time to spin up
sleep 5
docker-compose up -d --build
