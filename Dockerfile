# --- Etapa 1: Construcción y Dependencias ---
FROM node:18-alpine AS builder
WORKDIR /usr/src/app

# Copiar manifiestos de dependencias
COPY package*.json ./

# Instalar todas las dependencias
RUN npm ci --only=production
COPY . .

# --- Etapa 2: Entorno de Ejecución Seguro (Producción) ---
FROM node:18-alpine
WORKDIR /usr/src/app
ENV NODE_ENV=production

# Copiar el código limpio desde la etapa de construcción
COPY --from=builder /usr/src/app ./

# SEGURIDAD: Cambiar al usuario "node" (no-root) para mitigar vulnerabilidades
USER node

# Exponer el puerto de la API Express
EXPOSE 3000

# Comando para iniciar la aplicación
CMD ["node", "server.js"]