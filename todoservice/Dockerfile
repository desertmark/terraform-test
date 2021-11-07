FROM node:lts-alpine as build

ARG BUILD_PORT=5001
ENV PORT=$BUILD_PORT

WORKDIR /usr/src/app

COPY ./package.json ./
RUN npm i

COPY . ./

ENTRYPOINT ["npm", "start"]