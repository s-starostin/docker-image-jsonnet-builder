# Install required libraries 
FROM golang:1.15.0-alpine AS builder

RUN apk update && apk upgrade && \
    apk add --no-cache git && \
    rm -rf /var/lib/apt/lists/* 

RUN go get github.com/google/go-jsonnet/cmd/jsonnet
    
RUN go get github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb && \
    jb init && \
    jb install https://github.com/grafana/grafonnet-lib/grafonnet

# Create image for dashboard generation
FROM alpine:3.12

WORKDIR /dashboards

COPY --from=builder /go/vendor vendor
COPY --from=builder /go/bin/jsonnet /usr/local/bin/

ENV JSONNET_PATH=/dashboards/vendor
CMD [ "jsonnet", "-" ]