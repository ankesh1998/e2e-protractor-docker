FROM ubuntu:xenial
# Debian package configuration use the noninteractive frontend: It never interacts with the user at all, and makes the default answers be used for all questions.
# http://manpages.ubuntu.com/manpages/wily/man7/debconf.7.html
ENV DEBIAN_FRONTEND noninteractive

# Update is used to resynchronize the package index files from their sources. An update should always be performed before an upgrade.
RUN apt-get update -qqy \
  && apt-get -qqy install \
    apt-utils \
    wget \
    sudo \
    curl

RUN apt-get update && \
    apt-get install -y software-properties-common

# Latest Google Chrome installation package
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'

# Latest Ubuntu Firefox, Google Chrome, XVFB and JRE installs
RUN apt-get update -qqy \
  && apt-get -qqy install \
    xvfb \
    firefox=45.0.2+build1-0ubuntu1 \
    google-chrome-stable \
    default-jre \
    openjdk-8-jre-headless

RUN sudo apt-mark hold firefox


# Clean clears out the local repository of retrieved package files. Run apt-get clean from time to time to free up disk space.
RUN apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# 1. Step to fixing the error for Node.js native addon build tool (node-gyp)
# https://github.com/nodejs/node-gyp/issues/454
# https://github.com/npm/npm/issues/2952
# RUN rm -fr /root/tmp

    
FROM node:12.2.0 as build-step
WORKDIR /app

COPY . .

RUN npm install
RUN npm run protractor-version
# RUN /app/node_modules/protractor/bin/webdriver-manager clean
# RUN /app/node_modules/protractor/bin/webdriver-manager update
  # update Protractor and Selenium including ChromeDriver
RUN npm run webdriver-update
  # launch Selenium standalone in the background
RUN npm run webdriver-start
RUN npm run webdriver-status
RUN npm run e2e
RUN npm run build-prod

FROM nginx:1.16.1-alpine as prod-stage
COPY --from=build-step /app/dist /usr/share/nginx/html
