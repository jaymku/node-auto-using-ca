FROM alpine:latest

RUN apk add --no-cache curl

ENTRYPOINT ["watch", "-n", "1", "curl", "http://node-web-app-auto:3000/"]