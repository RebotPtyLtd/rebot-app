# my-office-app/Dockerfile

# Base image
FROM node:22 AS base
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy all files
COPY . .

# --- Development Stage ---
FROM base AS development
ENV NODE_ENV=development
EXPOSE 3000
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0", "--port", "3000"]

# --- Production Build Stage ---
FROM base AS build
ENV NODE_ENV=production
RUN npm run build

# --- Production Runtime Stage ---
FROM node:22 AS production
WORKDIR /app
ENV NODE_ENV=production

# Only copy production dependencies
COPY package*.json ./
RUN npm install --omit=dev

# Copy built app from build stage
COPY --from=build /app/build ./build
COPY --from=build /app/package.json ./
COPY --from=build /app/.svelte-kit ./.svelte-kit
COPY --from=build /app/static ./static

EXPOSE 3500
CMD ["node", "build"]