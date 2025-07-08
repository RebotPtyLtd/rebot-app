FROM node:22

WORKDIR /app

# Clean up any old artifacts before installing
RUN rm -rf node_modules package-lock.json .svelte-kit build

COPY package*.json ./

# Install adapter-node instead of adapter-auto
RUN npm install @sveltejs/adapter-node@latest --save-dev
RUN npm install

COPY . .

# Build the app for production
RUN npm run build

EXPOSE 3000

# Start the production server
CMD ["node", "build"]
