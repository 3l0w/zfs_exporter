FROM golang:1.24-alpine

WORKDIR /opt/app

# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change
COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN go build

FROM evandeaubl/zfs

WORKDIR /opt/app

COPY --from=0 /opt/app/zfs_exporter .

EXPOSE 9134

ENTRYPOINT ["./zfs_exporter"]

