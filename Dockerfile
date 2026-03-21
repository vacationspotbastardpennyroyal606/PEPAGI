# ── Stage 1: Build ────────────────────────────────────────────
FROM node:22-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# ── Stage 2: Production ──────────────────────────────────────
FROM node:22-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev
COPY --from=builder /app/dist ./dist

ENV NODE_ENV=production
ENV PEPAGI_DATA_DIR=/data
ENV PEPAGI_HOST=0.0.0.0
VOLUME ["/data"]
EXPOSE 3099 3100
CMD ["node", "dist/daemon.js"]
