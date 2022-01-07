# Update the base image in Makefile when updating golang version. This has to
# be pre-pulled in order to work on GCB.
ARG ARCH
FROM golang:1.16.8 as build

WORKDIR /go/src/sigs.k8s.io/metrics-server
ENV GOPROXY "https://goproxy.cn,direct"
COPY go.mod .
COPY go.sum .
RUN go mod download

COPY pkg pkg
COPY cmd cmd
COPY Makefile Makefile

ARG ARCH
ARG GIT_COMMIT
ARG GIT_TAG
RUN make metrics-server

COPY /go/src/sigs.k8s.io/metrics-server/metrics-server /
USER 65534
ENTRYPOINT ["/metrics-server"]

# FROM gcr.io/distroless/static:latest-$ARCH
# COPY --from=build /go/src/sigs.k8s.io/metrics-server/metrics-server /
# USER 65534
# ENTRYPOINT ["/metrics-server"]
