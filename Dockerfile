FROM node:alpine AS build

WORKDIR /app

COPY package*.json ./

RUN npm ci --only=production

COPY . .

# 2단계: 런타임 스테이지
FROM node:alpine

WORKDIR /app

# 빌드 단계에서 production dependencies만 복사
COPY --from=build /app /app

EXPOSE 8080

CMD ["node", "server.js"]
