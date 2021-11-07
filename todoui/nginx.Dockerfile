FROM node:lts-alpine as build

ARG BUILD_API_URL
ENV API_URL=$BUILD_API_URL

WORKDIR /usr/src/app

COPY package.json ./
RUN npm i 

COPY . ./

## Generate nginx.conf
RUN node nginx.conf.js
RUN cat ./nginx.conf

RUN npm run build --prod

# Stage 2
FROM nginx:alpine

ARG BUILD_API_URL
ENV API_URL=$BUILD_API_URL

COPY --from=build /usr/src/app/dist/todoui /usr/share/nginx/html
COPY --from=build /usr/src/app/nginx.conf /etc/nginx/nginx.conf

EXPOSE 8080

ENTRYPOINT ["nginx", "-g", "daemon off;" ]
