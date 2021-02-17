# Container image that runs your code
FROM node:lts-alpine

ARG GLIBC_VER=2.31-r0
ENV AWS_PAGER=""
RUN apk add --no-cache \
  bash \
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

ENV SONAR_SCANNER_VERSION 4.4.0.2170
ENV PATH $PATH:/sonar-scanner/bin
ADD "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip" /
RUN set -x \
	&& apk add --no-cache unzip openjdk11 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community \
  && unzip sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip \
  && mv -v /sonar-scanner-${SONAR_SCANNER_VERSION}  /sonar-scanner/  \
  && ln -s /sonar-scanner/bin/sonar-scanner       /usr/local/bin/     \
  && ln -s /sonar-scanner/bin/sonar-scanner-debug /usr/local/bin/ \
  && rm -f sonar-scanner-cli-*.zip


COPY . /
RUN chmod +x -R /scripts/* /*.sh
ENTRYPOINT ["/entrypoint.sh"]