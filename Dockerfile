FROM golang:1.11.12 AS build

FROM alpine:3.10.0 as certs
RUN apk --update add ca-certificates

FROM scratch
