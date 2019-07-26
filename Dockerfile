FROM golang:1.11.12 AS build
RUN mkdir /asgard-koinnews
WORKDIR /asgard-koinnews
COPY go.mod .
COPY go.sum .
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -a -installsuffix cgo -o /asgard-koinnews/bin

FROM alpine:3.10.0 as certs
RUN apk --update add ca-certificates

FROM scratch
LABEL maintainer="adysta.galang@koinworks.com"
COPY --from=build /asgard-koinnews/bin ./asgard-koinnews
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY documentation ./documentation
COPY env.example ./.env
EXPOSE 45005
CMD ["./asgard-koinnews"]