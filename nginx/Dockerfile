FROM node:lts-alpine as build

# todoservice url
ARG BUILD_API_URL
ENV API_URL=$BUILD_API_URL

# todoui url
ARG BUILD_ROOT_URL
ENV ROOT_URL=$BUILD_ROOT_URL

WORKDIR /usr/src/app

COPY ./ .

RUN npm i

# Generate nginx.conf
RUN npm run build:conf

# debug
RUN cat ./nginx.conf

# Stage 2
FROM nginx:alpine

ARG BUILD_API_URL
ENV API_URL=$BUILD_API_URL

COPY --from=build /usr/src/app/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

ENTRYPOINT ["nginx", "-g", "daemon off;" ]
