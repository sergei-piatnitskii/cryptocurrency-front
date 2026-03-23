# --- Этап 1: Сборка ---
FROM node:18-alpine AS build
WORKDIR /app

# Копируем файлы зависимостей
COPY package.json package-lock.json* ./

# Используем --legacy-peer-deps, чтобы обойти конфликт версий типов React 17 и 18
RUN npm install --legacy-peer-deps

# Копируем остальной код и собираем проект
COPY . .
RUN npm run build

FROM nginx:stable-alpine
# Копируем наш конфиг
COPY default.conf /etc/nginx/conf.d/default.conf
# Копируем билд
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]