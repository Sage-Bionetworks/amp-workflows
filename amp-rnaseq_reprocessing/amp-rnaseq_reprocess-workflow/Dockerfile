FROM python:3.7-alpine

RUN apk update && \
    apk add --no-cache \
    build-base \
    linux-headers \
    libxml2-dev \
    libxslt-dev \
    libffi-dev \
    openssl \
    libressl-dev \
    musl-dev \
    nodejs \
    git 

RUN pip install --upgrade pip

RUN pip install cwlref-runner && \
  pip install synapseclient && \
  pip install git+https://github.com/tthyer/cwltest.git@test-arg && \
  pip install mockproc
