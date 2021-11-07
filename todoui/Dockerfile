FROM node:lts-alpine

WORKDIR /usr/src/app

COPY package.json ./
RUN npm i 

COPY . ./

RUN npm run build --prod

EXPOSE 80

ENTRYPOINT ["npm", "run", "serve:dist" ]
