FROM node:lts-alpine

ARG BUILD_DATE
ARG BUILD_REVISION
ARG BUILD_VERSION

LABEL com.github.actions.name="Lazy Action NodeJS" \
  com.github.actions.description="Build and Push Dotnet Packages" \
  com.github.actions.icon="code" \
  com.github.actions.color="red" \
  maintainer="Variant DevOps <devops@drivevariant.com>" \
  org.opencontainers.image.created=$BUILD_DATE \
  org.opencontainers.image.revision=$BUILD_REVISION \
  org.opencontainers.image.version=$BUILD_VERSION \
  org.opencontainers.image.authors="Variant DevOps <devops@drivevariant.com>" \
  org.opencontainers.image.url="https://github.com/variant-inc/lazy-action-nodejs" \
  org.opencontainers.image.source="https://github.com/variant-inc/lazy-action-nodejs" \
  org.opencontainers.image.documentation="https://github.com/variant-inc/lazy-action-nodejs" \
  org.opencontainers.image.vendor="AWS ECR" \
  org.opencontainers.image.description="Build and Push Nodejs Packages"

COPY . /
# RUN chmod +x -R /scripts/* /*.sh

ENTRYPOINT ["/entrypoint.sh"]
