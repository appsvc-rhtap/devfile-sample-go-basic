FROM --platform=${BUILDPLATFORM:-linux/amd64} golang:1.20 as builder

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TARGETOS
ARG TARGETARCH

WORKDIR /app
COPY go.mod ./
RUN go mod download
COPY *.go ./
ENV TREE 3
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -ldflags="-w -s" -o /goapp
ENV PORT 8081
EXPOSE 8081
# Run

FROM --platform=${TARGETPLATFORM:-linux/amd64} bash:latest
WORKDIR /
COPY --from=builder /goapp /goapp
CMD [ "/goapp" ]