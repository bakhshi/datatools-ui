FROM node:12 AS build-stage

COPY ./ /datatools-ui

WORKDIR /datatools-ui


ARG GRAPH_HOPPER_URL
ENV GRAPH_HOPPER_URL=${GRAPH_HOPPER_URL}

ARG AUTH0_CLIENT_ID
ENV AUTH0_CLIENT_ID=${AUTH0_CLIENT_ID}

ARG AUTH0_DOMAIN
ENV AUTH0_DOMAIN=${AUTH0_DOMAIN}

ARG MAPBOX_ACCESS_TOKEN
ENV MAPBOX_ACCESS_TOKEN=${MAPBOX_ACCESS_TOKEN}

ARG GRAPH_HOPPER_KEY
ENV GRAPH_HOPPER_KEY=${GRAPH_HOPPER_KEY}

ENV MAPBOX_MAP_ID=mapbox/outdoors-v11
ENV MAPBOX_ATTRIBUTION=mapbox
ENV DISABLE_AUTH=true

RUN yarn
RUN npm run build -- --minify


FROM nginx:alpine

# Remove the default Nginx configuration file
RUN rm /etc/nginx/conf.d/default.conf

# Copy our custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/

# Copy the custom startup script into the container
COPY start-nginx.sh /start-nginx.sh

# Give execute permissions to the script
RUN chmod +x /start-nginx.sh

# Copy the build output from the previous stage
COPY --from=build-stage /datatools-ui/dist /usr/share/nginx/html/dist
COPY --from=build-stage /datatools-ui/index.html /usr/share/nginx/html/index.html

CMD ["/start-nginx.sh"]