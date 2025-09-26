# ---- web build (Vue) ----
FROM node:20-alpine AS webbuilder
WORKDIR /web
COPY web/package*.json ./
RUN npm ci
COPY web/ ./
RUN npm run build

# ---- api build ----
FROM node:20-alpine AS apibuilder
WORKDIR /app
COPY api/package*.json ./
RUN npm ci --omit=dev
COPY api/ ./

# ---- runtime ----
FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
ENV PORT=3000

# API code + node_modules
COPY --from=apibuilder /app /app

# Statics du front (Vite) servis par Express
COPY --from=webbuilder /web/dist /app/public

EXPOSE 3000
CMD ["node", "src/index.js"]