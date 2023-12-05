FROM node:21.2.0
WORKDIR /usr/app

COPY pages ./pages
COPY plugins ./plugins
COPY public ./public
COPY server ./server
COPY app.vue .
COPY nuxt.config.ts .
COPY package-lock.json .
COPY package.json .
COPY tsconfig.json .

RUN npm install
RUN pwd
RUN ls -al
RUN npm run build

USER node
EXPOSE 8080

ENTRYPOINT [ "npm run start" ]