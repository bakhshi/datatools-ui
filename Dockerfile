FROM node:12

COPY ./ /datatools-ui

WORKDIR /datatools-ui

RUN yarn
RUN npm run build -- --minify