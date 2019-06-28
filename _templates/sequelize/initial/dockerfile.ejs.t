---
to: app/Dockerfile
---
FROM node:10.15.0-alpine

ENV NODE_ENV production
ENV PORT 8080

ENV DB_HOST <%= dbHost %>
ENV DB_USER <%= dbUser %>
ENV DB_PASSWORD <%= dbPassword %>

MAINTAINER <%= dbUser %>

RUN npm i -g npm
RUN npm i -g yarn
RUN apk update && apk --no-cache add g++ gcc libgcc libstdc++ linux-headers make python git openssh
RUN yarn global add node-gyp
RUN mkdir /home/src && mkdir /home/src/api

COPY ./ /home/src/api

WORKDIR /home/src/api

RUN npm install
RUN npm rebuild bcrypt --build-from-source
RUN npm run build

EXPOSE 8080

CMD ["yarn", "start:production"]
