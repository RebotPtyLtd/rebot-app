FROM node:20

WORKDIR /app

COPY package*.json ./
RUN rm -rf node_modules package-lock.json && npm cache clean --force && npm install && npm rebuild

COPY . .
RUN npm run prepare

EXPOSE 5173
