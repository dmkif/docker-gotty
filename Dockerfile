FROM golang:latest AS gotty
RUN go get github.com/yudai/gotty && \
    env GOARCH=@@ARCH@@ go build github.com/yudai/gotty

FROM dmkif/gnucobol:@@ARCH@@-latest
MAINTAINER Daniel Mulzer <daniel.mulzer@fau.de>

WORKDIR /opt/cobol

COPY --from=gotty /go/bin/gotty .

EXPOSE 8081

# Execute Gotty
ENTRYPOINT ["./gotty"]
#Default arguments ...
CMD ["--port","8081","--permit-write","/bin/bash"]

