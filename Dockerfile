# Dockerfile for production
# Section 1: Build section --> install dependencies and build index.html ...
# tag this phase as builder phase
FROM node:16-alpine as builder

USER node

RUN mkdir -p /home/node/app
WORKDIR /home/node/app

COPY --chown=node:node ./package.json ./
RUN npm install

COPY --chown=node:node ./ ./

RUN npm run build

# Section 2: Run section --> copy over results from build folder and run nginx to run final application
#            and to remove unnecessary space required for dependencies that are only reuired for building
FROM nginx

# copy build folder from builder phase into current container
COPY --from=builder /home/node/app/build /usr/share/nginx/html 

# no startup needed to start up nginx because this alread happens from nginx image