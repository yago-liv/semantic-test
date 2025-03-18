FROM node:20.15-alpine AS build
ARG _GCP_ENV
WORKDIR /src
COPY package.json ./
COPY . .
RUN npm install -g pnpm
RUN pnpm install --frozen-lockfile
RUN pnpm build

FROM nginx:latest AS webserver
EXPOSE 80

COPY nginx.conf /etc/nginx/nginx.conf
COPY docker-entrypoint.sh ./
COPY --from=build /src/dist /usr/share/nginx/html
RUN chmod +x ./docker-entrypoint.sh