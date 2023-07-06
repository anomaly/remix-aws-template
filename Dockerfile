ARG NODE_VERSION=18-alpine

# Build docker image
FROM node:${NODE_VERSION} as build-stage

WORKDIR /opt/app

COPY ./package.json ./
RUN npm install

COPY ./. .

RUN npm run build

# Stage 2

FROM node:${NODE_VERSION} 
LABEL maintainer="Anomaly Software <packages@anomaly.ltd>"
LABEL description="Remix AWS template"

ENV NODE_ENV=production
ENV PORT=80
ENV PROBES_PORT=9000

WORKDIR /opt/app

COPY --from=build-stage /opt/app/. ./

RUN npm ci --omit=dev

EXPOSE ${PORT}
EXPOSE ${PROBES_PORT}

CMD ["npm", "run", "start"]
