FROM node:20.18 AS base

RUN npm i -g pnpm

FROM base AS dependencies

WORKDIR /usr/src/app

COPY package.json pnpm-lock.yaml ./

RUN pnpm install

FROM base AS build

WORKDIR /usr/src/app

COPY . .
COPY --from=dependencies /usr/src/app/node_modules ./node_modules

RUN pnpm build
RUN pnpm prune --prod

FROM gcr.io/distroless/nodejs20-debian12 AS production

USER 1000

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/package.json ./package.json

ENV CLOUDFLARE_ACCESS_KEY_ID="#"
ENV CLOUDFLARE_SECRET_ACCESS_KEY="#"
ENV CLOUDFLARE_BUCKET="upload-widget"
ENV CLOUDFLARE_ACCOUNT_ID="#"
ENV CLOUDFLARE_PUBLIC_URL="https://pub-8656f1a8f80e4daebc51bf17b47cd0fb.r2.dev"

EXPOSE 3333

CMD ["dist/server.mjs"]