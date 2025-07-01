FROM node:20

WORKDIR /app

COPY package*.json ./
RUN npm install && npm install svelte-easy-toast

COPY . .

EXPOSE 5173
