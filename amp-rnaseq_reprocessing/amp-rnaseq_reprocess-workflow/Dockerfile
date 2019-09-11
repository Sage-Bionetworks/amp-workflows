FROM python:3.7-alpine

RUN apk update && \
  apk add --no-cache linux-headers build-base libxml2-dev libxslt-dev nodejs

RUN pip install cwlref-runner cwltest
