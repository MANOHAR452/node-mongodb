sudo mkdir /app
sudo cd /app
sudo cat > /app/docker-compose.yml <<'EOF'
version: '2.2'
services:
  mongo:
    image: mongo
    ports: 
      - "27017:27017" 
    restart: always 
  web:
    image: manohar4524/node-mongodb:latest
    ports: 
      - 3000
    environment:
      - MONGO_HOST=mongo
    scale: 3
    restart: always
  lb:
    image: dockercloud/haproxy
    ports:
      - 80:80
    links:
      - web
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock 
EOF
docker-compose down
docker-compose up -d 
