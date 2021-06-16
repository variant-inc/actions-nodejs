# Container image that runs your code
FROM node:lts-alpine

ARG BUILD_DATE
ARG BUILD_REVISION
ARG BUILD_VERSION

LABEL com.github.actions.name="Lazy Action NodeJS" \
  com.github.actions.description="Build and Push NodeJS Image" \
  com.github.actions.icon="code" \
  com.github.actions.color="red" \
  maintainer="Variant DevOps <devops@drivevariant.com>" \
  org.opencontainers.image.created=$BUILD_DATE \
  org.opencontainers.image.revision=$BUILD_REVISION \
  org.opencontainers.image.version=$BUILD_VERSION \
  org.opencontainers.image.authors="Variant DevOps <devops@drivevariant.com>" \
  org.opencontainers.image.url="https://github.com/variant-inc/actions-nodejs" \
  org.opencontainers.image.source="https://github.com/variant-inc/actions-nodejs" \
  org.opencontainers.image.documentation="https://github.com/variant-inc/actions-nodejs" \
  org.opencontainers.image.vendor="AWS ECR" \
  org.opencontainers.image.description="Build and Push NodeJS Packages"

ARG GLIBC_VER=2.31-r0
ENV AWS_PAGER=""
RUN apk add --no-cache \
  git \
  wget \
  bash \
  sudo \
  git \
  curl \
  tzdata \
  ca-certificates \
  docker-cli \
  openjdk11 \
  jq \
  binutils &&\
  rm -rf /var/lib/apt/lists/* &&\
  \
  curl -sL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub &&\
  curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk &&\
  curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk &&\
  apk add --no-cache glibc-${GLIBC_VER}.apk glibc-bin-${GLIBC_VER}.apk &&\
  \
  curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip &&\
  unzip awscliv2.zip &&\
  aws/install &&\
  rm -rf \
  awscliv2.zip \
  aws \
  /usr/local/aws-cli/v2/*/dist/aws_completer \
  /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index \
  /usr/local/aws-cli/v2/*/dist/awscli/examples \
  glibc-${GLIBC_VER}.apk \
  glibc-bin-${GLIBC_VER}.apk &&\
  rm -rf /var/cache/apk/* &&\
  aws --version

ARG SONAR_SCANNER_VERSION=4.4.0.2170
ENV PATH $PATH:/sonar-scanner/bin
RUN set -x \
  && curl --insecure -o /sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip \
    -L https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip \
  && apk add --no-cache unzip openjdk11 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community \
  && unzip sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip \
  && mv -v /sonar-scanner-${SONAR_SCANNER_VERSION}  /sonar-scanner/  \
  && ln -s /sonar-scanner/bin/sonar-scanner       /usr/local/bin/     \
  && ln -s /sonar-scanner/bin/sonar-scanner-debug /usr/local/bin/ \
  && rm -f sonar-scanner-cli-*.zip

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/master/contrib/install.sh | sh -s -- -b /usr/local/bin

# Install python/pip
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 \
  && ln -sf python3 /usr/bin/python &&\
  python3 -m ensurepip &&\
  pip3 install --no-cache --upgrade pip --no-cache-dir setuptools

# Adding make for prometheus middleware dependency in node applications
RUN apk add --update --no-cache make gcc g++

COPY . /
RUN chmod +x -R /scripts/* /*.sh
ENTRYPOINT ["/entrypoint.sh"]