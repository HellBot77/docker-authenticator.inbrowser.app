FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/InBrowserApp/authenticator.inbrowser.app.git && \
    cd authenticator.inbrowser.app && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node:alpine AS build

WORKDIR /authenticator.inbrowser.app
COPY --from=base /git/authenticator.inbrowser.app .
RUN npm install --global pnpm && \
    pnpm install && \
    pnpm build

FROM lipanski/docker-static-website

COPY --from=build /authenticator.inbrowser.app/dist .
