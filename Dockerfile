FROM node:21.2.0
RUN mkdir -p /usr/src/nuxt-app
WORKDIR /usr/src/nuxt-app

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

ENV NUXT_HOST=0.0.0.0
ENV NUXT_PORT=8080

CMD [ "npm", "start" ]